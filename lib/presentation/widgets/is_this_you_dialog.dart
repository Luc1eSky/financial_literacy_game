import 'package:financial_literacy_game/presentation/widgets/sign_in_dialog_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/person.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/database.dart';
import '../../domain/utils/device_and_personal_data.dart';
import 'how_to_play_dialog.dart';
import 'menu_dialog.dart';

class IsThisYouDialog extends ConsumerStatefulWidget {
  final Person person;
  const IsThisYouDialog({required this.person, Key? key}) : super(key: key);

  @override
  ConsumerState<IsThisYouDialog> createState() => _IsThisYouDialogState();
}

class _IsThisYouDialogState extends ConsumerState<IsThisYouDialog> {
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MenuDialog(
          showCloseButton: false,
          title: "Is this you?", // TODO: BETTER TITLE
          content: Text("Are you ${widget.person.firstName} ${widget.person.lastName} ?"),
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
              child: const Text("No"),
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

                      ref.read(gameDataNotifierProvider.notifier).setPerson(widget.person);
                      savePersonLocally(widget.person);
                      await saveUserInFirestore(widget.person);
                      ref.read(gameDataNotifierProvider.notifier).resetGame();

                      setState(() {
                        isProcessing = false;
                      });
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
                    },
              child: const Text("Yes"),
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
