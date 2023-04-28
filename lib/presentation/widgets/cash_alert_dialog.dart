import 'package:flutter/material.dart';

class CashAlertDialog extends StatelessWidget {
  const CashAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: const Text('Not enough cash!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('okay'),
        )
      ],
    );
  }
}
