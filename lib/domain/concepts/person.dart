class Person {
  final String? firstName;
  final String? lastName;
  final String? uid;

  Person({
    this.firstName,
    this.lastName,
    this.uid,
  });

  Person copyWith({
    String? firstName,
    String? lastName,
    String? uid,
  }) {
    return Person(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      uid: uid ?? this.uid,
    );
  }

  bool exists() {
    return firstName != null && lastName != null;
  }
}
