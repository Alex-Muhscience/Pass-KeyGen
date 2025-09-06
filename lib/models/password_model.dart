class PasswordModel {
  final int? id;
  final int? accountId;
  final String name;
  final String password;

  PasswordModel({
    this.id,
    this.accountId,
    required this.name,
    required this.password,
  });

  // Convert PasswordModel to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'name': name,
      'password': password,
    };
  }

  // Create PasswordModel from Map (database result)
  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      id: map['id'] as int?,
      accountId: map['accountId'] as int?,
      name: map['name'] as String? ?? 'Unnamed',
      password: map['password'] as String? ?? '',
    );
  }

  // Create a copy of PasswordModel with updated fields
  PasswordModel copyWith({
    int? id,
    int? accountId,
    String? name,
    String? password,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'PasswordModel{id: $id, accountId: $accountId, name: $name, password: [HIDDEN]}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordModel &&
        other.id == id &&
        other.accountId == accountId &&
        other.name == name &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        accountId.hashCode ^
        name.hashCode ^
        password.hashCode;
  }
}
