import 'package:financial_literacy_game/domain/entities/assets.dart';
import 'package:financial_literacy_game/domain/entities/loans.dart';

import '../concepts/level.dart';

List<Level> levels = [
  // Level 1 - initial level with no cash requirement
  Level(
    requiredCash: 0,
    assets: [goats],
    loan: defaultLoan,
  ),
  // Level 2
  Level(
    requiredCash: 15,
    assets: [chickens],
    loan: defaultLoan,
  ),
  // Level 3
  Level(
    requiredCash: 30,
    assets: [cow],
    loan: defaultLoan,
  ),
  // Level 4
  Level(
    requiredCash: 50,
    assets: [cow, chickens, goats],
    loan: defaultLoan,
  ),
  // Level 5
  Level(
    requiredCash: 100,
    assets: [cow, chickens, goats],
    loan: defaultLoan,
  ),
];
