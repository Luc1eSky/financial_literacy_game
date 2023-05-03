import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/game_data_notifier.dart';
import '../../presentation/widgets/settings_dialog.dart';

class GameAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GameAppBar({
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: ColorPalette().appBarBackground,
      title: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: AutoSizeText(
          ref.watch(gameDataNotifierProvider).person.exists()
              ? '$appTitle - ${ref.watch(gameDataNotifierProvider).person.firstName} '
                  '${ref.watch(gameDataNotifierProvider).person.lastName}'
              : appTitle,
          style: TextStyle(
            fontSize: 100,
            color: ColorPalette().darkText,
          ),
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
          icon: Icon(
            Icons.settings,
            color: ColorPalette().darkText,
          ),
        ),
        const SizedBox(width: 5.0),
      ],
    );
  }
}
