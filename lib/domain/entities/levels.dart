import 'package:financial_literacy_game/domain/entities/assets.dart';

import '../concepts/level.dart';
import '../concepts/loan.dart';

List<Level> levels = [
  // Level 1 - initial level with no cash requirement
  Level(
    requiredCash: 0,
    assets: [goats],
    loan: Loan(interestRate: 5.0, loanAmount: 0),
  ),
  // Level 2
  Level(
    requiredCash: 30,
    assets: [chickens],
    loan: Loan(interestRate: 5.0, loanAmount: 0),
  ),
  // Level 3
  Level(
    requiredCash: 50,
    assets: [cow],
    loan: Loan(interestRate: 5.0, loanAmount: 0),
  ),
  // Level 4
  Level(
    requiredCash: 60,
    assets: [cow, chickens, goats],
    loan: Loan(interestRate: 5.0, loanAmount: 0),
  ),
  // Level 5
  Level(
    requiredCash: 100,
    assets: [cow, chickens, goats],
    loan: Loan(interestRate: 5.0, loanAmount: 0),
  ),
];
