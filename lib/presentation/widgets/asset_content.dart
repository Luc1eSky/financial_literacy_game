import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/concepts/asset.dart';
import '../../domain/game_data_notifier.dart';

class AssetContent extends ConsumerWidget {
  const AssetContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoSizeGroup valueSizeGroup = AutoSizeGroup();

    int cows = ref.watch(gameDataNotifierProvider).cows;
    int chickens = ref.watch(gameDataNotifierProvider).chickens;
    int goats = ref.watch(gameDataNotifierProvider).goats;

    double cowIncome = ref.watch(gameDataNotifierProvider.notifier).calculateIncome(AssetType.cow);
    double chickenIncome =
        ref.watch(gameDataNotifierProvider.notifier).calculateIncome(AssetType.chicken);
    double goatIncome =
        ref.watch(gameDataNotifierProvider.notifier).calculateIncome(AssetType.goat);
    return GestureDetector(
      onTap: () {
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return const AssetDetailDialog();
        //   },
        // );
      },
      child: Row(
        children: [
          Expanded(
              child: SmallAssetCard(
            title: 'cow',
            count: cows,
            income: cowIncome,
            group: valueSizeGroup,
            imagePath: 'assets/images/cow.png',
          )),
          const SizedBox(width: 7.0),
          Expanded(
              child: SmallAssetCard(
            title: 'chicken',
            count: chickens,
            income: chickenIncome,
            group: valueSizeGroup,
            imagePath: 'assets/images/chicken.png',
          )),
          const SizedBox(width: 7.0),
          Expanded(
              child: SmallAssetCard(
            title: 'goat',
            count: goats,
            income: goatIncome,
            group: valueSizeGroup,
            imagePath: 'assets/images/goat.png',
          )),
        ],
      ),
    );
  }
}

class SmallAssetCard extends ConsumerWidget {
  const SmallAssetCard({
    super.key,
    required this.title,
    required this.count,
    required this.income,
    required this.group,
    required this.imagePath,
  });
  final String title;
  final int count;
  final double income;
  final AutoSizeGroup group;
  final String imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: assetsAspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette().backgroundContentCard,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: AutoSizeText(
                  '$count',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: ColorPalette().lightText,
                    fontSize: 100.0,
                  ),
                ),
              ),
              // Expanded(
              //   child: AutoSizeText(
              //     'x',
              //     textAlign: TextAlign.right,
              //     style: TextStyle(
              //       color: ColorPalette().lightText,
              //       fontSize: 100.0,
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(imagePath),
                ),
              ),
              // Expanded(
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: AutoSizeText(
              //           '$count',
              //           textAlign: TextAlign.right,
              //           style: TextStyle(
              //             color: ColorPalette().lightText,
              //             fontSize: 100.0,
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         flex: 5,
              //         child: AutoSizeText(
              //           ' x $title',
              //           maxLines: 1,
              //           minFontSize: 8,
              //           style: TextStyle(
              //             color: ColorPalette().lightText,
              //             fontSize: 100.0,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        income.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorPalette().lightText,
                          fontSize: 100.0,
                        ),
                      ),

                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: AutoSizeText(
                      //     '+\$${income.toStringAsFixed(2)}',
                      //     style: TextStyle(
                      //       color: ColorPalette().lightText,
                      //       fontSize: 100.0,
                      //     ),
                      //   ),
                      // ),
                    ),
                    // Expanded(
                    //   child: AutoSizeText(
                    //     ' / period',
                    //     minFontSize: 4,
                    //     maxLines: 1,
                    //     style: TextStyle(
                    //       color: ColorPalette().lightText,
                    //       fontSize: 100.0,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
