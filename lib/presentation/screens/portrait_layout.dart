import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../widgets/level_info_card.dart';
import '../widgets/section_card.dart';
import 'home_page.dart';

class PortraitLayout extends ConsumerWidget {
  const PortraitLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int levelId = ref.watch(gameDataNotifierProvider).levelId;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              LevelInfoCard(
                currentCash: ref.watch(gameDataNotifierProvider).cash,
                levelId: levelId,
                nextLevelCash: levels[levelId].cashGoal,
              ),
              const SizedBox(height: 10),
              const SectionCard(title: 'OVERVIEW', content: OverviewContent()),
              const SizedBox(height: 10),
              if (levels[ref.read(gameDataNotifierProvider).levelId].includePersonalIncome)
                const SectionCard(title: 'PERSONAL', content: PersonalContent()),
              if (levels[ref.read(gameDataNotifierProvider).levelId].includePersonalIncome)
                const SizedBox(height: 10),
              const SectionCard(title: 'ASSETS', content: AssetContent()),
              const SizedBox(height: 10),
              const SectionCard(title: 'LOANS', content: LoanContent()),
            ],
          ),
        ),
      ),
    );
  }
}
