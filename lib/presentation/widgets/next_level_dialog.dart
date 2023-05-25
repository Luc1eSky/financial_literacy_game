import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/game_data_notifier.dart';
import 'menu_dialog.dart';

class NextLevelDialog extends StatelessWidget {
  final WidgetRef ref;
  const NextLevelDialog({
    required this.ref,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuDialog(
      showCloseButton: false,
      title: AppLocalizations.of(context)!.congratulations.capitalize(),
      content: Text(
        AppLocalizations.of(context)!.reachedNextLevel.capitalize(),
        style: TextStyle(
          fontSize: 20,
          color: ColorPalette().darkText,
          fontStyle: FontStyle.normal,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(gameDataNotifierProvider.notifier).moveToNextLevel();
          },
          child: Text(AppLocalizations.of(context)!.next.capitalize()),
        ),
      ],
    );
  }
}
