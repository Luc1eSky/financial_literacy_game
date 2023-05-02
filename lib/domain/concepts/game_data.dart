import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';

import '../../config/constants.dart';
import '../utils/utils.dart';
import 'asset.dart';
import 'loan.dart';

class GameData {
  final Locale locale;
  final NumberFormat currencyFormat;
  final double cash;
  final int levelId;
  final int period;
  final double cashInterest;
  final double personalIncome;
  final double personalExpenses;
  final ConfettiController confettiController;
  final List<Asset> assets;
  final List<Loan> loans;
  final bool isBankrupt;
  final bool currentLevelSolved;
  final bool gameIsFinished;

  GameData({
    required this.locale,
    required this.currencyFormat,
    required this.cash,
    required this.personalIncome,
    required this.personalExpenses,
    required this.confettiController,
    this.levelId = 0,
    this.period = 0,
    this.cashInterest = defaultCashInterest,
    this.assets = const [],
    this.loans = const [],
    this.isBankrupt = false,
    this.currentLevelSolved = false,
    this.gameIsFinished = false,
  });

  // method to copy custom class
  GameData copyWith({
    Locale? locale,
    NumberFormat? currencyFormat,
    int? levelId,
    int? period,
    double? cash,
    double? cashInterest,
    double? personalIncome,
    double? personalExpenses,
    ConfettiController? confettiController,
    List<Asset>? assets,
    List<Loan>? loans,
    bool? isBankrupt,
    bool? currentLevelSolved,
    bool? gameIsFinished,
  }) {
    return GameData(
      locale: locale ?? this.locale,
      currencyFormat: currencyFormat ?? this.currencyFormat,
      levelId: levelId ?? this.levelId,
      period: period ?? this.period,
      cash: cash ?? this.cash,
      cashInterest: cashInterest ?? this.cashInterest,
      personalIncome: personalIncome ?? this.personalIncome,
      personalExpenses: personalExpenses ?? this.personalExpenses,
      confettiController: confettiController ?? this.confettiController,
      assets: assets ?? copyAssetArray(this.assets),
      loans: loans ?? copyLoanArray(this.loans),
      isBankrupt: isBankrupt ?? this.isBankrupt,
      currentLevelSolved: currentLevelSolved ?? this.currentLevelSolved,
      gameIsFinished: gameIsFinished ?? this.gameIsFinished,
    );
  }

  int get cows {
    int cows = 0;
    for (Asset asset in assets) {
      if (asset.type == AssetType.cow) {
        cows += asset.numberOfAnimals;
      }
    }
    return cows;
  }

  int get chickens {
    int chickens = 0;
    for (Asset asset in assets) {
      if (asset.type == AssetType.chicken) {
        chickens += asset.numberOfAnimals;
      }
    }
    return chickens;
  }

  int get goats {
    int goats = 0;
    for (Asset asset in assets) {
      if (asset.type == AssetType.goat) {
        goats += asset.numberOfAnimals;
      }
    }
    return goats;
  }
}
