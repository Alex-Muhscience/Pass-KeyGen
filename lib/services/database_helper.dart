import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/account_model.dart';
import '../models/user_model.dart';
//import '../models/password_model.dart'; // Import your PasswordModel

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'password_manager.db');

    return openDatabase(
      path,
      version: 3, // Increment version for schema changes
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE accounts(id INTEGER PRIMARY KEY AUTOINCREMENT, accountName TEXT UNIQUE, email TEXT, password TEXT)",
        );
        db.execute(
          "CREATE TABLE passwords(id INTEGER PRIMARY KEY AUTOINCREMENT, accountId INTEGER, name TEXT, password TEXT, FOREIGN KEY(accountId) REFERENCES accounts(id) ON DELETE CASCADE)",
        );
        db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, email TEXT, password TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 3) {
          // Perform schema upgrades if needed
        }
      },
    );
  }

  // Hash the password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Placeholder function for decrypting passwords
  String _decryptPassword(String encryptedPassword) {
    // Implement your actual decryption logic here
    return encryptedPassword; // Placeholder
  }

  // Account Management
  Future<void> insertAccount(AccountModel accountModel) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(accountModel.password);
      await db.insert(
        'accounts',
        {
          'accountName': accountModel.accountName,
          'email': accountModel.email,
          'password': hashedPassword,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting account: $e');
      }
    }
  }

  Future<AccountModel?> getAccount(String accountName) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'accounts',
        where: 'accountName = ?',
        whereArgs: [accountName],
      );
      if (maps.isNotEmpty) {
        return AccountModel.fromMap(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting account: $e');
      }
      return null;
    }
  }

  Future<void> updateAccount(AccountModel accountModel) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(accountModel.password);
      await db.update(
        'accounts',
        {
          'accountName': accountModel.accountName,
          'email': accountModel.email,
          'password': hashedPassword,
        },
        where: 'id = ?',
        whereArgs: [accountModel.id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating account: $e');
      }
    }
  }

  Future<void> deleteAccount(int id) async {
    try {
      final db = await database;
      await db.delete(
        'accounts',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting account: $e');
      }
    }
  }

  Future<List<AccountModel>> getAccounts() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('accounts');
      return List.generate(maps.length, (i) {
        return AccountModel.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting accounts: $e');
      }
      return [];
    }
  }

  // Password Management
  Future<List<PasswordModel>> getPasswordsForAccount(int accountId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'passwords',
        where: 'accountId = ?',
        whereArgs: [accountId],
      );
      return List.generate(maps.length, (i) {
        return PasswordModel.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting passwords: $e');
      }
      return [];
    }
  }

  Future<void> insertPassword(PasswordModel passwordModel) async {
    try {
      final db = await database;
      await db.insert(
        'passwords',
        passwordModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting password: $e');
      }
    }
  }

  Future<void> updatePassword(PasswordModel passwordModel) async {
    try {
      final db = await database;
      await db.update(
        'passwords',
        passwordModel.toMap(),
        where: 'id = ?',
        whereArgs: [passwordModel.id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating password: $e');
      }
    }
  }

  Future<void> deletePassword(int id) async {
    try {
      final db = await database;
      await db.delete(
        'passwords',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting password: $e');
      }
    }
  }

  // User Management
  Future<void> insertUser(UserModel userModel) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(userModel.password);
      await db.insert(
        'users',
        {
          'username': userModel.username,
          'email': userModel.email,
          'password': hashedPassword,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting user: $e');
      }
    }
  }

  Future<bool> authenticateUser(String username, String password) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, hashedPassword],
      );
      return maps.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error authenticating user: $e');
      }
      return false;
    }
  }

  Future<UserModel?> getUser(String username) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );
      if (maps.isNotEmpty) {
        return UserModel.fromMap(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
      return null;
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(userModel.password);
      await db.update(
        'users',
        {
          'username': userModel.username,
          'email': userModel.email,
          'password': hashedPassword,
        },
        where: 'id = ?',
        whereArgs: [userModel.id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final db = await database;
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
    }
  }
}
