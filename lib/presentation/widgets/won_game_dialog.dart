import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game_data_notifier.dart';

class WonGameDialog extends StatelessWidget {
  final WidgetRef ref;
  const WonGameDialog({
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
          'Congratulations you finished the game successfully!',
          style: TextStyle(
            fontSize: 20,
            height: 2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
            color: ColorPalette().gameWinText, // font color
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameDataNotifierProvider.notifier).resetGame();
            Navigator.pop(context);
          },
          child: const Text('RESTART'),
        ),
      ],
    );
  }
}
