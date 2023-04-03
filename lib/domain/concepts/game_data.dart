import '../../config/constants.dart';
import '../utils/utils.dart';
import 'asset.dart';
import 'loan.dart';

class GameData {
  final int levelId;
  final int period;
  final double cash;
  final double cashInterest;
  final double personalIncome;
  final double personalExpenses;
  final List<Asset> assets;
  final List<Loan> loans;
  final bool isBankrupt;
  final bool gameIsFinished;

  GameData({
    this.levelId = 0,
    this.period = 0,
    this.cash = initialMoney,
    this.cashInterest = defaultCashInterest,
    this.personalIncome = initialPersonalIncome,
    this.personalExpenses = initialPersonalExpenses,
    this.assets = const [],
    this.loans = const [],
    this.isBankrupt = false,
    this.gameIsFinished = false,
  });

  // method to copy custom class
  GameData copyWith({
    int? levelId,
    int? period,
    double? cash,
    double? cashInterest,
    double? personalIncome,
    double? personalExpenses,
    List<Asset>? assets,
    List<Loan>? loans,
    bool? isBankrupt,
    bool? gameIsFinished,
  }) {
    return GameData(
      levelId: levelId ?? this.levelId,
      period: period ?? this.period,
      cash: cash ?? this.cash,
      cashInterest: cashInterest ?? this.cashInterest,
      personalIncome: personalIncome ?? this.personalIncome,
      personalExpenses: personalExpenses ?? this.personalExpenses,
      assets: assets ?? copyAssetArray(this.assets),
      loans: loans ?? copyLoanArray(this.loans),
      isBankrupt: isBankrupt ?? this.isBankrupt,
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
