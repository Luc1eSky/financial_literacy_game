import '../../config/constants.dart';
import 'asset.dart';
import 'loan.dart';

class GameData {
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
    this.period = 0,
    this.cash = initialMoney,
    this.cashInterest = initialCashInterest,
    this.personalIncome = initialPersonalIncome,
    this.personalExpenses = initialPersonalExpenses,
    this.assets = const [],
    this.loans = const [],
    this.isBankrupt = false,
    this.gameIsFinished = false,
  });

  // method to copy custom class
  GameData copyWith({
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
        cows++;
      }
    }
    return cows;
  }

  int get chickens {
    int chickens = 0;
    for (Asset asset in assets) {
      if (asset.type == AssetType.chicken) {
        chickens++;
      }
    }
    return chickens;
  }

  int get goats {
    int goats = 0;
    for (Asset asset in assets) {
      if (asset.type == AssetType.goat) {
        goats++;
      }
    }
    return goats;
  }
}

// helper method to copy a list of assets
List<Asset> copyAssetArray(List<Asset> assetList) {
  List<Asset> copiedAssetList = [];
  for (Asset asset in assetList) {
    copiedAssetList.add(asset.copyWith());
  }
  return copiedAssetList;
}

// helper method to copy a list of loans
List<Loan> copyLoanArray(List<Loan> loanList) {
  List<Loan> copiedLoanList = [];
  for (Loan loan in loanList) {
    copiedLoanList.add(loan.copyWith());
  }
  return copiedLoanList;
}
