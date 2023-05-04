import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/concepts/person.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../domain/utils/utils.dart';
import '../widgets/asset_content.dart';
import '../widgets/game_app_bar.dart';
import '../widgets/how_to_play_dialog.dart';
import '../widgets/level_info_card.dart';
import '../widgets/loan_content.dart';
import '../widgets/menu_dialog.dart';
import '../widgets/overview_content.dart';
import '../widgets/personal_content.dart';
import '../widgets/section_card.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  late TextEditingController firstNameTextController;
  late TextEditingController lastNameTextController;

  bool setPersonData(Person enteredPerson) {
    if (enteredPerson.firstName == '' || enteredPerson.lastName == '') {
      showErrorSnackBar(
        context: context,
        errorMessage: 'Please enter first and last name.',
      );
      return false;
    }

    savePerson(enteredPerson);
    ref.read(gameDataNotifierProvider.notifier).setPerson(enteredPerson);
    return true;
  }

  @override
  void initState() {
    firstNameTextController = TextEditingController();
    lastNameTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDeviceInfo();
      loadPerson(ref: ref).then((personLoaded) {
        if (!personLoaded) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return MenuDialog(
                  showCloseButton: false,
                  title: 'Welcome to the FinSim Game',
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Dear participants, thank you for "
                          "participating. This game is meant to "
                          "mimic financial investment decisions and to teach "
                          "financial skills. It will only be used for this "
                          "purpose. We emphasize that no part of this game "
                          "exercise affects the relationship with your bank.\n\n"
                          "Please enter your contact info below:"),
                      TextField(
                        controller: firstNameTextController,
                        decoration:
                            const InputDecoration(hintText: "First name"),
                      ),
                      TextField(
                        controller: lastNameTextController,
                        decoration:
                            const InputDecoration(hintText: "Last name"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor: ColorPalette().buttonBackground,
                        foregroundColor: ColorPalette().lightText,
                      ),
                      onPressed: () {
                        if (setPersonData(
                          Person(
                            firstName: firstNameTextController.text,
                            lastName: lastNameTextController.text,
                          ),
                        )) Navigator.of(context).pop();
                      },
                      child: const Text('Start game'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor: ColorPalette().buttonBackground,
                        foregroundColor: ColorPalette().lightText,
                      ),
                      onPressed: () {
                        if (setPersonData(
                          Person(
                            firstName: firstNameTextController.text,
                            lastName: lastNameTextController.text,
                          ),
                        )) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const HowToPlayDialog();
                            },
                          );
                        }
                      },
                      child: const Text('How to play'),
                    ),
                  ],
                );
              });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameTextController.dispose();
    lastNameTextController.dispose();
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
                          const SectionCard(
                              title: 'PERSONAL', content: PersonalContent()),
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
            confettiController:
                ref.read(gameDataNotifierProvider).confettiController,
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
