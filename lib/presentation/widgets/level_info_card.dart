import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/levels.dart';
import 'cash_indicator.dart';
import 'next_period_button.dart';
import 'section_card.dart';

class LevelInfoCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    double convertedCurrentCash =
        ref.read(gameDataNotifierProvider.notifier).convertAmount(currentCash);
    double convertedNextLevelCash =
        ref.read(gameDataNotifierProvider.notifier).convertAmount(nextLevelCash);

    return Stack(
      children: [
        SectionCard(
          title: AppLocalizations.of(context)!.level((levelId + 1), levels.length).capitalize(),
          content: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.cashGoalReach(convertedNextLevelCash).capitalize(),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette().darkText,
                ),
              ),
              const SizedBox(height: 7.5),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.cashValue(0.00),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CashIndicator(
                      currentCash: convertedCurrentCash,
                      cashGoal: convertedNextLevelCash,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.cashValue(convertedNextLevelCash),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          top: 15.0,
          right: 15.0,
          child: NextPeriodButton(),
        ),
      ],
    );
  }
}
