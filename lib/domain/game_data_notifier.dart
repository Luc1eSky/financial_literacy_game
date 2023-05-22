import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/constants.dart';
import 'concepts/asset.dart';
import 'concepts/game_data.dart';
import 'concepts/loan.dart';
import 'concepts/person.dart';
import 'concepts/recorded_data.dart';
import 'entities/levels.dart';
import 'utils/database.dart';
import 'utils/device_and_personal_data.dart';
import 'utils/utils.dart';

final gameDataNotifierProvider =
    StateNotifierProvider<GameDataNotifier, GameData>((ref) => GameDataNotifier());

class GameDataNotifier extends StateNotifier<GameData> {
  GameDataNotifier()
      : super(GameData(
          person: Person(),
          cash: levels[0].startingCash,
          personalIncome: (levels[0].includePersonalIncome ? levels[0].personalIncome : 0),
          personalExpenses: (levels[0].includePersonalIncome ? levels[0].personalExpenses : 0),
          confettiController: ConfettiController(),
          recordedDataList: [
            RecordedData(
              levelId: 0,
              cashValues: [levels[0].startingCash],
            ),
          ],
        ));

  void setPerson(Person newPerson) {
    state = state.copyWith(person: newPerson);
    debugPrint('Person set to ${newPerson.firstName} ${newPerson.lastName} in game data.');
  }

  void loadLevel(int levelID) {
    _loadLevel(levelID);
    debugPrint('Level ${levelID + 1} loaded from locally saved data.');
  }

  // show confetti animation for a certain amount of time
  void showConfetti() async {
    debugPrint('Show confetti.');
    state.confettiController.play();
    await Future.delayed(const Duration(seconds: showConfettiSeconds));
    state.confettiController.stop();
  }

  void setCashInterest(double newInterest) {
    state = state.copyWith(cashInterest: newInterest);
  }

  void advance(double newCashInterest) async {
    // update cash interest
    state = state.copyWith(cashInterest: newCashInterest);
    // calculate interest on cash
    state = state.copyWith(cash: state.cash * (1 + state.cashInterest));

    // age assets by one period
    List<Asset> survivedAssets = [];
    for (Asset asset in state.assets) {
      if (asset.age < asset.lifeExpectancy) {
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
    double newCash = state.cash + netIncome;
    state = state.copyWith(cash: newCash);

    advancePeriodFirestore(newCashValue: newCash);

    // check if bankrupt
    if (state.cash < 0) {
      state = state.copyWith(isBankrupt: true);
    }

    // check if next level was reached
    //int nextLevelId = state.levelId + 1;
    if (state.cash >= levels[state.levelId].cashGoal) {
      // check if game has ended
      if (state.levelId + 1 >= (levels.length)) {
        state = state.copyWith(gameIsFinished: true);
      } else {
        // TODO: ADD NEW RECORDED DATA OBJECT TO LIST
        state = state.copyWith(currentLevelSolved: true);
      }
    }

    // record data
    //state.recordedDataList.last.cashValues.add(state.cash);
    // print('CASH RECORD FOR LEVEL ${state.recordedDataList.last.levelId}: ');
    // for (double cash in state.recordedDataList.last.cashValues) {
    //   print('$cash, ');
    // }
  }

  void restartLevel() {
    restartLevelFirebase(
      level: state.levelId + 1,
      startingCash: levels[state.levelId].startingCash,
    );
    state = state.copyWith(isBankrupt: false);
    _loadLevel(state.levelId);
  }

  // move on to next level, reset cash, loans, and assets, reset level solved flag
  void moveToNextLevel() {
    // TODO: ADD NEW RECORDED DATA OBJECT

    // state.recordedDataList.add(
    //   RecordedData(
    //     levelId: state.levelId + 1,
    //     cashValues: [levels[state.levelId + 1].startingCash],
    //   ),
    // );
    int nextLevelID = state.levelId + 1;
    _loadLevel(nextLevelID);
    newLevelFirestore(
      levelID: nextLevelID,
      startingCash: levels[nextLevelID].startingCash,
    );
  }

  void _loadLevel(int levelID) {
    if (levelID >= 0 && levelID < levels.length) {
      // move to specified level, reset cash
      state = state.copyWith(
        levelId: levelID,
        cash: levels[levelID].startingCash,
        assets: [], // remove all previous assets
        loans: [], // remove all previous loans
        currentLevelSolved: false, // resetLevelSolved flag
      );
      // save current level locally
      saveLevelIDLocally(levelID);
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

  Future<bool> buyAsset(Asset asset, Function showNotEnoughCash, Function showAnimalDied,
      double newCashInterest) async {
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

  Future<void> loanAsset(
      Loan loan, Asset asset, Function showAnimalDied, double newCashInterest) async {
    // check if animal died based on risk level
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

    double totalExpenses =
        loanPayments + (levels[state.levelId].includePersonalIncome ? state.personalExpenses : 0);
    return totalExpenses;
  }

  // calculate total income of everything
  double calculateTotalIncome() {
    double assetIncome = 0;
    for (Asset asset in state.assets) {
      assetIncome += asset.income;
    }
    double totalIncome =
        assetIncome + (levels[state.levelId].includePersonalIncome ? state.personalIncome : 0);
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
    state = GameData(
      person: state.person,
      cash: levels[0].startingCash,
      personalIncome: (levels[0].includePersonalIncome ? levels[0].personalIncome : 0),
      personalExpenses: (levels[0].includePersonalIncome ? levels[0].personalExpenses : 0),
      confettiController: state.confettiController,
    );
    // save current level locally
    saveLevelIDLocally(0);

    startGameSession(person: state.person, startingCash: levels[0].startingCash);
  }

  double calculateSavingsROI({required double cashInterest, int lifeExpectancy = 6}) {
    return (state.cash * pow(1 + cashInterest, lifeExpectancy) - state.cash) / lifeExpectancy;
  }

  double calculateBuyCashROI({
    required double riskLevel,
    required double expectedIncome,
    required double assetPrice,
    int lifeExpectancy = 6,
  }) {
    return (lifeExpectancy * expectedIncome * (1 - riskLevel) - assetPrice) / lifeExpectancy;
  }

  double calculateBorrowROI({
    required double riskLevel,
    required double expectedIncome,
    required double assetPrice,
    required double interestRate,
    int lifeExpectancy = 6,
  }) {
    return (lifeExpectancy * expectedIncome * (1 - riskLevel) - (assetPrice * (1 + interestRate))) /
        lifeExpectancy;
  }
}
