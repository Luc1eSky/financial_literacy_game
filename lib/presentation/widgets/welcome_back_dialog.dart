import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:financial_literacy_game/presentation/widgets/sign_in_dialog_with_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/utils/database.dart';
import 'menu_dialog.dart';

class WelcomeBackDialog extends ConsumerStatefulWidget {
  const WelcomeBackDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<WelcomeBackDialog> createState() => _WelcomeBackDialogState();
}

class _WelcomeBackDialogState extends ConsumerState<WelcomeBackDialog> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    // get current person from game data
    Person person = ref.read(gameDataNotifierProvider).person;
    return Stack(
      children: [
        MenuDialog(
          showCloseButton: false,
          // welcomes back user with first and last name
          title: AppLocalizations.of(context)!.welcomeBack(
              person.firstName!.capitalize(), person.lastName!.capitalize()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .sameUser(person.firstName!.capitalize()),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ref.read(gameDataNotifierProvider).levelId != 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor: ColorPalette().buttonBackground,
                        foregroundColor: ColorPalette().lightText,
                      ),
                      onPressed: isClicked
                          ? null
                          : () async {
                              setState(() {
                                isClicked = true;
                              });
                              bool couldReconnect =
                                  await reconnectToGameSession(person: person);
                              if (!couldReconnect) {
                                ref
                                    .read(gameDataNotifierProvider.notifier)
                                    .resetGame();
                              }
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                      child: Text(AppLocalizations.of(context)!
                          .startAtLevel(
                              (ref.read(gameDataNotifierProvider).levelId + 1)
                                  .toStringAsFixed(0))
                          .capitalize()),
                    ),
                  if (ref.read(gameDataNotifierProvider).levelId != 0)
                    const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: ColorPalette().buttonBackground,
                      foregroundColor: ColorPalette().lightText,
                    ),
                    onPressed: isClicked
                        ? null
                        : () async {
                            setState(() {
                              isClicked = true;
                            });
                            await endCurrentGameSession(
                                status: Status.abandoned, person: person);
                            ref
                                .read(gameDataNotifierProvider.notifier)
                                .resetGame();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                    child: Text(
                        AppLocalizations.of(context)!.restartGame.capitalize()),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Text(
                AppLocalizations.of(context)!
                    .signInDifferentPerson
                    .capitalize(),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  backgroundColor: ColorPalette().buttonBackground,
                  foregroundColor: ColorPalette().lightText,
                ),
                onPressed: isClicked
                    ? null
                    : () {
                        setState(() {
                          isClicked = true;
                        });
                        Navigator.of(context).pop();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const SignInDialogNew();
                          },
                        );
                      },
                child: Text(AppLocalizations.of(context)!.notMe.capitalize()),
              ),
            ],
          ),
        ),
        if (isClicked) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

//
// class WelcomeBackDialog extends ConsumerWidget {
//   const WelcomeBackDialog({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Person person = ref.read(gameDataNotifierProvider).person;
//     return MenuDialog(
//       showCloseButton: false,
//       title: 'Welcome back, ${person.firstName} ${person.lastName}!',
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "If you are ${person.firstName}, simply start the game.",
//           ),
//           const SizedBox(height: 10.0),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (ref.read(gameDataNotifierProvider).levelId != 0)
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     elevation: 5.0,
//                     backgroundColor: ColorPalette().buttonBackground,
//                     foregroundColor: ColorPalette().lightText,
//                   ),
//                   onPressed: () async {
//                     bool couldReconnect =
//                         await reconnectToGameSession(person: person);
//                     if (!couldReconnect) {
//                       ref.read(gameDataNotifierProvider.notifier).resetGame();
//                     }
//                     if (context.mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text(
//                       'Start at level ${ref.read(gameDataNotifierProvider).levelId + 1}'),
//                 ),
//               if (ref.read(gameDataNotifierProvider).levelId != 0)
//                 const SizedBox(width: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 5.0,
//                   backgroundColor: ColorPalette().buttonBackground,
//                   foregroundColor: ColorPalette().lightText,
//                 ),
//                 onPressed: () async {
//                   await endCurrentGameSession(
//                       status: Status.abandoned, person: person);
//                   ref.read(gameDataNotifierProvider.notifier).resetGame();
//                   if (context.mounted) {
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: Text(AppLocalizations.of(context)!.restartGame),
//               ),
//             ],
//           ),
//           const SizedBox(height: 25.0),
//           Text(
//             AppLocalizations.of(context)!.signInDifferentPerson,
//           ),
//           const SizedBox(height: 10.0),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 5.0,
//               backgroundColor: ColorPalette().buttonBackground,
//               foregroundColor: ColorPalette().lightText,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//               showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (context) {
//                   return const SignInDialog();
//                 },
//               );
//             },
//             child: Text(AppLocalizations.of(context)!.notMe),
//           ),
//         ],
//       ),
//     );
//   }
// }
