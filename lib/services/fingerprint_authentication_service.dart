import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintAuthenticationService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticateWithFingerprint() async {
    // Check if biometric authentication is available
    final bool canAuthenticate = await _localAuth.canCheckBiometrics;
    if (!canAuthenticate) {
      if (kDebugMode) {
        print('Device does not support biometric authentication.');
      }
      return false;
    }

    try {
      // Attempt to authenticate with biometrics
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error using fingerprint authentication: ${e.toString()}');
      }
      return false;
    }
  }
}
