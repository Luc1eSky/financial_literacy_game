// helper method to copy a list of assets
import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/color_palette.dart';
import '../concepts/asset.dart';
import '../concepts/level.dart';
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
double getRandomDouble({required double start, required double end, required double steps}) {
  List<double> randomStepList = List.generate(
      (end * 100 - start * 100) ~/ (steps * 100) + 1, (index) => start + index * steps);
  return randomStepList[Random().nextInt(randomStepList.length)];
}

String generateCashTipMessage({
  required Asset asset,
  required Level level,
}) {
  String tipString = 'Cash: ';
  double profit = asset.income * asset.lifeExpectancy - asset.price;
  String profitString = '${profit > 0 ? '' : '-'} \$${profit.abs()}';
  tipString += '(\$${asset.income} x ${asset.lifeExpectancy}) - \$${asset.price} = $profitString';
  return tipString;
}

String generateLoanTipMessage({
  required Asset asset,
  required Level level,
}) {
  String tipString = 'Loan: ';
  double profit = asset.income * asset.lifeExpectancy - asset.price * (1 + level.loan.interestRate);
  String profitString = '${profit > 0 ? '' : '-'} \$${profit.abs().toStringAsFixed(2)}';
  tipString +=
      '(\$${asset.income} x ${asset.lifeExpectancy}) - (\$${asset.price} x ${1 + level.loan.interestRate}) = '
      '$profitString';
  return tipString;
}

// extension to allow capitalization of first letter in strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

void showErrorSnackBar({required BuildContext context, required String errorMessage}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ColorPalette().errorSnackBarBackground,
      content: Text(
        errorMessage,
        style: TextStyle(color: ColorPalette().darkText),
      ),
    ),
  );
}
