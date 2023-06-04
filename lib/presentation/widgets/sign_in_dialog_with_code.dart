import 'package:financial_literacy_game/presentation/widgets/sign_in_with_name_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/utils/database.dart';
import '../../domain/utils/utils.dart';
import 'is_this_you_dialog.dart';
import 'menu_dialog.dart';

class SignInDialogNew extends ConsumerStatefulWidget {
  const SignInDialogNew({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInDialogNew> createState() => _SignInDialogNewState();
}

class _SignInDialogNewState extends ConsumerState<SignInDialogNew> {
  late TextEditingController uidTextController;
  bool isProcessing = false;

  Future<Person?> findPersonByUID({required String uid}) async {
    // Exit if code has wrong length and show warning
    if (uid.length != 7) {
      showErrorSnackBar(
        context: context,
        errorMessage: AppLocalizations.of(context)!.enterUID.capitalize(),
      );
      return null;
    }

    // CHECK IF USER WITH UID ALREADY EXISTS (ANYWHERE)
    Person? user = await searchUserbyUIDInFirestore(uid);
    if (user != null) {
      //print('${user.firstName} ${user.lastName}');
      //ref.read(gameDataNotifierProvider.notifier).setPerson(user);
      //savePersonLocally(user);
      //await saveUserInFirestore(user);
      //ref.read(gameDataNotifierProvider.notifier).resetGame();
      return user;
    } else {
      if (context.mounted) {
        showErrorSnackBar(
          context: context,
          errorMessage: AppLocalizations.of(context)!.codeNotFound,
        );
      }
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    uidTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    uidTextController.dispose();
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
                  child: Text(AppLocalizations.of(context)!.welcomeText),
                ),
              ),
              TextField(
                enabled: !isProcessing,
                controller: uidTextController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.hintUID),
                // Length of code is 7 characters
                maxLength: 7,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]'))
                ],
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: ColorPalette().buttonBackgroundSpecial,
                foregroundColor: ColorPalette().lightText,
              ),
              // button when no code available
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const SignInWithNameDialog();
                  },
                );
              },
              child: Text(AppLocalizations.of(context)!.noCodeButton),
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

                      Person? foundPerson =
                          await findPersonByUID(uid: uidTextController.text);

                      if (foundPerson != null) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return IsThisYouDialog(person: foundPerson);
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
