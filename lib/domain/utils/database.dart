import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../concepts/person.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference userCollectionRef = db.collection('users');

// variables to save current documents in database
DocumentReference? currentGameSessionRef;
DocumentReference? currentLevelDataRef;

Future<QuerySnapshot> _findUserInFirestore({required Person person}) async {
  return await userCollectionRef
      .where('firstName', isEqualTo: person.firstName)
      .where('lastName', isEqualTo: person.lastName)
      .get();
}

Future<DocumentReference?> _findLatestGameSessionRef({required Person person}) async {
  QuerySnapshot userQuerySnapshot = await _findUserInFirestore(person: person);

  if (userQuerySnapshot.docs.length == 1) {
    debugPrint("Unique User Found.");

    QueryDocumentSnapshot docSnap = userQuerySnapshot.docs.first;
    CollectionReference gameSessionRef = docSnap.reference.collection('gameSessions');

    QuerySnapshot lastGameSessionSnap =
        await gameSessionRef.orderBy('startedOn', descending: true).limit(1).get();

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
    'level': level,
    'startedOn': DateTime.now(),
    'levelStatus': Status.active.name,
    'periods': 0,
    'cash': [startingCash],
  };

  CollectionReference levelDataRef = currentGameSessionRef!.collection('levelData');
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

Future<void> saveUserInFirestore(Person person) async {
  // get snapshot for specific user search
  QuerySnapshot userQuerySnapshot = await _findUserInFirestore(person: person);

  // save user if document does not exist yet
  if (userQuerySnapshot.docs.isEmpty) {
    debugPrint('save new user ${person.firstName} ${person.lastName} to firebase...');
    Map<String, dynamic> userEntry = <String, dynamic>{
      "firstName": person.firstName,
      "lastName": person.lastName,
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

  if (userQuerySnapshot.docs.length == 1) {
    debugPrint("Unique User Found.");

    QueryDocumentSnapshot docSnap = userQuerySnapshot.docs.first;
    CollectionReference gameSessionRef = docSnap.reference.collection('gameSessions');

    Map<String, dynamic> gameSessionContent = {
      'startedOn': DateTime.now(),
      'sessionStatus': Status.active.name,
    };

    currentGameSessionRef = await gameSessionRef.add(gameSessionContent);
    _createNewLevel(level: 1, startingCash: startingCash);
  }
}

Future<void> endCurrentGameSession({required Status status, Person? person}) async {
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
  }, SetOptions(merge: true));

  debugPrint("Ending current game session with status ${status.name}.");
  await currentGameSessionRef!.set({
    'sessionStatus': status.name,
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

void advancePeriodFirestore({required double newCashValue}) async {
  DocumentSnapshot docSnap = await currentLevelDataRef!.get();
  List<double> cashArray = List.from(docSnap.get('cash'));
  cashArray.add(double.parse(newCashValue.toStringAsFixed(2)));

  docSnap.reference.set(
      {
        'periods': FieldValue.increment(1),
        'cash': cashArray,
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
