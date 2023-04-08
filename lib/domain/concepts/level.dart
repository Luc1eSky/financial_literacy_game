import '../../config/constants.dart';
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
  final bool showCashBuyOption;
  final bool showLoanBorrowOption;
  final bool assetTypeRandomized;
  final bool assetRiskLevelRandomized;
  final bool assetIncomeAndCostsRandomized;
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
    this.showCashBuyOption = false,
    this.showLoanBorrowOption = false,
    this.assetTypeRandomized = false,
    this.assetRiskLevelRandomized = false,
    this.assetIncomeAndCostsRandomized = false,
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
    bool? showCashBuyOption,
    bool? showLoanBorrowOption,
    bool? assetTypeRandomized,
    bool? assetRiskLevelRandomized,
    bool? assetIncomeAndCostsRandomized,
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
      showCashBuyOption: showCashBuyOption ?? this.showCashBuyOption,
      showLoanBorrowOption: showLoanBorrowOption ?? this.showLoanBorrowOption,
      assetTypeRandomized: assetTypeRandomized ?? this.assetTypeRandomized,
      assetRiskLevelRandomized: assetRiskLevelRandomized ?? this.assetRiskLevelRandomized,
      assetIncomeAndCostsRandomized:
          assetIncomeAndCostsRandomized ?? this.assetIncomeAndCostsRandomized,
      loanInterestRandomized: loanInterestRandomized ?? this.loanInterestRandomized,
      savingsInterestRandomized: savingsInterestRandomized ?? this.savingsInterestRandomized,
      loan: loan ?? this.loan.copyWith(),
      savingsRate: savingsRate ?? this.savingsRate,
    );
  }
}
