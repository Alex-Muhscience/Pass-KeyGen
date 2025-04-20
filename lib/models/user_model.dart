class UserModel {
  final int id; // Auto-incremented primary key
  final String username;
  final String email;
  final String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int? ?? 0, // Default to 0 if null
      username: map['username'] as String? ?? 'Unknown', // Default value
      email: map['email'] as String? ?? 'Unknown', // Default value
      password: map['password'] as String? ?? '', // Default value
    );
  }
}
