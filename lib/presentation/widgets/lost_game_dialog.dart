import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      content: Container(
        height: 100,
        width: 100,
        color: Colors.red,
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
