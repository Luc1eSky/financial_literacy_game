import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/game_data_notifier.dart';
import 'how_to_play_dialog.dart';
import 'menu_dialog.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuDialog(
      title: AppLocalizations.of(context)!.settings,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) {
                  return const HowToPlayDialog();
                },
              );
            },
            child: Text(AppLocalizations.of(context)!.howToPlay),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.clearCache),
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: ColorPalette().buttonBackground,
              foregroundColor: ColorPalette().lightText,
            ),
            onPressed: () {
              ref.read(gameDataNotifierProvider.notifier).moveToNextLevel();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.nextLevel),
          ),

          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     elevation: 5.0,
          //     backgroundColor: ColorPalette().buttonBackground,
          //     foregroundColor: ColorPalette().lightText,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         return const LanguageSelectionDialog();
          //       },
          //     );
          //   },
          //   child: const Text('Languages'),
          // ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     elevation: 5.0,
          //     backgroundColor: ColorPalette().buttonBackground,
          //     foregroundColor: ColorPalette().lightText,
          //   ),
          //   onPressed: () {},
          //   child: const Text('Restart Game'),
          // ),
        ],
      ),
    );
  }
}
