import 'dart:convert';

class AccountModel {
  final int id;
  final String accountName;
  final String email;
  final String password;
  final List<PasswordModel> passwords;

  AccountModel({
    required this.id,
    required this.accountName,
    required this.email,
    required this.password,
    required this.passwords,
  });

  // Convert a map to an AccountModel instance
  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as int? ?? 0,
      accountName: map['accountName'] as String? ?? 'Unknown',
      email: map['email'] as String? ?? 'Unknown',
      password: map['password'] as String? ?? '',
      passwords: (map['passwords'] as List<dynamic>?)
          ?.map(
              (item) => PasswordModel.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  // Convert an AccountModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'email': email,
      'password': password,
      'passwords': passwords.map((password) => password.toMap()).toList(),
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
    List<PasswordModel>? passwords,
  }) {
    return AccountModel(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      email: email ?? this.email,
      password: password ?? this.password,
      passwords: passwords ?? this.passwords,
    );
  }
}

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
