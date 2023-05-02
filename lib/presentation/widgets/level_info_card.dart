import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    NumberFormat currencyFormat = ref.watch(gameDataNotifierProvider).currencyFormat;
    return Stack(
      children: [
        SectionCard(
          title:
              '${AppLocalizations.of(context)!.level.toUpperCase()} ${levelId + 1} / ${levels.length}',
          content: Column(
            children: [
              Text(
                '${AppLocalizations.of(context)!.levelGoal}: '
                '${currencyFormat.format(nextLevelCash)}',
                style: TextStyle(
                  fontSize: 17.0,
                  color: ColorPalette().darkText,
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
          child: NextPeriodButton(),
        ),
      ],
    );
  }
}
