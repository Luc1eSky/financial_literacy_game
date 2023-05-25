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

class SignInDialog extends ConsumerStatefulWidget {
  const SignInDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends ConsumerState<SignInDialog> {
  late TextEditingController firstNameTextController;
  late TextEditingController lastNameTextController;
  bool isProcessing = false;

  Future<bool> setPersonData(Person enteredPerson) async {
    if (enteredPerson.firstName == '' || enteredPerson.lastName == '') {
      showErrorSnackBar(
        context: context,
        errorMessage: AppLocalizations.of(context)!.enterName.capitalize(),
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

    // Capitalize first letter and lower case all other letters
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
    return Stack(
      children: [
        MenuDialog(
          showCloseButton: false,
          title: AppLocalizations.of(context)!.titleSignIn.capitalize(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).viewInsets.bottom == 0 ? 150 : 100,
                child: SingleChildScrollView(
                  child: Text(
                      AppLocalizations.of(context)!.welcomeText.capitalize()),
                ),
              ),
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
