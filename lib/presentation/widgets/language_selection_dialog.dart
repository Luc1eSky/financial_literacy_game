import 'package:defer_pointer/defer_pointer.dart';
import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/game_data_notifier.dart';
import '../../domain/utils/device_and_personal_data.dart';
import '../../l10n/l10n.dart';

class LanguageSelectionDialog extends ConsumerWidget {
  const LanguageSelectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeferredPointerHandler(
      child: AlertDialog(
        backgroundColor: ColorPalette().background,
        title: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              AppLocalizations.of(context)!.languagesTitle.capitalize(),
              //AppLocalizations.of(context)!.localeSelectionTitle,
              style: const TextStyle(fontSize: 23.0),
            ),
            Positioned(
              top: -30.0,
              right: -30.0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPalette().buttonBackground,
                ),
                child: DeferPointer(
                  child: IconButton(
                    iconSize: 100,
                    padding: const EdgeInsets.all(5.0),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Center(
                      child: FittedBox(
                        child: Icon(
                          Icons.close,
                          color: ColorPalette().lightText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                      backgroundColor:

                          //AppLocalizations.of(context)!.
                          ColorPalette().buttonBackground,
                      foregroundColor: ColorPalette().lightText,
                    ),
                    onPressed: () {
                      ref
                          .read(gameDataNotifierProvider.notifier)
                          .setLocale(locale);
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
      ),
    );
  }
}
