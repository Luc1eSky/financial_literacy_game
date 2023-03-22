import 'package:financial_literacy_game/domain/concepts/asset.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'concepts/game_data.dart';
import 'concepts/loan.dart';

final gameDataNotifierProvider =
    StateNotifierProvider<GameDataNotifier, GameData>((ref) => GameDataNotifier());

class GameDataNotifier extends StateNotifier<GameData> {
  GameDataNotifier() : super(GameData());

  void advance() {
    state = state.copyWith(period: state.period + 1);
    // TODO: calculate interest on cash
    state = state.copyWith(cash: state.cash * (1 + state.cashInterest));

    // age assets by one period
    List<Asset> survivedAssets = [];
    for (Asset asset in state.assets) {
      if (asset.age < asset.lifeSpan) {
        // add to survived list if not too old
        Asset olderAsset = asset.copyWith(age: asset.age + 1);
        survivedAssets.add(olderAsset);
      }
    }
    state = state.copyWith(assets: survivedAssets);

    // age loans by one period
    List<Loan> activeLoans = [];
    for (Loan loan in state.loans) {
      if (loan.age < loan.termInPeriods) {
        // add to survived list if not too old
        Loan olderLoan = loan.copyWith(age: loan.age + 1);
        activeLoans.add(olderLoan);
      }
    }
    state = state.copyWith(loans: activeLoans);

    // TODO: add net income to cash
    double netIncome = calculateTotalIncome() - calculateTotalExpenses();
    state = state.copyWith(cash: state.cash + netIncome);
  }

  void _addAsset(Asset newAsset) {
    List<Asset> newAssetList = copyAssetArray(state.assets);
    newAssetList.add(newAsset);
    state = state.copyWith(assets: newAssetList);
  }

  void _addLoan(Loan newLoan) {
    List<Loan> newLoanList = copyLoanArray(state.loans);
    newLoanList.add(newLoan);
    state = state.copyWith(loans: newLoanList);
  }

  bool buyAsset(Asset asset) {
    if (state.cash >= asset.price) {
      state = state.copyWith(cash: state.cash - asset.price);
      _addAsset(asset);
      advance();
      return true;
    }
    return false;
  }

  void loanAsset(Loan loan, Asset asset) {
    Loan issuedLoan = loan.copyWith(loanAmount: asset.price);
    // add loan
    _addLoan(issuedLoan);
    _addAsset(asset);
    advance();
  }

  double calculateTotalExpenses() {
    double loanPayments = 0;
    for (Loan loan in state.loans) {
      loanPayments += loan.paymentPerPeriod;
    }
    double totalExpenses = state.personalExpenses + loanPayments;
    return totalExpenses;
  }

  // calculate total income of everything
  double calculateTotalIncome() {
    double assetIncome = 0;
    for (Asset asset in state.assets) {
      assetIncome += asset.income;
    }
    double totalIncome = state.personalIncome + assetIncome;
    return totalIncome;
  }

  // calculate income for specific asset
  double calculateIncome(AssetType assetType) {
    double income = 0;
    for (Asset asset in state.assets) {
      if (asset.type == assetType) {
        income += asset.income;
      }
    }
    return income;
  }
}
