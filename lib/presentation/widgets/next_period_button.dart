import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import 'investment_dialog.dart';

class NextPeriodButton extends ConsumerWidget {
  const NextPeriodButton({
    this.isDemonstrationMode = false,
    super.key,
  });
  final bool isDemonstrationMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 120,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          foregroundColor: ColorPalette().darkText,
          backgroundColor: ColorPalette().cashIndicator,
          textStyle: const TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (!isDemonstrationMode) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return InvestmentDialog(ref: ref);
                });
          }
        },
        child: const Text('NEXT'),
      ),
    );
  }
}
