import '../../config/constants.dart';

class Loan {
  final double interestRate;
  final double loanAmount;
  final int termInPeriods;
  final int age;

  Loan({
    required this.interestRate,
    required this.loanAmount,
    this.termInPeriods = defaultLoanTerm,
    this.age = 0,
  });

  // method to copy custom class
  Loan copyWith({
    double? interestRate,
    double? loanAmount,
    int? termInPeriods,
    int? age,
  }) {
    return Loan(
      interestRate: interestRate ?? this.interestRate,
      loanAmount: loanAmount ?? this.loanAmount,
      termInPeriods: termInPeriods ?? this.termInPeriods,
      age: age ?? this.age,
    );
  }

  double get paymentPerPeriod {
    return loanAmount * (1 + interestRate) / termInPeriods;
  }
}

Loan loan1 = Loan(interestRate: 0.25, loanAmount: 0);
