import 'dart:math';

import '../concepts/asset.dart';

Asset goats = Asset(
  type: AssetType.goat,
  numberOfAnimals: 3,
  imagePath: 'assets/images/goat.png',
  price: 13,
  income: 3,
  lifeExpectancy: 5,
  riskLevel: 0.15,
);

Asset cow = Asset(
  type: AssetType.cow,
  numberOfAnimals: 1,
  imagePath: 'assets/images/cow.png',
  price: 14,
  income: 4,
  lifeExpectancy: 4,
  riskLevel: 0.20,
);

Asset chickens = Asset(
  type: AssetType.chicken,
  numberOfAnimals: 50,
  imagePath: 'assets/images/chicken.png',
  price: 10,
  income: 2,
  lifeExpectancy: 6,
  riskLevel: 0.10,
);

List<Asset> allDefaultAssets = [goats, cow, chickens];

Asset getRandomAsset() {
  return allDefaultAssets[Random().nextInt(allDefaultAssets.length)];
}
