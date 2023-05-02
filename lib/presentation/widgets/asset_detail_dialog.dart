import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../config/color_palette.dart';
import '../../domain/game_data_notifier.dart';

class AssetDetailDialog extends ConsumerWidget {
  const AssetDetailDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NumberFormat currencyFormat = ref.watch(gameDataNotifierProvider).currencyFormat;
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.assets.toUpperCase()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 9.0,
            child: Container(
              color: Colors.lightBlue,
              child: Row(
                children: [],
              ),
            ),
          ),
          ...ref
              .watch(gameDataNotifierProvider)
              .assets
              .map(
                (asset) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: AspectRatio(
                    aspectRatio: 9.0,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${asset.numberOfAnimals.toString()} x',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: ColorPalette().darkText,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Image.asset(asset.imagePath),
                          ],
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 10.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: ColorPalette().lifeBarBackground,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: asset.age / asset.lifeExpectancy,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: ColorPalette().lifeBarForeground,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          currencyFormat.format(asset.income),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: ColorPalette().darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          AspectRatio(
            aspectRatio: 9.0,
            child: Container(
              //color: Colors.green,
              child: Text(
                currencyFormat
                    .format(ref.watch(gameDataNotifierProvider.notifier).calculateTotalIncome()),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16.0,
                  color: ColorPalette().darkText,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
