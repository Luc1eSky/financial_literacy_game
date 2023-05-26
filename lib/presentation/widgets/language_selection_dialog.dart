import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:financial_literacy_game/presentation/widgets/menu_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../l10n/l10n.dart';

class LanguageSelectionDialog extends ConsumerWidget {
  final String title;
  final Widget? showDialogWidgetAfterPop;
  const LanguageSelectionDialog({required this.title, this.showDialogWidgetAfterPop, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale selectedLocale = ref.watch(gameDataNotifierProvider).locale;
    return MenuDialog(
      showCloseButton: false,
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: L10n.all
            .map(
              (locale) => Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: locale == selectedLocale
                        ? ColorPalette().selectedButtonBackground
                        : ColorPalette().buttonBackground,
                    foregroundColor: ColorPalette().lightText,
                  ),
                  onPressed: () {
                    ref.read(gameDataNotifierProvider.notifier).setLocale(locale);
                    saveLocalLocally(locale);
                    //Navigator.of(context).pop();
                  },
                  child: Localizations.override(
                    context: context,
                    locale: locale,
                    child: Builder(
                      builder: (context) {
                        return Text(
                          '${AppLocalizations.of(context)!.language} / '
                          //'${Localizations.localeOf(context).toString()}'
                          '${NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).currencyName}',
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            backgroundColor: ColorPalette().buttonBackground,
            foregroundColor: ColorPalette().lightText,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (showDialogWidgetAfterPop != null) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return showDialogWidgetAfterPop!;
                },
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    );
  }
}
