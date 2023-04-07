import 'package:financial_literacy_game/config/constants.dart';

import '../utils/utils.dart';
import 'asset.dart';
import 'loan.dart';

class Level {
  final double cashGoal;
  final double startingCash;
  final double personalIncome;
  final double personalExpenses;
  final List<Asset> assets;
  final bool includePersonalIncome;
  final bool assetsAreRandomized;
  final bool loanInterestRandomized;
  final bool savingsInterestRandomized;
  final Loan loan;
  final double savingsRate;

  Level({
    required this.cashGoal,
    this.startingCash = defaultLevelStartMoney,
    this.personalIncome = defaultPersonalIncome,
    this.personalExpenses = defaultPersonalExpenses,
    required this.assets,
    this.includePersonalIncome = false,
    this.assetsAreRandomized = false,
    this.loanInterestRandomized = false,
    this.savingsInterestRandomized = false,
    required this.loan,
    this.savingsRate = defaultCashInterest,
  });

  // method to copy custom class
  Level copyWith({
    double? startingCash,
    double? cashGoal,
    double? personalIncome,
    double? personalExpenses,
    List<Asset>? assets,
    bool? includePersonalIncome,
    bool? assetsAreRandomized,
    bool? loanInterestRandomized,
    bool? savingsInterestRandomized,
    Loan? loan,
    double? savingsRate,
  }) {
    return Level(
      startingCash: startingCash ?? this.startingCash,
      cashGoal: cashGoal ?? this.cashGoal,
      personalIncome: personalIncome ?? this.personalIncome,
      personalExpenses: personalExpenses ?? this.personalExpenses,
      assets: assets ?? copyAssetArray(this.assets),
      includePersonalIncome: includePersonalIncome ?? this.includePersonalIncome,
      assetsAreRandomized: assetsAreRandomized ?? this.assetsAreRandomized,
      loanInterestRandomized: loanInterestRandomized ?? this.loanInterestRandomized,
      savingsInterestRandomized: savingsInterestRandomized ?? this.savingsInterestRandomized,
      loan: loan ?? this.loan.copyWith(),
      savingsRate: savingsRate ?? this.savingsRate,
    );
  }
}
