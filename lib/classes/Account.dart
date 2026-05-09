import 'package:vault/enums/categories.dart';

class Account {
  final int? id;
  final CATEGORIES icon;
  final String category;
  final String username;
  final String password;

  const Account({
    this.id,
    required this.icon,
    required this.category,
    required this.username,
    required this.password,
  });

  factory Account.fromMap(Map<String, Object?> map) {
    return Account(
      id: map['id'] as int,
      icon: CategoriesExtension.fromName(map['icon'] as String)!,
      category: map['category'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'icon': icon.name,
      'category': category,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return "id; $id, icon: $icon, category: $category, username: $username, password: $password";
  }
}
