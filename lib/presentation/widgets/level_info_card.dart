import 'package:flutter/material.dart';

import '../../domain/entities/levels.dart';
import '../screens/home_page.dart';
import '../widgets/section_card.dart';
import 'next_period_button.dart';

class LevelInfoCard extends StatelessWidget {
  const LevelInfoCard({
    super.key,
    required this.levelId,
    required this.currentCash,
    required this.nextLevelCash,
  });

  final int levelId;
  final double currentCash;
  final double nextLevelCash;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SectionCard(
          title: 'LEVEL ${levelId + 1} / ${levels.length}',
          content: Column(
            children: [
              Text(
                'Cash goal: \$${nextLevelCash.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 7.5),
              CashIndicator(
                currentCash: currentCash,
                cashGoal: levels[levelId].cashGoal,
              ),
            ],
          ),
        ),
        const Positioned(
          top: 15.0,
          right: 15.0,
          child: SizedBox(
            width: 120,
            height: 30,
            child: NextPeriodButton(),
          ),
        ),
      ],
    );
  }
}
