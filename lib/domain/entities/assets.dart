import '../concepts/asset.dart';

Asset goats = Asset(
  type: AssetType.goat,
  numberOfAnimals: 3,
  imagePath: 'assets/images/goat.png',
  price: 10,
  income: 3,
  riskLevel: 0.35,
);

Asset cow = Asset(
  type: AssetType.cow,
  numberOfAnimals: 1,
  imagePath: 'assets/images/cow.png',
  price: 10,
  income: 4,
  riskLevel: 0.45,
);

Asset chickens = Asset(
  type: AssetType.chicken,
  numberOfAnimals: 50,
  imagePath: 'assets/images/chicken.png',
  price: 10,
  income: 2,
  riskLevel: 0.25,
);
//
// List<Asset> assets = [
//   goats,
//   cow,
//   chickens,
//   cow,
//   goats,
// ];
