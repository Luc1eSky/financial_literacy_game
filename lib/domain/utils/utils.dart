import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/recorded_data.dart';
import '../concepts/asset.dart';
import '../concepts/level.dart';
import '../concepts/loan.dart';

List<RecordedData> copyRecordedDataArray(List<RecordedData> recordedDataList) {
  List<RecordedData> copiedRecordedDataList = [];
  for (RecordedData recordedData in recordedDataList) {
    copiedRecordedDataList.add(recordedData);
  }
  return copiedRecordedDataList;
}

List<double> copyCashArray(List<double> cashList) {
  List<double> copiedCashList = [];
  for (double cashValue in cashList) {
    copiedCashList.add(cashValue);
  }
  return copiedCashList;
}

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

String generateCashTipMessage({
  required Asset asset,
  required Level level,
  required BuildContext context,
}) {
  String tipString = '${AppLocalizations.of(context)!.cash}: ';
  double profit = asset.income * asset.lifeExpectancy - asset.price;
  String profitString = AppLocalizations.of(context)!.cashValue(profit);
  tipString +=
      '(${AppLocalizations.of(context)!.cashValue(asset.income)} x ${asset.lifeExpectancy}) - ${AppLocalizations.of(context)!.cashValue(asset.price)} = '
      '$profitString';
  return tipString;
}

String generateLoanTipMessage({
  required Asset asset,
  required Level level,
  required BuildContext context,
}) {
  String tipString = '${AppLocalizations.of(context)!.loan(1)}: ';
  double profit = asset.income * asset.lifeExpectancy -
      asset.price * (1 + level.loan.interestRate);
  String profitString = AppLocalizations.of(context)!.cashValue(profit);
  tipString +=
      '(${AppLocalizations.of(context)!.cashValue(asset.income)} x ${asset.lifeExpectancy}) - (${AppLocalizations.of(context)!.cashValue(asset.price)} x ${1 + level.loan.interestRate}) = '
      '$profitString';
  return tipString;
}

// extension to allow capitalization of first letter in strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

void showErrorSnackBar(
    {required BuildContext context, required String errorMessage}) {
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

String removeTrailing(String pattern, String from) {
  if (pattern.isEmpty) return from;
  var i = from.length;
  while (from.startsWith(pattern, i - pattern.length)) {
    i -= pattern.length;
  }
  return from.substring(0, i);
}

String removeLeading(String pattern, String from) {
  if (pattern.isEmpty) return from;
  var i = 0;
  while (from.startsWith(pattern, i)) {
    i += pattern.length;
  }
  return from.substring(i);
}
