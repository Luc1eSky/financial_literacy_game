import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_literacy_game/presentation/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameAppBar({
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorPalette().appBarBackground,
      title: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: AutoSizeText(
          '$appTitle - ${AppLocalizations.of(context)!.country}',
          style: const TextStyle(fontSize: 100, color: Colors.black87),
          maxFontSize: 22,
          maxLines: 1,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              //barrierDismissible: true,
              context: context,
              builder: (context) {
                return const SettingsDialog();
              },
            );
          },
          icon: const Icon(
            Icons.settings,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 5.0),
      ],
    );
  }
}
