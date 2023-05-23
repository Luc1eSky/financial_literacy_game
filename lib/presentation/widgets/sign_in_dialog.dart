import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/database.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../domain/utils/utils.dart';
import 'how_to_play_dialog.dart';
import 'menu_dialog.dart';

class SignInDialog extends ConsumerStatefulWidget {
  const SignInDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends ConsumerState<SignInDialog> {
  late TextEditingController firstNameTextController;
  late TextEditingController lastNameTextController;

  Future<bool> setPersonData(Person enteredPerson) async {
    if (enteredPerson.firstName == '' || enteredPerson.lastName == '') {
      showErrorSnackBar(
        context: context,
        errorMessage: 'Please enter first and last name.',
      );
      return false;
    }

    // remove whitespaces
    String trimmedFirstName = enteredPerson.firstName!.trim();
    String trimmedLastName = enteredPerson.lastName!.trim();

    // remove leading or trailing dashes ("-")
    String cleanedFirstName = removeTrailing("-", trimmedFirstName);
    cleanedFirstName = removeLeading("-", cleanedFirstName);
    String cleanedLastName = removeTrailing("-", trimmedLastName);
    cleanedLastName = removeLeading("-", cleanedLastName);

    // Capitalize first letter and lowe case all other letters
    cleanedFirstName =
        "${cleanedFirstName[0].toUpperCase()}${cleanedFirstName.substring(1).toLowerCase()}";
    cleanedLastName =
        "${cleanedLastName[0].toUpperCase()}${cleanedLastName.substring(1).toLowerCase()}";

    Person cleanedPerson = Person(
      firstName: cleanedFirstName,
      lastName: cleanedLastName,
    );

    ref.read(gameDataNotifierProvider.notifier).setPerson(cleanedPerson);
    savePersonLocally(cleanedPerson);
    await saveUserInFirestore(cleanedPerson);

    ref.read(gameDataNotifierProvider.notifier).resetGame();

    return true;
  }

  @override
  void initState() {
    super.initState();
    firstNameTextController = TextEditingController();
    lastNameTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameTextController.dispose();
    lastNameTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuDialog(
      showCloseButton: false,
      title: 'Welcome to the FinSim Game',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom == 0 ? 150 : 100,
            child: const SingleChildScrollView(
              child: Text(
                "Dear participants,"
                "This game is meant to mimic financial investments."
                " It will only be used for the purpose of teaching. "
                "This game will not affect the relationship with your bank.\n\n"
                "Please enter your contact info below:",
              ),
            ),
          ),
          TextField(
            controller: firstNameTextController,
            decoration: const InputDecoration(hintText: "First name"),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
            ],
          ),
          TextField(
            controller: lastNameTextController,
            decoration: const InputDecoration(hintText: "Last name"),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
            ],
          ),
        ],
      ),
      actions: [
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     elevation: 5.0,
        //     backgroundColor: ColorPalette().buttonBackground,
        //     foregroundColor: ColorPalette().lightText,
        //   ),
        //   onPressed: () {
        //     if (setPersonData(
        //       Person(
        //         firstName: firstNameTextController.text,
        //         lastName: lastNameTextController.text,
        //       ),
        //     )) Navigator.of(context).pop();
        //   },
        //   child: const Text('Start game'),
        // ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            backgroundColor: ColorPalette().buttonBackground,
            foregroundColor: ColorPalette().lightText,
          ),
          onPressed: () async {
            if (await setPersonData(
              Person(
                firstName: firstNameTextController.text,
                lastName: lastNameTextController.text,
              ),
            )) {
              //ref.read(gameDataNotifierProvider.notifier).resetGame();
              if (context.mounted) {
                Navigator.of(context).pop();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const HowToPlayDialog();
                  },
                );
              }
            }
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
