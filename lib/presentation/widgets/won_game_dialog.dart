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
      content: Container(
        height: 100,
        width: 100,
        color: Colors.green,
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
