import 'dart:math';

import 'package:financial_literacy_game/config/constants.dart';
import 'package:financial_literacy_game/domain/concepts/asset.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'concepts/game_data.dart';
import 'concepts/loan.dart';
import 'entities/levels.dart';

final gameDataNotifierProvider =
    StateNotifierProvider<GameDataNotifier, GameData>(
        (ref) => GameDataNotifier());

class GameDataNotifier extends StateNotifier<GameData> {
  GameDataNotifier() : super(GameData());

  void setCashInterest(double newInterest) {
    state = state.copyWith(cashInterest: newInterest);
  }

  void advance(double newCashInterest) {
    // TODO: PERIODS STILL COUNTED?
    // increase period counter
    //state = state.copyWith(period: min(state.period + 1, maxPeriod));

    // update cash interest
    state = state.copyWith(cashInterest: newCashInterest);
    // calculate interest on cash
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

    double netIncome = calculateTotalIncome() - calculateTotalExpenses();
    state = state.copyWith(cash: state.cash + netIncome);

    // check if bankrupt
    if (state.cash < 0) {
      state = state.copyWith(isBankrupt: true);
    }

    // check if next level was reached
    for (int i = levels.length - 1; i > state.levelId; i--) {
      if (state.cash >= levels[i].requiredCash) {
        // move on to next level
        state = state.copyWith(levelId: i, cash: initialMoney);
        break;
      }
    }

    // check if game has ended
    if (state.levelId >= (levels.length - 1)) {
      state = state.copyWith(gameIsFinished: true);
    }
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

  Future<bool> _animalDied(Asset asset, Function showAnimalDied) async {
    if (asset.riskLevel > Random().nextDouble()) {
      return await showAnimalDied(asset);
    } else {
      return false;
    }
  }

  Future<bool> buyAsset(Asset asset, Function showNotEnoughCash,
      Function showAnimalDied, double newCashInterest) async {
    if (state.cash >= asset.price) {
      state = state.copyWith(cash: state.cash - asset.price);
      //check if animal died based on risk level
      if (!await _animalDied(asset, showAnimalDied)) {
        _addAsset(asset);
      }
      advance(newCashInterest);
      return true;
    } else {
      showNotEnoughCash();
      return false;
    }
  }

  Future<void> loanAsset(Loan loan, Asset asset, Function showAnimalDied,
      double newCashInterest) async {
    //check if animal died based on risk level
    if (!await _animalDied(asset, showAnimalDied)) {
      _addAsset(asset);
    }
    Loan issuedLoan = loan.copyWith(asset: asset);
    _addLoan(issuedLoan);
    advance(newCashInterest);
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

  void resetGame() {
    // TODO: TRACK / SAVE GAME DATA
    state = GameData();
  }

  double calculateSavingsROI(
      {required double cashInterest, int lifeExpectancy = 6}) {
    return (state.cash * pow(1 + cashInterest, lifeExpectancy) - state.cash) /
        lifeExpectancy;
  }

  double calculateBuyCashROI({
    required double riskLevel,
    required double expectedIncome,
    required double assetPrice,
    int lifeExpectancy = 6,
  }) {
    return (lifeExpectancy * expectedIncome * (1 - riskLevel) - assetPrice) /
        lifeExpectancy;
  }

  double calculateBorrowROI({
    required double riskLevel,
    required double expectedIncome,
    required double assetPrice,
    required double interestRate,
    int lifeExpectancy = 6,
  }) {
    return (lifeExpectancy * expectedIncome * (1 - riskLevel) -
            (assetPrice * (1 + interestRate))) /
        lifeExpectancy;
  }
}
