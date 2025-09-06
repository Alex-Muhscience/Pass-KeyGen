import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdvancedEncryptionService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _masterKeyKey = 'master_key';
  static const String _saltKey = 'encryption_salt';

  /// Generate a cryptographically secure master key
  Future<String> generateMasterKey() async {
    final random = SecureRandom('Fortuna');
    final seed = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      seed[i] = Random.secure().nextInt(256);
    }
    random.seed(KeyParameter(seed));
    
    final keyBytes = Uint8List(32);
    for (int i = 0; i < keyBytes.length; i++) {
      keyBytes[i] = Random.secure().nextInt(256);
    }
    
    final masterKey = base64Encode(keyBytes);
    await _storage.write(key: _masterKeyKey, value: masterKey);
    return masterKey;
  }

  /// Derive encryption key from master password using PBKDF2
  Future<Uint8List> deriveKey(String masterPassword) async {
    String? saltString = await _storage.read(key: _saltKey);
    Uint8List salt;
    
    if (saltString == null) {
      salt = _generateSalt();
      await _storage.write(key: _saltKey, value: base64Encode(salt));
    } else {
      salt = base64Decode(saltString);
    }

    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, 100000, 32));
    
    return pbkdf2.process(Uint8List.fromList(utf8.encode(masterPassword)));
  }

  /// Encrypt data using AES-256-GCM
  Future<String> encryptData(String plaintext, String masterPassword) async {
    try {
      final key = await deriveKey(masterPassword);
      final cipher = GCMBlockCipher(AESEngine());
      
      // Generate random IV
      final iv = _generateRandomBytes(12);
      final keyParam = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
      
      cipher.init(true, keyParam);
      
      final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
      final ciphertext = cipher.process(plaintextBytes);
      
      // Combine IV + ciphertext
      final result = Uint8List(iv.length + ciphertext.length);
      result.setRange(0, iv.length, iv);
      result.setRange(iv.length, result.length, ciphertext);
      
      return base64Encode(result);
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt data using AES-256-GCM
  Future<String> decryptData(String encryptedData, String masterPassword) async {
    try {
      final key = await deriveKey(masterPassword);
      final cipher = GCMBlockCipher(AESEngine());
      
      final encryptedBytes = base64Decode(encryptedData);
      
      // Extract IV and ciphertext
      final iv = encryptedBytes.sublist(0, 12);
      final ciphertext = encryptedBytes.sublist(12);
      
      final keyParam = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
      cipher.init(false, keyParam);
      
      final decrypted = cipher.process(ciphertext);
      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Generate cryptographically secure random bytes
  Uint8List _generateRandomBytes(int length) {
    final random = SecureRandom('Fortuna');
    final seed = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      seed[i] = Random.secure().nextInt(256);
    }
    random.seed(KeyParameter(seed));
    
    final bytes = Uint8List(length);
    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = Random.secure().nextInt(256);
    }
    return bytes;
  }

  /// Generate salt for key derivation
  Uint8List _generateSalt() {
    return _generateRandomBytes(32);
  }

  /// Verify master password
  Future<bool> verifyMasterPassword(String password) async {
    try {
      const testData = 'verification_test';
      final encrypted = await encryptData(testData, password);
      final decrypted = await decryptData(encrypted, password);
      return decrypted == testData;
    } catch (e) {
      return false;
    }
  }

  /// Change master password
  Future<void> changeMasterPassword(String oldPassword, String newPassword, List<String> encryptedData) async {
    // Decrypt all data with old password
    final decryptedData = <String>[];
    for (final data in encryptedData) {
      decryptedData.add(await decryptData(data, oldPassword));
    }

    // Generate new salt for new password
    await _storage.delete(key: _saltKey);
    
    // Re-encrypt all data with new password
    final reencryptedData = <String>[];
    for (final data in decryptedData) {
      reencryptedData.add(await encryptData(data, newPassword));
    }
  }

  /// Secure memory cleanup
  void secureCleanup(List<Uint8List> sensitiveData) {
    for (final data in sensitiveData) {
      data.fillRange(0, data.length, 0);
    }
  }
}
