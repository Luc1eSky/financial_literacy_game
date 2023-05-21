import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/game_data_notifier.dart';
import 'menu_dialog.dart';

class NextLevelDialog extends StatelessWidget {
  final WidgetRef ref;
  const NextLevelDialog({
    required this.ref,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuDialog(
      showCloseButton: false,
      title: 'Congratulations',
      content: Text(
        'You have reached the next level!',
        style: TextStyle(
          fontSize: 20,
          color: ColorPalette().darkText,
          fontStyle: FontStyle.normal,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(gameDataNotifierProvider.notifier).moveToNextLevel();
          },
          child: const Text('NEXT'),
        ),
      ],
    );
  }
}
