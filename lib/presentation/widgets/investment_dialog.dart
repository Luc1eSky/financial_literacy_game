import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../config/constants.dart';
import '../../domain/concepts/asset.dart';
import '../../domain/concepts/level.dart';
import '../../domain/concepts/loan.dart';
import '../../domain/entities/assets.dart';
import '../../domain/entities/levels.dart';
import '../../domain/game_data_notifier.dart';
import '../../domain/utils/utils.dart';
import 'asset_carousel.dart';
import 'cash_alert_dialog.dart';
import 'lost_game_dialog.dart';
import 'next_level_dialog.dart';
import 'won_game_dialog.dart';

class InvestmentDialog extends StatefulWidget {
  final WidgetRef ref;
  const InvestmentDialog({Key? key, required this.ref}) : super(key: key);

  @override
  State<InvestmentDialog> createState() => _InvestmentDialogState();
}

void checkBankruptcy(WidgetRef ref, BuildContext context) {
  if (ref.read(gameDataNotifierProvider).isBankrupt) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return LostGameDialog(ref: ref);
      },
    );
  }
}

void checkGameHasEnded(WidgetRef ref, BuildContext context) {
  if (ref.read(gameDataNotifierProvider).gameIsFinished) {
    ref.read(gameDataNotifierProvider.notifier).showConfetti();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WonGameDialog(ref: ref);
      },
    );
  }
}

void checkNextLevelReached(WidgetRef ref, BuildContext context) {
  if (ref.read(gameDataNotifierProvider).currentLevelSolved) {
    ref.read(gameDataNotifierProvider.notifier).showConfetti();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return NextLevelDialog(ref: ref);
      },
    );
  }
}

class _InvestmentDialogState extends State<InvestmentDialog> {
  final AutoSizeGroup textGroup = AutoSizeGroup();
  late List<Asset> levelAssets;
  late Loan levelLoan;
  late Level currentLevel;

  int _selectedIndex = 0;

  @override
  void initState() {
    Level defaultLevel =
        levels[widget.ref.read(gameDataNotifierProvider).levelId];
    currentLevel = defaultLevel.copyWith(
      loan: defaultLevel.loanInterestRandomized
          ? getRandomLoan()
          : defaultLevel.loan,
      savingsRate: defaultLevel.savingsInterestRandomized
          ? getRandomDouble(
              start: minimumSavingsRate,
              end: maximumSavingsRate,
              steps: stepsSavingsRate,
            )
          : defaultLevel.savingsRate,
    );
    if (currentLevel.assetTypeRandomized) {
      List<Asset> randomizedAssets = [];
      for (int i = 0; i < currentLevel.assets.length; i++) {
        randomizedAssets.add(currentLevel.assetRiskLevelActive
            ? getRandomAsset()
            : getRandomAsset().copyWith(riskLevel: 0));
      }
      currentLevel = currentLevel.copyWith(assets: randomizedAssets);
    }

    if (currentLevel.assetRiskLevelActive &&
        currentLevel.assetRiskLevelRandomized) {
      List<Asset> randomizedRiskAssets = [];
      for (Asset asset in currentLevel.assets) {
        randomizedRiskAssets.add(
          asset.copyWith(
            riskLevel: getRandomDouble(
              start: minimumRiskLevel,
              end: maximumRiskLevel,
              steps: stepsRiskLevel,
            ),
          ),
        );
      }
      currentLevel = currentLevel.copyWith(assets: randomizedRiskAssets);
    }

    if (currentLevel.assetIncomeAndCostsRandomized) {
      List<Asset> randomizedIncomeAndCostsAssets = [];
      for (Asset asset in currentLevel.assets) {
        randomizedIncomeAndCostsAssets.add(
          asset.copyWith(
            price: asset.price +
                (asset.price ~/
                    (1 /
                        getRandomDouble(
                            start: 0, end: priceVariation, steps: 0.01)) *
                    (Random().nextBool() ? -1 : 1)),
            income: asset.income +
                (Random().nextBool() ? -1 : 1) *
                    (Random().nextBool() ? 0 : incomeVariation),
          ),
        );
      }
      currentLevel =
          currentLevel.copyWith(assets: randomizedIncomeAndCostsAssets);
    }

    levelAssets = currentLevel.assets;
    levelLoan = currentLevel.loan;

    //widget.ref.read(gameDataNotifierProvider.notifier).setCashInterest(currentLevel.savingsRate);
    super.initState();
  }

  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Asset selectedAsset = levelAssets[_selectedIndex];

