import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../l10n/l10n.dart';
import '../widgets/asset_content.dart';
import '../widgets/game_app_bar.dart';
import '../widgets/language_selection_dialog.dart';
import '../widgets/level_info_card.dart';
import '../widgets/loan_content.dart';
import '../widgets/overview_content.dart';
import '../widgets/section_card.dart';
import '../widgets/sign_in_dialog_with_code.dart';
import '../widgets/welcome_back_dialog.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // get info from device that has been stored previously
      await getDeviceInfo();
      bool personLoaded = await loadPerson(ref: ref);
      // get locale from system settings
      Locale locale = await L10n.getSystemLocale();
      ref.read(gameDataNotifierProvider.notifier).setLocale(locale);
      // if the person has been stored from previous game sessions
      if (personLoaded) {
        // loading last level the user played
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
        // if there is no user stored on device
        if (context.mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              // show language options available
              return LanguageSelectionDialog(
                title: AppLocalizations.of(context)!.selectLanguage,
                showDialogWidgetAfterPop: const SignInDialogNew(),
              );
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
            // homepage scrollable when screen to small
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
                        SectionCard(
                          title: AppLocalizations.of(context)!.overview.toUpperCase(),
                          content: const OverviewContent(),
                        ),
                        const SizedBox(height: 10),
                        // if (levels[ref.read(gameDataNotifierProvider).levelId]
                        //     .includePersonalIncome)
                        //   SectionCard(
                        //       title: AppLocalizations.of(context)!
                        //           .personal
                        //           .toUpperCase(),
                        //       content: const PersonalContent()),
                        // if (levels[ref.read(gameDataNotifierProvider).levelId]
                        //     .includePersonalIncome)
                        //   const SizedBox(height: 10),
                        SectionCard(
                          title: AppLocalizations.of(context)!.assets.toUpperCase(),
                          content: const AssetContent(),
                        ),
                        const SizedBox(height: 10),
                        levelId != 0 && levelId != 1 ? SectionCard(
                          title: AppLocalizations.of(context)!.loan(2).toUpperCase(),
                          content: const LoanContent(),
                        ) : Container(),
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
