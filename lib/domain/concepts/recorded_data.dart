import '../utils/utils.dart';

class RecordedData {
  final int levelId;
  final List<double> cashValues;

  RecordedData({
    required this.levelId,
    required this.cashValues,
  });

  // method to copy custom class
  RecordedData copyWith({
    int? levelId,
    List<double>? cashValues,
  }) {
    return RecordedData(
      levelId: levelId ?? this.levelId,
      cashValues: cashValues ?? copyCashArray(this.cashValues),
    );
  }
}
