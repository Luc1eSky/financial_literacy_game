import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game_data_notifier.dart';
import 'content_card.dart';

class PersonalContent extends ConsumerWidget {
  const PersonalContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ContentCard(
            aspectRatio: 5.0,
            content: PersonalTileContent(
              income: ref.watch(gameDataNotifierProvider).personalIncome,
              expenses: ref.watch(gameDataNotifierProvider).personalExpenses,
            ),
          ),
        ),
        const SizedBox(width: 7.0),
      ],
    );
  }
}

class PersonalTileContent extends StatelessWidget {
  const PersonalTileContent({
    super.key,
    required this.income,
    required this.expenses,
  });

  final double income;
  final double expenses;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    '\$$income',
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 50.0,
                    ),
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    'income',
                    maxLines: 1,
                    minFontSize: 2,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 50.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    '-\$$expenses',
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 50.0,
                    ),
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    'expenses',
                    maxLines: 1,
                    minFontSize: 2,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 50.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: AutoSizeText(
              '\$${income - expenses}',
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 50.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
