import '../concepts/level.dart';
import '../concepts/loan.dart';
import 'assets.dart';

List<Level> levels = [
  // Level 1 - cash only, no interest on cash, high starting cash amount
  Level(
    startingCash: 50,
    cashGoal: 75, //100,
    assets: [chickens.copyWith(riskLevel: 0)],
    loan: Loan(interestRate: 0.25, asset: cow),
    assetTypeRandomized: true,
    assetIncomeAndCostsRandomized: true,
    showCashBuyOption: true,
    savingsRate: 0.00,
  ),
  // Level 2 - cash only, no interest on cash, low starting cash amount
  Level(
    startingCash: 15,
    cashGoal: 50,
    assets: [chickens.copyWith(riskLevel: 0)],
    loan: Loan(interestRate: 0.25, asset: cow),
    assetTypeRandomized: true,
    assetIncomeAndCostsRandomized: true,
    showCashBuyOption: true,
    savingsRate: 0.00,
  ),
  // Level 3 - borrow only, no interest on cash, low starting cash amount
  Level(
    startingCash: 15,
    cashGoal: 50,
    assets: [chickens.copyWith(riskLevel: 0)],
    loan: Loan(interestRate: 0.20, asset: cow),
    assetTypeRandomized: true,
    assetIncomeAndCostsRandomized: true,
    showLoanBorrowOption: true,
    savingsRate: 0.00,
  ),
  // Level 4 - borrow and cash options, no interest on cash, low starting cash amount
  Level(
    startingCash: 10,
    cashGoal: 50,
    assets: [chickens.copyWith(riskLevel: 0)],
    loan: Loan(interestRate: 0.20, asset: cow),
    assetTypeRandomized: true,
    assetIncomeAndCostsRandomized: true,
    showCashBuyOption: true,
    showLoanBorrowOption: true,
    savingsRate: 0.00,
  ),
];
