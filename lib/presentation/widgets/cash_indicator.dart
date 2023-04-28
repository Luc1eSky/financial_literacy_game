import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/color_palette.dart';

class CashIndicator extends StatelessWidget {
  final double currentCash;
  final double cashGoal;

  const CashIndicator({
    super.key,
    required this.currentCash,
    required this.cashGoal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Positioned(
            top: -1.0,
            child: Container(
              height: 12,
              width:
                  max(0, min(constraints.maxWidth, constraints.maxWidth * currentCash / cashGoal)),
              decoration: BoxDecoration(
                color: ColorPalette().cashIndicator,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      );
    });
  }
}
