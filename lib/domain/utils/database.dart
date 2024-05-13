import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_literacy_game/config/constants.dart';
import 'package:flutter/material.dart';

import '../concepts/asset.dart';
import '../concepts/person.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
// store the Firestore collection of users
CollectionReference userCollectionRef = db.collection('users');
// store the Firestore collection of uid user list
CollectionReference uidListsCollectionRef = db.collection('uidLists');

// variables to save current documents in database
DocumentReference? currentGameSessionRef;
DocumentReference? currentLevelDataRef;

Future<QuerySnapshot> _findUserInFirestoreByUID({required String uid}) async {
  // call to Firestore to look up user via uid that was entered
  return await userCollectionRef.where('uid', isEqualTo: uid).get();
}

Future<QuerySnapshot> _findUserInFirestore({required Person person}) async {
  return await userCollectionRef
      // look for current person in database
      .where('firstName', isEqualTo: person.firstName)
      .where('lastName', isEqualTo: person.lastName)
      .where('uid', isEqualTo: person.uid)
      .get();
}

Future<DocumentReference?> _findLatestGameSessionRef(
    {required Person person}) async {
  QuerySnapshot userQuerySnapshot = await _findUserInFirestore(person: person);

  if (userQuerySnapshot.docs.length == 1) {
    // TODO: Can we change this to make it more general?
    debugPrint("Unique User Found.");
    // get the first document in list
    QueryDocumentSnapshot docSnap = userQuerySnapshot.docs.first;
    CollectionReference gameSessionRef =
        docSnap.reference.collection('gameSessions');

    QuerySnapshot lastGameSessionSnap = await gameSessionRef
        .orderBy('startedOn', descending: true)
        .limit(1)
        .get();

    debugPrint("Last game session found.");
    return lastGameSessionSnap.docs.first.reference;
  } else {
    debugPrint("Last game session not found.");
    return null;
  }
}

void _createNewLevel({
  required int level,
  required double startingCash,
}) async {
  if (currentGameSessionRef == null) {
    debugPrint('Current game session could not be found.');
    return;
  }

  Map<String, dynamic> levelContent = {
    // information that gets saved to the database per level
    'level': level,
    'startedOn': DateTime.now(),
    'levelStatus': Status.active.name,
    'periods': 0,
    'cash': [startingCash],
    'decisions': [],
    'offeredAssets': [],
    'advanceTimes': [],
  };

  CollectionReference levelDataRef =
      currentGameSessionRef!.collection('levelData');
  currentLevelDataRef = await levelDataRef.add(levelContent);
}

void restartLevelFirebase({
  required int level,
  required double startingCash,
}) async {
  if (currentLevelDataRef == null) {
    return;
  }
  currentLevelDataRef!.set(
    {
      'levelStatus': Status.lost.name,
      'completedOn': DateTime.now(),
    },
    SetOptions(merge: true),
  );

  _createNewLevel(level: level, startingCash: startingCash);
}

Future<bool> reconnectToGameSession({required Person person}) async {
  currentGameSessionRef = await _findLatestGameSessionRef(person: person);
  if (currentGameSessionRef == null) {
    debugPrint("Could not find latest game session.");
    return false;
  }

  QuerySnapshot lastLevelSnapShot = await currentGameSessionRef!
      .collection('levelData')
      .orderBy('startedOn', descending: true)
      .limit(1)
      .get();

  if (lastLevelSnapShot.docs.length != 1) {
    return false;
  }

  currentLevelDataRef = lastLevelSnapShot.docs.first.reference;
  return true;
}

Future<Person?> searchUserbyUIDInFirestore(String uid) async {
  // get snapshot of users from Firestore
  QuerySnapshot userQuerySnapshot = await _findUserInFirestoreByUID(uid: uid);

  if (userQuerySnapshot.docs.isEmpty) {
    debugPrint("No active user found. Checking uid lists...");
    // get all documents from uidLists collection
    QuerySnapshot uidListsQuerySnapshot = await uidListsCollectionRef.get();
    for (QueryDocumentSnapshot docSnap in uidListsQuerySnapshot.docs) {
      // get uidList from document
      List<dynamic> uidList = docSnap.get('uids');
      // go through list that consists of users
      for (Map<String, dynamic> listEntry in uidList) {
        if (uid == listEntry['uid']) {
          // return the person connected to uid
          return Person(
            firstName: listEntry['firstName'],
            lastName: listEntry['lastName'],
            uid: listEntry['uid'],
          );
        }
      }
    }

    return null;
  } else {
    // if the user is not found in Firestore
    debugPrint("User with uid $uid found.");
    QueryDocumentSnapshot docSnap = userQuerySnapshot.docs.first;
    String firstName = docSnap.get('firstName');
    String lastName = docSnap.get('lastName');
    return Person(
      firstName: firstName,
      lastName: lastName,
      uid: uid,
    );
  }
}

