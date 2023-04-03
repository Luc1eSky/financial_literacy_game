import 'package:financial_literacy_game/config/constants.dart';

import '../utils/utils.dart';
import 'asset.dart';
import 'loan.dart';

class Level {
  final double requiredCash;
  final List<Asset> assets;
  final bool assetsAreRandomized;
  final Loan loan;
  final double savingsRate;

  Level({
    required this.requiredCash,
    required this.assets,
    this.assetsAreRandomized = false,
    required this.loan,
    this.savingsRate = defaultCashInterest,
  });

  // method to copy custom class
  Level copyWith({
    double? requiredCash,
    List<Asset>? assets,
    bool? assetsAreRandomized,
    Loan? loan,
    double? savingsRate,
  }) {
    return Level(
      requiredCash: requiredCash ?? this.requiredCash,
      assets: assets ?? copyAssetArray(this.assets),
      assetsAreRandomized: assetsAreRandomized ?? this.assetsAreRandomized,
      loan: loan ?? this.loan.copyWith(),
      savingsRate: savingsRate ?? this.savingsRate,
    );
  }
}
