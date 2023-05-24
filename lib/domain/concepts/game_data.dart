import 'dart:ui';

import 'package:confetti/confetti.dart';

import '../../config/constants.dart';
import '../../domain/concepts/recorded_data.dart';
import '../concepts/person.dart';
import '../utils/utils.dart';
import 'asset.dart';
import 'loan.dart';

class GameData {
  final Person person;
  final Locale locale;
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
  final List<RecordedData> recordedDataList;

  GameData({
    required this.person,
    required this.locale,
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
    this.recordedDataList = const [],
  });

  // method to copy custom class
  GameData copyWith({
    Person? person,
    Locale? locale,
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
    List<RecordedData>? recordedDataList,
  }) {
    return GameData(
      person: person ?? this.person.copyWith(),
      locale: locale ?? this.locale,
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
      recordedDataList: recordedDataList ?? copyRecordedDataArray(this.recordedDataList),
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
