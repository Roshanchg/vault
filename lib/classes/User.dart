import 'dart:core';

class User {
  final int id = 0;
  final String pin;

  const User({required this.pin});

  factory User.fromMap(Map<String, Object?> map) {
    return User(pin: map['pin'] as String);
  }

  Map<String, Object> toMap() {
    return {'id': 0, 'pin': pin};
  }

  @override
  String toString() {
    return "PIN: $pin";
  }
}
