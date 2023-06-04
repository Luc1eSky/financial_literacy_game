import 'package:financial_literacy_game/presentation/widgets/sign_in_dialog_with_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/database.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../domain/utils/utils.dart';
import 'how_to_play_dialog.dart';
import 'menu_dialog.dart';

class SignInWithNameDialog extends ConsumerStatefulWidget {
  const SignInWithNameDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInWithNameDialog> createState() =>
      _SignInWithNameDialogState();
}

class _SignInWithNameDialogState extends ConsumerState<SignInWithNameDialog> {
  late TextEditingController firstNameTextController;
  late TextEditingController lastNameTextController;
  bool isProcessing = false;

  Future<bool> setPersonData(Person enteredPerson) async {
    // show error message when text field left blank
    if (enteredPerson.firstName == '' || enteredPerson.lastName == '') {
      showErrorSnackBar(
        context: context,
        errorMessage: AppLocalizations.of(context)!.enterName.capitalize(),
      );
      return false;
    }

    // remove whitespaces from text fields
    String trimmedFirstName = enteredPerson.firstName!.trim();
    String trimmedLastName = enteredPerson.lastName!.trim();

    // remove leading or trailing dashes ("-")
    String cleanedFirstName = removeTrailing("-", trimmedFirstName);
    cleanedFirstName = removeLeading("-", cleanedFirstName);
    String cleanedLastName = removeTrailing("-", trimmedLastName);
    cleanedLastName = removeLeading("-", cleanedLastName);

    // Capitalize first letter and lower case all other letters
    cleanedFirstName =
        "${cleanedFirstName[0].toUpperCase()}${cleanedFirstName.substring(1).toLowerCase()}";
    cleanedLastName =
        "${cleanedLastName[0].toUpperCase()}${cleanedLastName.substring(1).toLowerCase()}";

    // create cleaned person
    Person cleanedPerson = Person(
      firstName: cleanedFirstName,
      lastName: cleanedLastName,
      uid: enteredPerson.uid,
    );

    // set the new person in the game data as current player
    ref.read(gameDataNotifierProvider.notifier).setPerson(cleanedPerson);
    savePersonLocally(cleanedPerson);
    await saveUserInFirestore(cleanedPerson);
    // reset game when new user starts playing
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
    return Stack(
      children: [
        MenuDialog(
          showCloseButton: false,
          title: AppLocalizations.of(context)!.titleSignIn.capitalize(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.signInName),
              TextField(
                enabled: !isProcessing,
                controller: firstNameTextController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .hintFirstName
                        .capitalize()),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[^0-9]'))
                ],
              ),
              TextField(
                enabled: !isProcessing,
                controller: lastNameTextController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .hintLastName
                        .capitalize()),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[^0-9]'))
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: ColorPalette().buttonBackground,
                foregroundColor: ColorPalette().lightText,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const SignInDialogNew();
                  },
                );
              },
              child: Text(AppLocalizations.of(context)!.backButton),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: ColorPalette().buttonBackground,
                foregroundColor: ColorPalette().lightText,
              ),
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() {
                        isProcessing = true;
                      });

                      bool personWasCreated = await setPersonData(
                        Person(
                          firstName: firstNameTextController.text,
                          lastName: lastNameTextController.text,
                          uid: 'test',
                        ),
                      );

                      //await Future.delayed(const Duration(seconds: 2));

                      if (personWasCreated) {
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
                      } else {
                        setState(() {
                          isProcessing = false;
                        });
                      }
                    },
              child: Text(
                  AppLocalizations.of(context)!.continueButton.capitalize()),
            ),
          ],
        ),
        if (isProcessing)
          const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
