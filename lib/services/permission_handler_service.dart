import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PermissionHandlerPage extends StatefulWidget {
  const PermissionHandlerPage({super.key});

  @override
<<<<<<< HEAD
  _PermissionHandlerPageState createState() => _PermissionHandlerPageState();
}

class _PermissionHandlerPageState extends State<PermissionHandlerPage> {
=======
  PermissionHandlerPageState createState() => PermissionHandlerPageState();
}

class PermissionHandlerPageState extends State<PermissionHandlerPage> {
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check and request storage permissions
    final storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        if (kDebugMode) {
          print('Storage permission granted');
        }
      } else {
        if (kDebugMode) {
          print('Storage permission denied');
        }
      }
    }

    // Check and request biometric authentication availability
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      final biometricStatus = await _auth.getAvailableBiometrics();
      if (kDebugMode) {
        print('Available biometrics: $biometricStatus');
      }
    } else {
      if (kDebugMode) {
        print('Biometrics are not available');
      }
    }

    // Note: Internet access does not require runtime permission
    // Note: Accessibility services cannot be requested programmatically
  }

  Future<void> _openAccessibilitySettings() async {
    const url = 'android.settings.ACCESSIBILITY_SETTINGS';
<<<<<<< HEAD
    if (await canLaunch(url)) {
      await launch(url);
=======
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
    } else {
      if (kDebugMode) {
        print('Could not open accessibility settings');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Handler'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _checkPermissions,
              child: const Text('Check/Request Permissions'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openAccessibilitySettings,
              child: const Text('Open Accessibility Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
