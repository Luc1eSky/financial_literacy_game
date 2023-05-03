import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/game_data_notifier.dart';
import 'content_card.dart';

class OverviewContent extends ConsumerWidget {
  const OverviewContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoSizeGroup valueSizeGroup = AutoSizeGroup();

    double cash = ref.watch(gameDataNotifierProvider).cash;
    double income = ref.watch(gameDataNotifierProvider.notifier).calculateTotalIncome();
    double expenses = ref.watch(gameDataNotifierProvider.notifier).calculateTotalExpenses();

    return Row(
      children: [
        Expanded(
          child: ContentCard(
            aspectRatio: overviewAspectRatio,
            content: OverviewTileContent(
              title: 'Cash',
              value: cash,
              group: valueSizeGroup,
            ),
          ),
        ),
        const SizedBox(width: 7.0),
        Expanded(
          child: ContentCard(
            aspectRatio: overviewAspectRatio,
            content: OverviewTileContent(
              title: 'Income',
              value: income,
              group: valueSizeGroup,
            ),
          ),
        ),
        const SizedBox(width: 7.0),
        Expanded(
          child: ContentCard(
            aspectRatio: overviewAspectRatio,
            content: OverviewTileContent(
              title: 'Expenses',
              value: -expenses,
              group: valueSizeGroup,
            ),
          ),
        ),
      ],
    );
  }
}

class OverviewTileContent extends ConsumerWidget {
  const OverviewTileContent({
    super.key,
    required this.title,
    required this.value,
    required this.group,
  });

  final String title;
  final double value;
  final AutoSizeGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            color: ColorPalette().lightText,
          ),
        ),
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.bottomRight,
            child: AutoSizeText(
              value.toStringAsFixed(2),
              maxLines: 1,
              group: group,
              style: TextStyle(
                fontSize: 100.0,
                color: ColorPalette().lightText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
