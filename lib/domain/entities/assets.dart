import 'dart:math';

import 'package:financial_literacy_game/config/constants.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';

import '../concepts/asset.dart';

Asset goats = Asset(
  type: AssetType.goat,
  numberOfAnimals: 3,
  imagePath: 'assets/images/goat.png',
  price: 10,
  income: 3,
  riskLevel: 0.30,
);

Asset cow = Asset(
  type: AssetType.cow,
  numberOfAnimals: 1,
  imagePath: 'assets/images/cow.png',
  price: 10,
  income: 4,
  riskLevel: 0.40,
);

Asset chickens = Asset(
  type: AssetType.chicken,
  numberOfAnimals: 50,
  imagePath: 'assets/images/chicken.png',
  price: 10,
  income: 2,
  riskLevel: 0.20,
);

List<Asset> allDefaultAssets = [goats, cow, chickens];

Asset getRandomAsset() {
  Asset randomDefaultAsset =
      allDefaultAssets[Random().nextInt(allDefaultAssets.length)];
  Asset randomAsset = randomDefaultAsset.copyWith(
    riskLevel: getRandomDouble(
      start: minimumRiskLevel,
      end: maximumRiskLevel,
      steps: stepsRiskLevel,
    ),
  );
  return randomAsset;
}
