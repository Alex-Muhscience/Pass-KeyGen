<<<<<<< HEAD
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:keygen/services/fingerprint_authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_model.dart';

class AuthenticationService {
  final List<String> passwords; // List of passwords, required parameter
  SharedPreferences? _prefs;
=======
import 'fingerprint_authentication_service.dart';
import 'database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_model.dart';
import '../models/user_model.dart';

class AuthenticationService {
  final List<String> passwords; // List of passwords, required parameter
  final DatabaseHelper _databaseHelper = DatabaseHelper();
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  final FingerprintAuthenticationService _fingerprintAuthService =
      FingerprintAuthenticationService();

  // Constructor with required passwords parameter
  AuthenticationService({required this.passwords});

<<<<<<< HEAD
  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Authenticate user with username and password
  Future<bool> authenticateWithPassword(
      String username, String password) async {
    await _initPrefs();

    final hashedPassword = _hashPassword(password);
    final storedUsernames = _prefs?.getStringList('usernames') ?? [];
    final storedUserPasswords = _prefs?.getStringList('userPasswords') ?? [];

    for (int i = 0; i < storedUsernames.length; i++) {
      if (storedUsernames[i] == username &&
          storedUserPasswords[i] == hashedPassword) {
        return true;
      }
    }
    return false;
=======
  // Authenticate user with username and password
  Future<bool> authenticateWithPassword(
      String username, String password) async {
    return await _databaseHelper.authenticateUser(username, password);
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  }

  // Authenticate user with fingerprint
  Future<bool> authenticateWithFingerprint() async {
<<<<<<< HEAD
    await _initPrefs();
=======
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
    try {
      return await _fingerprintAuthService.authenticateWithFingerprint();
    } catch (e) {
      return false;
    }
  }

  // Signup user with username, email, and password
  Future<void> signupUser(
      String username, String email, String password) async {
<<<<<<< HEAD
    await _initPrefs();

    final storedUsernames = _prefs?.getStringList('usernames') ?? [];
    if (storedUsernames.contains(username)) {
      throw Exception('Username already exists');
    }

    final hashedPassword = _hashPassword(password);
    storedUsernames.add(username);
    final storedUserPasswords = _prefs?.getStringList('userPasswords') ?? [];
    storedUserPasswords.add(hashedPassword);

    await _prefs!.setStringList('usernames', storedUsernames);
    await _prefs!.setStringList('userPasswords', storedUserPasswords);
    await _prefs!.setString('email', email);
=======
    // Check if user already exists
    final existingUser = await _databaseHelper.getUser(username);
    if (existingUser != null) {
      throw Exception('Username already exists');
    }

    // Create new user
    final newUser = UserModel(
      id: 0, // Will be auto-incremented by database
      username: username,
      email: email,
      password: password,
    );

    await _databaseHelper.insertUser(newUser);
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  }

  // Reset password
  Future<void> resetPassword(String username, String newPassword) async {
<<<<<<< HEAD
    await _initPrefs();

    final hashedPassword = _hashPassword(newPassword);
    final storedUsernames = _prefs?.getStringList('usernames') ?? [];
    final storedUserPasswords = _prefs?.getStringList('userPasswords') ?? [];

    int index = storedUsernames.indexOf(username);
    if (index == -1) {
      throw Exception('Username not found');
    }

    storedUserPasswords[index] = hashedPassword;
    await _prefs!.setStringList('userPasswords', storedUserPasswords);
  }

  // Logout user and clear data
  Future<void> logout() async {
    await _initPrefs();
    await _prefs!.remove('usernames');
    await _prefs!.remove('userPasswords');
    await _prefs!.remove('email');
  }

  // Function to hash the password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
=======
    final user = await _databaseHelper.getUser(username);
    if (user == null) {
      throw Exception('Username not found');
    }

    final updatedUser = UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      password: newPassword,
    );

    await _databaseHelper.updateUser(updatedUser);
  }

  // Logout user (clear any cached data if needed)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  }

  // Fetch accounts for a specific user
  Future<List<AccountModel>> getAccountsForUser(String username) async {
<<<<<<< HEAD
    await _initPrefs();
    final storedUsernames = _prefs?.getStringList('usernames') ?? [];
    final storedUserPasswords = _prefs?.getStringList('userPasswords') ?? [];
    final List<AccountModel> accounts = [];

    for (int i = 0; i < storedUsernames.length; i++) {
      if (storedUsernames[i] == username) {
        accounts.add(AccountModel(
          id: i, // Use index as ID or adapt as needed
          accountName: storedUsernames[i],
          email: _prefs?.getString('email') ?? 'Unknown',
          password: storedUserPasswords[i],
          passwords: passwords.map((password) => PasswordModel(password: password, name: 'DefaultName')).toList(), // Convert to List<PasswordModel>
        ));
      }
    }
    return accounts;
=======
    // Return all accounts from database (you might want to filter by user if needed)
    return await _databaseHelper.getAccounts();
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  }

  // Add new account
  Future<void> addAccount(
      String accountName, String email, String password) async {
<<<<<<< HEAD
    await _initPrefs();

    final storedUsernames = _prefs?.getStringList('usernames') ?? [];
    final storedUserPasswords = _prefs?.getStringList('userPasswords') ?? [];

    storedUsernames.add(accountName);
    storedUserPasswords.add(_hashPassword(password));

    await _prefs!.setStringList('usernames', storedUsernames);
    await _prefs!.setStringList('userPasswords', storedUserPasswords);
=======
    final newAccount = AccountModel(
      id: 0, // Will be auto-incremented by database
      accountName: accountName,
      email: email,
      password: password,
      website: '',
      username: email, // Use email as default username
      passwords: [],
    );

    await _databaseHelper.insertAccount(newAccount);
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  }
}
