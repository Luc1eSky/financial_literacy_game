import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../widgets/asset_content.dart';
import '../widgets/game_app_bar.dart';
import '../widgets/level_info_card.dart';
import '../widgets/loan_content.dart';
import '../widgets/overview_content.dart';
import '../widgets/personal_content.dart';
import '../widgets/section_card.dart';
import '../widgets/sign_in_dialog.dart';
import '../widgets/welcome_back_dialog.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  ConsumerState<Homepage> createState() => _Homepage1State();
}

class _Homepage1State extends ConsumerState<Homepage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDeviceInfo();
      bool personLoaded = await loadPerson(ref: ref);
      if (personLoaded) {
        bool levelLoaded = await loadLevelIDFromLocal(ref: ref);
        if (levelLoaded) {
          if (context.mounted) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const WelcomeBackDialog();
              },
            );
          }
        }
      } else {
        if (context.mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const SignInDialog();
            },
          );
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int levelId = ref.watch(gameDataNotifierProvider).levelId;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorPalette().background,
          resizeToAvoidBottomInset: false,
          appBar: const GameAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: playAreaMaxWidth),
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
                        const SectionCard(
                          title: 'OVERVIEW',
                          content: OverviewContent(),
                        ),
                        const SizedBox(height: 10),
                        if (levels[ref.read(gameDataNotifierProvider).levelId]
                            .includePersonalIncome)
                          const SectionCard(title: 'PERSONAL', content: PersonalContent()),
                        if (levels[ref.read(gameDataNotifierProvider).levelId]
                            .includePersonalIncome)
                          const SizedBox(height: 10),
                        const SectionCard(
                          title: 'ASSETS',
                          content: AssetContent(),
                        ),
                        const SizedBox(height: 10),
                        const SectionCard(
                          title: 'LOANS',
                          content: LoanContent(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: ref.watch(gameDataNotifierProvider).confettiController,
            shouldLoop: true,
            emissionFrequency: 0.03,
            numberOfParticles: 20,
            maxBlastForce: 25,
            minBlastForce: 7,
            // colors: [
            //   ColorPalette().lightText,
            //   ColorPalette().cashIndicator,
            //   ColorPalette().backgroundContentCard,
            // ],
            gravity: 0.2,
            particleDrag: 0.05,
            blastDirection: pi,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ),
      ],
    );
  }
}
