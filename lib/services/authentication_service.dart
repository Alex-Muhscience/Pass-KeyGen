import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:keygen/services/fingerprint_authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_model.dart';

class AuthenticationService {
  final List<String> passwords; // List of passwords, required parameter
  SharedPreferences? _prefs;
  final FingerprintAuthenticationService _fingerprintAuthService =
      FingerprintAuthenticationService();

  // Constructor with required passwords parameter
  AuthenticationService({required this.passwords});

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
  }

  // Authenticate user with fingerprint
  Future<bool> authenticateWithFingerprint() async {
    await _initPrefs();
    try {
      return await _fingerprintAuthService.authenticateWithFingerprint();
    } catch (e) {
      return false;
    }
  }

  // Signup user with username, email, and password
  Future<void> signupUser(
      String username, String email, String password) async {
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
  }

  // Reset password
  Future<void> resetPassword(String username, String newPassword) async {
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
  }

  // Fetch accounts for a specific user
  Future<List<AccountModel>> getAccountsForUser(String username) async {
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
  }

  // Add new account
  Future<void> addAccount(
      String accountName, String email, String password) async {
    await _initPrefs();

    final storedUsernames = _prefs?.getStringList('usernames') ?? [];
    final storedUserPasswords = _prefs?.getStringList('userPasswords') ?? [];

    storedUsernames.add(accountName);
    storedUserPasswords.add(_hashPassword(password));

    await _prefs!.setStringList('usernames', storedUsernames);
    await _prefs!.setStringList('userPasswords', storedUserPasswords);
  }
}
