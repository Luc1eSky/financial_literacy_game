import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/game_data_notifier.dart';

class LostGameDialog extends StatelessWidget {
  final WidgetRef ref;
  const LostGameDialog({
    required this.ref,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 100,
        width: 100,
        child: AutoSizeText(
          'Unfortunately you ran out of cash. You can either restart '
          'this level or start a new game.',
          style: TextStyle(
            fontSize: 20,
            height: 2, // line height 200%, 1= 100%, were 0.9 = 90% of actual line height
            color: ColorPalette().gameLostText, // font color
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameDataNotifierProvider.notifier).restartLevel();
            Navigator.pop(context);
          },
          child: const Text('RESTART LEVEL'),
        ),
        TextButton(
          onPressed: () {
            ref.read(gameDataNotifierProvider.notifier).resetGame();
            Navigator.pop(context);
          },
          child: const Text('RESTART GAME'),
        ),
      ],
    );
  }
}
