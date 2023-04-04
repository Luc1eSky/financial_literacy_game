import 'package:financial_literacy_game/domain/entities/assets.dart';

import '../concepts/level.dart';
import '../concepts/loan.dart';

List<Level> levels = [
  // Level 1 - initial level with no cash requirement
  Level(
    requiredCash: 0,
    assets: [goats],
    loan: Loan(interestRate: 0.20, asset: cow),
  ),
  // Level 2
  Level(
    requiredCash: 15,
    assets: [chickens],
    loan: Loan(interestRate: 0.30, asset: cow),
  ),
  // Level 3
  Level(
    requiredCash: 20,
    assets: [cow],
    assetsAreRandomized: true,
    loan: Loan(interestRate: 0.40, asset: cow),
  ),
  // Level 4
  Level(
    requiredCash: 30,
    assets: [cow, chickens, goats],
    loan: Loan(interestRate: 0.25, asset: cow),
  ),
  // Level 5
  Level(
    requiredCash: 60,
    assets: [cow, chickens, goats],
    assetsAreRandomized: true,
    loan: Loan(interestRate: 0.30, asset: cow),
  ),
  Level(
    requiredCash: 100,
    assets: [cow, chickens, goats],
    assetsAreRandomized: true,
    loan: Loan(interestRate: 0.30, asset: cow),
  ),
];
