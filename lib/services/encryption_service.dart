import 'package:encrypt/encrypt.dart' as encrypt;
<<<<<<< HEAD
import 'package:keygen/services/database_helper.dart';
=======
import '/services/database_helper.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

class EncryptionHelper {
  // Secure key management is important. This example uses a static key for simplicity.
  final encrypt.Key _key;
  final encrypt.IV _iv;

  // Database helper instance
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Constructor with optional key and IV parameters
  EncryptionHelper({
    encrypt.Key? key,
    encrypt.IV? iv,
  })  : _key = key ?? encrypt.Key.fromLength(32), // 32 bytes = 256 bits
        _iv = iv ?? encrypt.IV.fromLength(16); // 16 bytes = 128 bits

  // Encrypts the password using AES encryption
  String encryptPassword(String password) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      return encrypter.encrypt(password, iv: _iv).base64;
    } catch (e) {
      // Handle encryption errors
      throw Exception('Error encrypting password: $e');
    }
  }

  // Decrypts the encrypted password using AES decryption
  String decryptPassword(String encryptedPassword) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      return encrypter.decrypt64(encryptedPassword, iv: _iv);
    } catch (e) {
      // Handle decryption errors
      throw Exception('Error decrypting password: $e');
    }
  }

  Future<List<String>> getPasswords() async {
    try {
      // Get all accounts from the database
      final accounts = await _dbHelper.getAccounts();
      
      // Decrypt each password and return as a list
      return accounts.map((account) => 
        decryptPassword(account.password)
      ).toList();
    } catch (e) {
      // Handle any errors during password retrieval
      throw Exception('Error retrieving passwords: $e');
    }
  }
}
