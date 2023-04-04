// helper method to copy a list of assets
import 'dart:math';

import '../concepts/asset.dart';
import '../concepts/loan.dart';

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

// get random double value
double getRandomDouble(
    {required double start, required double end, required double steps}) {
  List<double> randomStepList = List.generate(
      (end * 100 - start * 100) ~/ (steps * 100) + 1,
      (index) => start + index * steps);
  return randomStepList[Random().nextInt(randomStepList.length)];
}