Future<void> saveUserInFirestore(Person person) async {
  // get snapshot for specific user search
  QuerySnapshot userQuerySnapshot = await _findUserInFirestore(person: person);

  // save user if document does not exist yet
  if (userQuerySnapshot.docs.isEmpty) {
    debugPrint(
        'save new user ${person.firstName} ${person.lastName} to firebase...');
    Map<String, dynamic> userEntry = <String, dynamic>{
      "firstName": person.firstName,
      "lastName": person.lastName,
      "uid": person.uid,
      "createdOn": DateTime.now(),
    };
    await userCollectionRef.add(userEntry);
  }
  // otherwise do not save a new user
  else {
    debugPrint('User ${person.firstName} ${person.lastName} already exists');
    await endCurrentGameSession(status: Status.abandoned, person: person);
    debugPrint('Deactivate last game session');
  }
}

Future<void> startGameSession({
  required Person person,
  required double startingCash,
}) async {
  debugPrint("Starting new game session.");

  QuerySnapshot userQuerySnapshot = await _findUserInFirestore(person: person);

  if (userQuerySnapshot.docs.length != 1) {
    debugPrint("More than one user found.");
  }

  QueryDocumentSnapshot docSnap = userQuerySnapshot.docs.first;
  CollectionReference gameSessionRef =
      docSnap.reference.collection('gameSessions');

  Map<String, dynamic> gameSessionContent = {
    'startedOn': DateTime.now(),
    'sessionStatus': Status.active.name,
  };

  currentGameSessionRef = await gameSessionRef.add(gameSessionContent);
  _createNewLevel(level: 1, startingCash: startingCash);
}

Future<void> endCurrentGameSession(
    {required Status status, Person? person}) async {
  if (currentGameSessionRef == null) {
    debugPrint('No current game session could be found.');
    if (person == null) {
      debugPrint('User info was not given.');
      return;
    }
    bool reconnectSuccessful = await reconnectToGameSession(person: person);
    if (!reconnectSuccessful) {
      return;
    }
  }

  debugPrint("Closing current level with status ${status.name}.");
  await currentLevelDataRef!.set({
    'levelStatus': status.name,
    'completedOn': DateTime.now(),
  }, SetOptions(merge: true));

  debugPrint("Ending current game session with status ${status.name}.");
  await currentGameSessionRef!.set({
    'sessionStatus': status.name,
    'completedOn': DateTime.now(),
  }, SetOptions(merge: true));
}

void newLevelFirestore({
  required int levelID,
  required double startingCash,
}) async {
  currentLevelDataRef!.set(
    {'levelStatus': Status.won.name, 'completedOn': DateTime.now()},
    SetOptions(merge: true),
  );

  _createNewLevel(level: levelID + 1, startingCash: startingCash);
}

void advancePeriodFirestore({
  required double newCashValue,
  required BuyDecision buyDecision,
  required Asset offeredAsset,
}) async {
  DocumentSnapshot docSnap = await currentLevelDataRef!.get();
  // add cash value to list
  List<double> cashArray = List.from(docSnap.get('cash'));
  cashArray.add(double.parse(newCashValue.toStringAsFixed(2)));

  // add buy decision to list
  List<String> decisionArray = List.from(docSnap.get('decisions'));
  decisionArray.add(buyDecision.name);

  // add timestamp to list
  List timeArray = List<DateTime>.from(docSnap.get('advanceTimes'));
  timeArray.add(DateTime.now());

  // add cashROI to list
  List<Map<String, dynamic>> offeredAssets =
      List.from(docSnap.get('offeredAssets'));
  Map<String, dynamic> newMapFromAsset = {
    'type': offeredAsset.type.name,
    'price': offeredAsset.price,
    'income': offeredAsset.income,
    'riskLevel': offeredAsset.riskLevel,
    'lifeExpectancy': offeredAsset.lifeExpectancy,
  };
  offeredAssets.add(newMapFromAsset);

  docSnap.reference.set(
      {
        'periods': FieldValue.increment(1),
        'cash': cashArray,
        'decisions': decisionArray,
        'offeredAssets': offeredAssets,
        'advanceTimes': timeArray,
      },
      SetOptions(
        merge: true,
      ));
}

enum Status {
  active,
  won,
  lost,
  abandoned,
}

// enum LevelStatus {
//   active,
//   won,
//   lost,
// }
