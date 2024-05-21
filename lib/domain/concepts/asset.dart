import '../../config/constants.dart';

class Asset {
  final AssetType type;
  final int numberOfAnimals;
  final String imagePath;
  final double price;
  final double income;
  final double riskLevel;
  final int lifeExpectancy;
  final int age;

  Asset({
    required this.type,
    required this.numberOfAnimals,
    required this.imagePath,
    required this.price,
    required this.income,
    required this.riskLevel,
    this.lifeExpectancy = defaultLifeSpan,
    this.age = 0,
  });

  // method to copy custom class
  Asset copyWith({
    AssetType? type,
    int? numberOfAnimals,
    String? imagePath,
    double? price,
    double? income,
    double? riskLevel,
    int? lifeExpectancy,
    int? age,
  }) {
    return Asset(
      type: type ?? this.type,
      numberOfAnimals: numberOfAnimals ?? this.numberOfAnimals,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      income: income ?? this.income,
      riskLevel: riskLevel ?? this.riskLevel,
      lifeExpectancy: lifeExpectancy ?? this.lifeExpectancy,
      age: age ?? this.age,
    );
  }
}

enum AssetType {
  pig,
  chicken,
  goat,
}

// extension ReturnStrings on AssetType {
//   String get name {
//     switch (this) {
//       case AssetType.cow:
//         return AppLocalizations.of(context)!.cow;
//       case AssetType.chicken:
//         return AppLocalizations.of(context)!.chicken;
//       case AssetType.goat:
//         return AppLocalizations.of(context)!.goat;
//     }
//   }
// }
