import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pass_keygen/pages/home_page.dart';
import 'package:pass_keygen/pages/login_page.dart';
import 'package:pass_keygen/pages/signup_page.dart';
import 'package:pass_keygen/pages/account_details_page.dart';
import 'package:pass_keygen/pages/create_account.dart';
import 'package:pass_keygen/pages/settings_page.dart';
import 'package:pass_keygen/pages/security_dashboard_page.dart';
import 'package:pass_keygen/pages/password_generator_page.dart';
import 'package:pass_keygen/pages/two_factor_setup_page.dart';
import 'package:pass_keygen/pages/import_export_page.dart';
import 'package:pass_keygen/pages/reset_password_page.dart';
import 'package:pass_keygen/pages/update_user_info.dart';
import 'package:pass_keygen/pages/language_selection_page.dart';
import 'package:pass_keygen/pages/family_sharing_page.dart';
import 'package:pass_keygen/pages/autofill_page.dart';
import 'package:pass_keygen/pages/help_support_page.dart';
import 'package:pass_keygen/pages/onboarding_page.dart';
import 'package:pass_keygen/services/theme_service.dart';
import 'package:pass_keygen/services/language_service.dart';
import 'package:pass_keygen/l10n/generated/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/account_model.dart';
import 'services/authentication_service.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check and request necessary permissions
  await _checkPermissions();

<<<<<<< HEAD
  final themeService = Get.put(ThemeService());
  await themeService.initializeTheme();

  final initialThemeMode = await themeService.getCurrentTheme();

  runApp(MyApp(initialThemeMode: initialThemeMode));
=======
  // Initialize services
  final themeService = Get.put(ThemeService());
  await themeService.initializeTheme();
  await LanguageService.initialize();

  final initialThemeMode = await themeService.getCurrentTheme();
  final initialLocale = await LanguageService.getCurrentLocale();

  runApp(MyApp(
    initialThemeMode: initialThemeMode,
    initialLocale: initialLocale,
  ));
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD

  const MyApp({super.key, required this.initialThemeMode});
=======
  final Locale initialLocale;

  const MyApp({
    super.key, 
    required this.initialThemeMode,
    required this.initialLocale,
  });
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
<<<<<<< HEAD
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: initialThemeMode,
=======
      title: 'SecureVault',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade800),
          ),
        ),
      ),
      themeMode: initialThemeMode,
      locale: initialLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageService.getSupportedLocales(),
      fallbackLocale: const Locale('en'),
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
<<<<<<< HEAD
        GetPage(name: '/create_account', page: () => ManageAccountPage(passwords: [])),
        GetPage(
          name: '/home/:username',
=======
        GetPage(name: '/create_account', page: () => const ManageAccountPage(passwords: [])),
        GetPage(
          name: '/home',
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD
=======
        GetPage(name: '/security_dashboard', page: () => const SecurityDashboardPage()),
        GetPage(name: '/password_generator', page: () => const PasswordGeneratorPage()),
        GetPage(name: '/two_factor_setup', page: () => const TwoFactorSetupPage()),
        GetPage(name: '/import_export', page: () => const ImportExportPage()),
        GetPage(name: '/language_selection', page: () => const LanguageSelectionPage()),
        GetPage(name: '/family_sharing', page: () => const FamilySharingPage()),
        GetPage(name: '/autofill', page: () => const AutofillPage()),
        GetPage(name: '/help_support', page: () => const HelpSupportPage()),
        GetPage(name: '/onboarding', page: () => const OnboardingPage()),
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
