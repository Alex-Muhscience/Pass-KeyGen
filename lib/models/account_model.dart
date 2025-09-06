import 'dart:convert';
<<<<<<< HEAD
=======
import 'password_model.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

class AccountModel {
  final int id;
  final String accountName;
  final String email;
  final String password;
<<<<<<< HEAD
  final List<PasswordModel> passwords;
=======
  final String website;
  final String username;
  final List<PasswordModel> passwords;
  final String notes;
  final String category;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

  AccountModel({
    required this.id,
    required this.accountName,
    required this.email,
    required this.password,
<<<<<<< HEAD
    required this.passwords,
  });
=======
    required this.website,
    required this.username,
    required this.passwords,
    this.notes = '',
    this.category = 'General',
    this.isFavorite = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

  // Convert a map to an AccountModel instance
  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as int? ?? 0,
      accountName: map['accountName'] as String? ?? 'Unknown',
      email: map['email'] as String? ?? 'Unknown',
      password: map['password'] as String? ?? '',
<<<<<<< HEAD
=======
      website: map['website'] as String? ?? '',
      username: map['username'] as String? ?? '',
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
      passwords: (map['passwords'] as List<dynamic>?)
          ?.map(
              (item) => PasswordModel.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [],
<<<<<<< HEAD
=======
      notes: map['notes'] as String? ?? '',
      category: map['category'] as String? ?? 'General',
      isFavorite: map['isFavorite'] as bool? ?? false,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
    );
  }

  // Convert an AccountModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'email': email,
      'password': password,
<<<<<<< HEAD
      'passwords': passwords.map((password) => password.toMap()).toList(),
=======
      'website': website,
      'username': username,
      'passwords': passwords.map((password) => password.toMap()).toList(),
      'notes': notes,
      'category': category,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
    };
  }

  // Convert a JSON string to an AccountModel instance
  factory AccountModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return AccountModel.fromMap(json);
  }

  // Convert an AccountModel instance to a JSON string
  String toJson() {
    final Map<String, dynamic> json = toMap();
    return jsonEncode(json);
  }

  // CopyWith method for partial updates
  AccountModel copyWith({
    int? id,
    String? accountName,
    String? email,
    String? password,
<<<<<<< HEAD
    List<PasswordModel>? passwords,
=======
    String? website,
    String? username,
    List<PasswordModel>? passwords,
    String? notes,
    String? category,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  }) {
    return AccountModel(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      email: email ?? this.email,
      password: password ?? this.password,
<<<<<<< HEAD
      passwords: passwords ?? this.passwords,
=======
      website: website ?? this.website,
      username: username ?? this.username,
      passwords: passwords ?? this.passwords,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
    );
  }
}

<<<<<<< HEAD
class PasswordModel {
  final int? id;
  final String name;
  final String password;

  PasswordModel({
    this.id,
    required this.name,
    required this.password,
  });

  PasswordModel copyWith({
    int? id,
    String? name,
    String? password,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }

  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? 'Unnamed',
      password: map['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }
}
=======
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
