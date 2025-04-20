import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keygen/pages/account_details_page.dart';
import 'package:keygen/pages/create_account.dart';
import 'package:keygen/pages/home_page.dart';
import 'package:keygen/pages/login_page.dart';
import 'package:keygen/pages/reset_password_page.dart';
import 'package:keygen/pages/settings_page.dart';
import 'package:keygen/pages/signup_page.dart';
import 'package:keygen/pages/update_user_info.dart';
import 'package:keygen/services/authentication_service.dart';
import 'package:keygen/services/theme_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/account_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check and request necessary permissions
  await _checkPermissions();

  final themeService = Get.put(ThemeService());
  await themeService.initializeTheme();

  final initialThemeMode = await themeService.getCurrentTheme();

  runApp(MyApp(initialThemeMode: initialThemeMode));
}

Future<void> _checkPermissions() async {
  final permissions = [
    Permission.storage,
  ];

  for (var permission in permissions) {
    if (!await permission.isGranted) {
      final status = await permission.request();
      if (!status.isGranted) {
        if (kDebugMode) {
          print('${permission.toString()} permission denied');
        }
      }
    }
  }
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: initialThemeMode,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
        GetPage(name: '/create_account', page: () => ManageAccountPage(passwords: [])),
        GetPage(
          name: '/home/:username',
          page: () {
            final username = Get.parameters['username'] ?? '';
            return FutureBuilder<List<AccountModel>>(
              future: _fetchUserAccounts(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return HomePage(
                    accounts: snapshot.data!,
                    username: username,
                  );
                } else {
                  return const Center(child: Text('No accounts found.'));
                }
              },
            );
          },
        ),
        GetPage(name: '/settings', page: () => const SettingsPage()),
        GetPage(name: '/reset_password', page: () => const ResetPasswordPage()),
        GetPage(
          name: '/update_user_info/:username',
          page: () {
            final username = Get.parameters['username'] ?? '';
            return UpdateUserInfoPage(username: username);
          },
        ),
        GetPage(
          name: '/account_details/:accountId',
          page: () {
            final accountId =
                int.tryParse(Get.parameters['accountId'] ?? '') ?? 0;
            return AccountDetailsPage(accountId: accountId);
          },
        ),
      ],
    );
  }

  Future<List<AccountModel>> _fetchUserAccounts(String username) async {
    final authService = AuthenticationService(passwords: []);
    try {
      return await authService.getAccountsForUser(username);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user accounts: $e');
      }
      return [];
    }
  }
}
