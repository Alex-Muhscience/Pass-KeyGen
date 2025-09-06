import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:otp/otp.dart' as otp;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

class TwoFactorAuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static const String _secretKey = '2fa_secret';
  static const String _backupCodesKey = '2fa_backup_codes';
  static const String _isEnabledKey = '2fa_enabled';

  /// Generate a new 2FA secret key
  Future<String> generateSecret() async {
    final random = SecureRandom('Fortuna');
    final seed = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      seed[i] = Random.secure().nextInt(256);
    }
    random.seed(KeyParameter(seed));

    final secretBytes = Uint8List(20);
    for (int i = 0; i < secretBytes.length; i++) {
      secretBytes[i] = Random.secure().nextInt(256);
    }
    
    final secret = base32Encode(secretBytes);
    await _storage.write(key: _secretKey, value: secret);
    return secret;
  }

  /// Get current 2FA secret
  Future<String?> getSecret() async {
    return await _storage.read(key: _secretKey);
  }

  /// Generate QR code data for authenticator apps
  Future<String> generateQRCodeData({
    required String accountName,
    required String issuer,
    String? secret,
  }) async {
    secret ??= await getSecret();
    if (secret == null) {
      throw Exception('No 2FA secret found');
    }

    final uri = 'otpauth://totp/$issuer:$accountName?secret=$secret&issuer=$issuer&algorithm=SHA1&digits=6&period=30';
    return uri;
  }

  /// Generate QR code widget
  Future<Widget> generateQRCodeWidget({
    required String accountName,
    required String issuer,
    double size = 200.0,
  }) async {
    final qrData = await generateQRCodeData(
      accountName: accountName,
      issuer: issuer,
    );

    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.white,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
    );
  }

  /// Verify TOTP code
  Future<bool> verifyTOTP(String code) async {
    final secret = await getSecret();
    if (secret == null) return false;

    try {
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      // Check current time window and adjacent windows for clock drift
      for (int i = -1; i <= 1; i++) {
        final timeWindow = (currentTime ~/ 30) + i;
        final expectedCode = otp.OTP.generateTOTPCodeString(
          secret,
          timeWindow * 30 * 1000,
          length: 6,
          interval: 30,
          algorithm: otp.Algorithm.SHA1,
        );
        
        if (code == expectedCode) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Generate backup codes
  Future<List<String>> generateBackupCodes() async {
    final random = Random.secure();
    final seed = Uint8List(10);
    for (int i = 0; i < 10; i++) {
      seed[i] = random.nextInt(256);
    }

    final backupCodes = <String>[];
    for (int i = 0; i < 10; i++) {
      final code = StringBuffer();
      for (int j = 0; j < 8; j++) {
        code.write(random.nextInt(10));
      }
      backupCodes.add(code.toString());
    }

    await _storage.write(key: _backupCodesKey, value: jsonEncode(backupCodes));
    return backupCodes;
  }

  /// Get backup codes
  Future<List<String>> getBackupCodes() async {
    final codesJson = await _storage.read(key: _backupCodesKey);
    if (codesJson == null) return [];
    
    try {
      final List<dynamic> codesList = jsonDecode(codesJson);
      return codesList.cast<String>();
    } catch (e) {
      return [];
    }
  }

  /// Verify backup code and remove it after use
  Future<bool> verifyBackupCode(String code) async {
    final backupCodes = await getBackupCodes();
    
    if (backupCodes.contains(code)) {
      backupCodes.remove(code);
      await _storage.write(key: _backupCodesKey, value: jsonEncode(backupCodes));
      return true;
    }
    return false;
  }

  /// Enable 2FA
  Future<void> enable2FA() async {
    await _storage.write(key: _isEnabledKey, value: 'true');
  }

  /// Disable 2FA
  Future<void> disable2FA() async {
    await _storage.delete(key: _secretKey);
    await _storage.delete(key: _backupCodesKey);
    await _storage.delete(key: _isEnabledKey);
  }

  /// Check if 2FA is enabled
  Future<bool> is2FAEnabled() async {
    final enabled = await _storage.read(key: _isEnabledKey);
    return enabled == 'true';
  }

  /// Verify any 2FA method (TOTP or backup code)
  Future<bool> verifyAny2FA(String code) async {
    if (!await is2FAEnabled()) return true;
    
    // Try TOTP first
    if (await verifyTOTP(code)) return true;
    
    // Try backup code
    return await verifyBackupCode(code);
  }

  /// Base32 encoding for secret keys
  String base32Encode(Uint8List bytes) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    String result = '';
    int buffer = 0;
    int bitsLeft = 0;

    for (int byte in bytes) {
      buffer = (buffer << 8) | byte;
      bitsLeft += 8;

      while (bitsLeft >= 5) {
        result += alphabet[(buffer >> (bitsLeft - 5)) & 31];
        bitsLeft -= 5;
      }
    }

    if (bitsLeft > 0) {
      result += alphabet[(buffer << (5 - bitsLeft)) & 31];
    }

    return result;
  }

  /// Get current TOTP code for display
  Future<String?> getCurrentTOTP() async {
    final secret = await getSecret();
    if (secret == null) return null;

    try {
      final totp = otp.OTP.generateTOTPCodeString(
        secret,
        DateTime.now().millisecondsSinceEpoch,
        length: 6,
        interval: 30,
        algorithm: otp.Algorithm.SHA1,
        isGoogle: true,
      );
      return totp;
    } catch (e) {
      return null;
    }
  }

  /// Get time remaining for current TOTP
  int getTOTPTimeRemaining() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return 30 - (now % 30);
  }
}