    Future<bool> showNotEnoughCash() async {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const CashAlertDialog();
          });
    }

    Future<bool> showAnimalDiedWarning(Asset asset) async {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.warning),
              content: asset.numberOfAnimals > 1
                  ? Text(AppLocalizations.of(context)!.assetsDied.capitalize())
                  : Text(
                      AppLocalizations.of(context)!.assetDied(asset.type.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppLocalizations.of(context)!.confirm),
                )
              ],
            );
          });
    }

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: ColorPalette().popUpBackground,
          insetPadding: EdgeInsets.zero,
          // title: Text(
          //   AppLocalizations.of(context)!.investmentOptions,
          //   style: const TextStyle(
          //     fontSize: 20.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          content: SizedBox(
            width: min(MediaQuery.of(context).size.width, 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  AppLocalizations.of(context)!
                      .currentCash(widget.ref
                          .read(gameDataNotifierProvider.notifier)
                          .convertAmount(
                              widget.ref.read(gameDataNotifierProvider).cash))
                      .capitalize(),
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                  group: textGroup,
                ),
                const SizedBox(height: 5),
                AspectRatio(
                  aspectRatio: 1.0,
                  child: AssetCarousel(
                    assets: levelAssets,
                    textGroup: textGroup,
                    changingIndex: setIndex,
                  ),
                ),
                const SizedBox(height: 5),
                // AutoSizeText(
                //   AppLocalizations.of(context)!.tip.capitalize(),
                //   maxLines: 1,
                //   style: const TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   group: textGroup,
                // ),
                if (currentLevel.showLoanBorrowOption)
                  AutoSizeText(
                    AppLocalizations.of(context)!
                        .borrowAt((levelLoan.interestRate * 100)
                            .toStringAsFixed(decimalValuesToDisplay))
                        .capitalize(),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                    group: textGroup,
                  ),
                if (currentLevel.savingsRate != 0 ||
                    currentLevel.savingsInterestRandomized)
                  AutoSizeText(
                    AppLocalizations.of(context)!.interestCash(
                        (currentLevel.savingsRate * 100)
                            .toStringAsFixed(decimalValuesToDisplay)),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                    group: textGroup,
                  ),
                if (currentLevel.savingsRate == 0 &&
                    currentLevel.showCashBuyOption &&
                    (widget.ref.read(gameDataNotifierProvider).levelId == 0 ||
                        widget.ref.read(gameDataNotifierProvider).period < 4))
                  AutoSizeText(
                    generateCashTipMessage(
                      ref: widget.ref,
                      context: context,
                      asset: selectedAsset,
                      level: currentLevel,
                    ),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                    group: textGroup,
                  ),
                if (currentLevel.savingsRate == 0 &&
                    currentLevel.showLoanBorrowOption &&
                    widget.ref.read(gameDataNotifierProvider).period < 4)
                  AutoSizeText(
                    generateLoanTipMessage(
                      context: context,
                      asset: selectedAsset,
                      level: currentLevel,
                      ref: widget.ref,
                    ),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                    group: textGroup,
                  ),
                if (currentLevel.savingsRate == 0 &&
                    currentLevel.showLoanBorrowOption &&
                    widget.ref.read(gameDataNotifierProvider).period >= 4)
                  AutoSizeText(
                    generateInterestAmountTipMessage(
                      context: context,
                      asset: selectedAsset,
                      level: currentLevel,
                      ref: widget.ref,
                    ),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                    group: textGroup,
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 8.0,
                foregroundColor: ColorPalette().lightText,
                backgroundColor: ColorPalette().buttonBackground,
                textStyle: const TextStyle(fontSize: 13.0),
              ),
              onPressed: () {
                widget.ref.read(gameDataNotifierProvider.notifier).advance(
                      newCashInterest: currentLevel.savingsRate,
                      buyDecision: BuyDecision.dontBuy,
                      selectedAsset: selectedAsset,
                    );
                Navigator.pop(context);
                checkBankruptcy(widget.ref, context);
                checkGameHasEnded(widget.ref, context);
                checkNextLevelReached(widget.ref, context);
              },
              child: Text(AppLocalizations.of(context)!.dontBuy),
            ),
            if (currentLevel.showCashBuyOption)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    foregroundColor: ColorPalette().lightText,
                    backgroundColor: ColorPalette().buttonBackground,
                    textStyle: const TextStyle(fontSize: 13.0),
                  ),
                  onPressed: () async {
                    if (await widget.ref
                            .read(gameDataNotifierProvider.notifier)
                            .buyAsset(
                              selectedAsset,
                              showNotEnoughCash,
                              showAnimalDiedWarning,
                              currentLevel.savingsRate,
                            ) ==
                        true) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        checkBankruptcy(widget.ref, context);
                        checkGameHasEnded(widget.ref, context);
                        checkNextLevelReached(widget.ref, context);
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.payCash)),
            if (currentLevel.showLoanBorrowOption)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    foregroundColor: ColorPalette().lightText,
                    backgroundColor: ColorPalette().buttonBackground,
                    textStyle: const TextStyle(fontSize: 13.0),
                  ),
                  onPressed: () async {
                    await widget.ref
                        .read(gameDataNotifierProvider.notifier)
                        .loanAsset(levelLoan, selectedAsset,
                            showAnimalDiedWarning, currentLevel.savingsRate);
                    if (context.mounted) {
                      Navigator.pop(context);
                      checkBankruptcy(widget.ref, context);
                      checkGameHasEnded(widget.ref, context);
                      checkNextLevelReached(widget.ref, context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.borrow)),
          ],
        ),
      ),
    );
  }
}
