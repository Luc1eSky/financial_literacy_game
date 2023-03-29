import 'package:financial_literacy_game/config/constants.dart';

import '../utils/utils.dart';
import 'asset.dart';
import 'loan.dart';

class Level {
  final double requiredCash;
  final List<Asset> assets;
  final Loan loan;
  final double savingsRate;

  Level({
    required this.requiredCash,
    required this.assets,
    required this.loan,
    this.savingsRate = defaultSavingsRate,
  });

  // method to copy custom class
  Level copyWith({
    double? requiredCash,
    List<Asset>? assets,
    Loan? loan,
  }) {
    return Level(
      requiredCash: requiredCash ?? this.requiredCash,
      assets: assets ?? copyAssetArray(this.assets),
      loan: loan ?? this.loan.copyWith(),
    );
  }
}
