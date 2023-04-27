import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../screens/home_page.dart';

class NextPeriodButton extends ConsumerWidget {
  const NextPeriodButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 8.0,
        foregroundColor: ColorPalette().buttonForeground,
        backgroundColor: ColorPalette().buttonBackground,
        textStyle: const TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return InvestmentDialog(ref: ref);
            });
      },
      child: const Text('NEXT'),
    );
  }
}
