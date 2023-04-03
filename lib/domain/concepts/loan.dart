import 'package:financial_literacy_game/domain/utils/utils.dart';

import '../../config/constants.dart';
import '../entities/assets.dart';
import 'asset.dart';

class Loan {
  final double interestRate;
  final Asset asset;
  final int termInPeriods;
  final int age;

  Loan({
    required this.interestRate,
    required this.asset,
    this.termInPeriods = defaultLoanTerm,
    this.age = 0,
  });

  // method to copy custom class
  Loan copyWith({
    double? interestRate,
    Asset? asset,
    int? termInPeriods,
    int? age,
  }) {
    return Loan(
      interestRate: interestRate ?? this.interestRate,
      asset: asset ?? this.asset.copyWith(),
      termInPeriods: termInPeriods ?? this.termInPeriods,
      age: age ?? this.age,
    );
  }

  double get paymentPerPeriod {
    return asset.price * (1 + interestRate) / termInPeriods;
  }
}

Loan getRandomLoan() {
  return Loan(
      interestRate: getRandomDouble(
        start: minimumInterestRate,
        end: maximumInterestRate,
        steps: stepsInterestRate,
      ),
      asset: cow);
}
