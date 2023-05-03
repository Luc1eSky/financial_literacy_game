import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/concepts/person.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
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

// class HomePage extends ConsumerWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     int levelId = ref.watch(gameDataNotifierProvider).levelId;
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: ColorPalette().background,
//           appBar: const GameAppBar(),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: playAreaMaxWidth),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       children: [
//                         LevelInfoCard(
//                           currentCash: ref.watch(gameDataNotifierProvider).cash,
//                           levelId: levelId,
//                           nextLevelCash: levels[levelId].cashGoal,
//                         ),
//                         const SizedBox(height: 10),
//                         SectionCard(
//                           title: AppLocalizations.of(context)!.overview.toUpperCase(),
//                           content: const OverviewContent(),
//                         ),
//                         const SizedBox(height: 10),
//                         if (levels[ref.read(gameDataNotifierProvider).levelId]
//                             .includePersonalIncome)
//                           const SectionCard(title: 'PERSONAL', content: PersonalContent()),
//                         if (levels[ref.read(gameDataNotifierProvider).levelId]
//                             .includePersonalIncome)
//                           const SizedBox(height: 10),
//                         SectionCard(
//                           title: AppLocalizations.of(context)!.assets.toUpperCase(),
//                           content: const AssetContent(),
//                         ),
//                         const SizedBox(height: 10),
//                         SectionCard(
//                           title: AppLocalizations.of(context)!.loans.toUpperCase(),
//                           content: const LoanContent(),
//                         ),
//                         Container(
//                           height: 100,
//                           color: Colors.red,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.topCenter,
//           child: ConfettiWidget(
//             confettiController: ref.read(gameDataNotifierProvider).confettiController,
//             shouldLoop: true,
//             emissionFrequency: 0.03,
//             numberOfParticles: 25,
//             maxBlastForce: 25,
//             minBlastForce: 7,
//             // colors: [
//             //   ColorPalette().lightText,
//             //   ColorPalette().cashIndicator,
//             //   ColorPalette().backgroundContentCard,
//             // ],
//             gravity: 0.2,
//             particleDrag: 0.05,
//             blastDirection: pi,
//             blastDirectionality: BlastDirectionality.explosive,
//           ),
//         ),
//       ],
//     );
//   }
// }

class HomepageNew extends ConsumerStatefulWidget {
  const HomepageNew({Key? key}) : super(key: key);

  @override
  ConsumerState<HomepageNew> createState() => _HomepageNewState();
}

class _HomepageNewState extends ConsumerState<HomepageNew> {
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

    _savePerson(enteredPerson);
    ref.read(gameDataNotifierProvider.notifier).setPerson(enteredPerson);
    return true;
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      debugPrint('Running on ${webBrowserInfo.userAgent}');
    }
  }

  Future<bool> _loadPerson() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedFirstName = prefs.getString('firstName');
    String? savedLastName = prefs.getString('lastName');

    if (savedFirstName == null || savedLastName == null) return false;

    Person loadedPerson = Person(firstName: savedFirstName, lastName: savedLastName);
    ref.read(gameDataNotifierProvider.notifier).setPerson(loadedPerson);
    return true;
  }

  void _savePerson(Person person) async {
    if (person.exists()) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('firstName', person.firstName!);
      prefs.setString('lastName', person.lastName!);
    }
  }

  @override
  void initState() {
    firstNameTextController = TextEditingController();
    lastNameTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDeviceInfo();
      _loadPerson().then((personLoaded) {
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
                        decoration: const InputDecoration(hintText: "First name"),
                      ),
                      TextField(
                        controller: lastNameTextController,
                        decoration: const InputDecoration(hintText: "Last name"),
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
                        SectionCard(
                          title: AppLocalizations.of(context)!.overview.toUpperCase(),
                          content: const OverviewContent(),
                        ),
                        const SizedBox(height: 10),
                        if (levels[ref.read(gameDataNotifierProvider).levelId]
                            .includePersonalIncome)
                          const SectionCard(title: 'PERSONAL', content: PersonalContent()),
                        if (levels[ref.read(gameDataNotifierProvider).levelId]
                            .includePersonalIncome)
                          const SizedBox(height: 10),
                        SectionCard(
                          title: AppLocalizations.of(context)!.assets.toUpperCase(),
                          content: const AssetContent(),
                        ),
                        const SizedBox(height: 10),
                        SectionCard(
                          title: AppLocalizations.of(context)!.loans.toUpperCase(),
                          content: const LoanContent(),
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
            confettiController: ref.read(gameDataNotifierProvider).confettiController,
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
