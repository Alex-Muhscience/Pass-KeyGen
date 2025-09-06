import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'SecureVault'**
  String get appName;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your secure vault'**
  String get loginSubtitle;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign up page title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpTitle;

  /// Sign up page subtitle
  ///
  /// In en, this message translates to:
  /// **'Join SecureVault to protect your passwords'**
  String get signUpSubtitle;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Biometric login button text
  ///
  /// In en, this message translates to:
  /// **'Use Biometric'**
  String get biometricLogin;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Accounts section title
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// Add account button text
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// Account name field label
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// Website field label
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// Notes field label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Generate button text
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Security section title
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Security dashboard title
  ///
  /// In en, this message translates to:
  /// **'Security Dashboard'**
  String get securityDashboard;

  /// Security dashboard subtitle
  ///
  /// In en, this message translates to:
  /// **'View security audit and recommendations'**
  String get securityDashboardSubtitle;

  /// Security score label
  ///
  /// In en, this message translates to:
  /// **'Security Score'**
  String get securityScore;

  /// Excellent security score description
  ///
  /// In en, this message translates to:
  /// **'Excellent security'**
  String get excellentSecurity;

  /// Good security score description
  ///
  /// In en, this message translates to:
  /// **'Good security'**
  String get goodSecurity;

  /// Fair security score description
  ///
  /// In en, this message translates to:
  /// **'Fair security'**
  String get fairSecurity;

  /// Poor security score description
  ///
  /// In en, this message translates to:
  /// **'Poor security'**
  String get poorSecurity;

  /// Critical security issues description
  ///
  /// In en, this message translates to:
  /// **'Critical security issues'**
  String get criticalSecurityIssues;

  /// Total accounts label
  ///
  /// In en, this message translates to:
  /// **'Total Accounts'**
  String get totalAccounts;

  /// Issues found label
  ///
  /// In en, this message translates to:
  /// **'Issues Found'**
  String get issuesFound;

  /// Strong passwords label
  ///
  /// In en, this message translates to:
  /// **'Strong Passwords'**
  String get strongPasswords;

  /// Risk breakdown title
  ///
  /// In en, this message translates to:
  /// **'Risk Breakdown'**
  String get riskBreakdown;

  /// Critical risk level
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// High risk level
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Medium risk level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Low risk level
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Security issues title
  ///
  /// In en, this message translates to:
  /// **'Security Issues'**
  String get securityIssues;

  /// All clear message
  ///
  /// In en, this message translates to:
  /// **'All Clear!'**
  String get allClear;

  /// No security issues message
  ///
  /// In en, this message translates to:
  /// **'No security issues detected'**
  String get noSecurityIssues;

  /// View all issues button text
  ///
  /// In en, this message translates to:
  /// **'View All {count} Issues'**
  String viewAllIssues(int count);

  /// Password generator title
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get passwordGenerator;

  /// Password generator subtitle
  ///
  /// In en, this message translates to:
  /// **'Generate secure passwords'**
  String get passwordGeneratorSubtitle;

  /// Generated password label
  ///
  /// In en, this message translates to:
  /// **'Generated Password'**
  String get generatedPassword;

  /// Generated passphrase label
  ///
  /// In en, this message translates to:
  /// **'Generated Passphrase'**
  String get generatedPassphrase;

  /// Passphrase option
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get passphrase;

  /// Password analysis title
  ///
  /// In en, this message translates to:
  /// **'Password Analysis'**
  String get passwordAnalysis;

  /// Password strength label
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// Password score label
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Password entropy label
  ///
  /// In en, this message translates to:
  /// **'Entropy'**
  String get entropy;

  /// Password suggestions title
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// Alternative password options title
  ///
  /// In en, this message translates to:
  /// **'Alternative Options'**
  String get alternativeOptions;

  /// Password settings title
  ///
  /// In en, this message translates to:
  /// **'Password Settings'**
  String get passwordSettings;

  /// Passphrase settings title
  ///
  /// In en, this message translates to:
  /// **'Passphrase Settings'**
  String get passphraseSettings;

  /// Password length label
  ///
  /// In en, this message translates to:
  /// **'Length: {length}'**
  String length(int length);

  /// Word count label
  ///
  /// In en, this message translates to:
  /// **'Word Count: {count}'**
  String wordCount(int count);

  /// Separator label
  ///
  /// In en, this message translates to:
  /// **'Separator'**
  String get separator;

  /// Space separator option
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get space;

  /// Include uppercase option
  ///
  /// In en, this message translates to:
  /// **'Uppercase (A-Z)'**
  String get includeUppercase;

  /// Include lowercase option
  ///
  /// In en, this message translates to:
  /// **'Lowercase (a-z)'**
  String get includeLowercase;

  /// Include numbers option
  ///
  /// In en, this message translates to:
  /// **'Numbers (0-9)'**
  String get includeNumbers;

  /// Include symbols option
  ///
  /// In en, this message translates to:
  /// **'Symbols (!@#\$)'**
  String get includeSymbols;

  /// Include numbers in passphrase option
  ///
  /// In en, this message translates to:
  /// **'Include Numbers'**
  String get includeNumbersInPassphrase;

  /// Capitalize words option
  ///
  /// In en, this message translates to:
  /// **'Capitalize Words'**
  String get capitalizeWords;

  /// Advanced options title
  ///
  /// In en, this message translates to:
  /// **'Advanced Options'**
  String get advancedOptions;

  /// Exclude similar characters option
  ///
  /// In en, this message translates to:
  /// **'Exclude Similar (il1Lo0O)'**
  String get excludeSimilar;

  /// Exclude ambiguous characters option
  ///
  /// In en, this message translates to:
  /// **'Exclude Ambiguous Characters'**
  String get excludeAmbiguous;

  /// Two-factor authentication title
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthentication;

  /// Two-factor authentication subtitle
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get twoFactorAuthSubtitle;

  /// Secure your account title
  ///
  /// In en, this message translates to:
  /// **'Secure Your Account'**
  String get secureYourAccount;

  /// Two-factor authentication description
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication adds an extra layer of security to your account by requiring a verification code from your phone.'**
  String get twoFactorDescription;

  /// Enhanced security feature
  ///
  /// In en, this message translates to:
  /// **'Enhanced Security'**
  String get enhancedSecurity;

  /// Enhanced security description
  ///
  /// In en, this message translates to:
  /// **'Protect against unauthorized access'**
  String get enhancedSecurityDesc;

  /// Mobile app support feature
  ///
  /// In en, this message translates to:
  /// **'Mobile App Support'**
  String get mobileAppSupport;

  /// Mobile app support description
  ///
  /// In en, this message translates to:
  /// **'Works with Google Authenticator, Authy, and more'**
  String get mobileAppSupportDesc;

  /// Backup codes feature
  ///
  /// In en, this message translates to:
  /// **'Backup Codes'**
  String get backupCodes;

  /// Backup codes description
  ///
  /// In en, this message translates to:
  /// **'Recovery codes in case you lose your device'**
  String get backupCodesDesc;

  /// Enable 2FA button text
  ///
  /// In en, this message translates to:
  /// **'Enable 2FA'**
  String get enable2FA;

  /// Scan QR code title
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// Scan QR code description
  ///
  /// In en, this message translates to:
  /// **'Use your authenticator app to scan this QR code'**
  String get scanQRCodeDesc;

  /// Manual entry code title
  ///
  /// In en, this message translates to:
  /// **'Manual Entry Code'**
  String get manualEntryCode;

  /// Verification code field label
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// Enter 6-digit code hint
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get enterSixDigitCode;

  /// Verify and enable button text
  ///
  /// In en, this message translates to:
  /// **'Verify & Enable'**
  String get verifyAndEnable;

  /// 2FA enabled successfully message
  ///
  /// In en, this message translates to:
  /// **'2FA Enabled Successfully!'**
  String get twoFAEnabledSuccessfully;

  /// Save backup codes instruction
  ///
  /// In en, this message translates to:
  /// **'Save these backup codes in a secure location. You can use them to access your account if you lose your authenticator device.'**
  String get saveBackupCodes;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// 2FA enabled status
  ///
  /// In en, this message translates to:
  /// **'2FA Enabled'**
  String get twoFAEnabled;

  /// Account protected message
  ///
  /// In en, this message translates to:
  /// **'Your account is protected with two-factor authentication'**
  String get accountProtected;

  /// Regenerate button text
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// Backup codes remaining message
  ///
  /// In en, this message translates to:
  /// **'You have {count} backup codes remaining'**
  String backupCodesRemaining(int count);

  /// View codes button text
  ///
  /// In en, this message translates to:
  /// **'View Codes'**
  String get viewCodes;

  /// Regenerate backup codes option
  ///
  /// In en, this message translates to:
  /// **'Regenerate Backup Codes'**
  String get regenerateBackupCodes;

  /// Generate new backup codes description
  ///
  /// In en, this message translates to:
  /// **'Generate new backup codes'**
  String get generateNewBackupCodes;

  /// Reset 2FA option
  ///
  /// In en, this message translates to:
  /// **'Reset 2FA'**
  String get reset2FA;

  /// Generate new secret key description
  ///
  /// In en, this message translates to:
  /// **'Generate new secret key'**
  String get generateNewSecretKey;

  /// Disable 2FA option
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA'**
  String get disable2FA;

  /// Turn off 2FA description
  ///
  /// In en, this message translates to:
  /// **'Turn off two-factor authentication'**
  String get turnOff2FA;

  /// Copy all codes button text
  ///
  /// In en, this message translates to:
  /// **'Copy All Codes'**
  String get copyAllCodes;

  /// Import & Export title
  ///
  /// In en, this message translates to:
  /// **'Import & Export'**
  String get importExport;

  /// Import tab
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// Export tab
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Import passwords title
  ///
  /// In en, this message translates to:
  /// **'Import Passwords'**
  String get importPasswords;

  /// Import passwords description
  ///
  /// In en, this message translates to:
  /// **'Import your passwords from other password managers'**
  String get importPasswordsDesc;

  /// Export passwords title
  ///
  /// In en, this message translates to:
  /// **'Export Passwords'**
  String get exportPasswords;

  /// Export passwords description
  ///
  /// In en, this message translates to:
  /// **'Create a backup or migrate to another password manager'**
  String get exportPasswordsDesc;

  /// Export data warning
  ///
  /// In en, this message translates to:
  /// **'Make sure to export your data from the other password manager first'**
  String get exportDataWarning;

  /// Sensitive data warning
  ///
  /// In en, this message translates to:
  /// **'Exported files contain sensitive data. Store them securely and delete after use.'**
  String get sensitiveDataWarning;

  /// Choose import source title
  ///
  /// In en, this message translates to:
  /// **'Choose Import Source'**
  String get chooseImportSource;

  /// Choose export format title
  ///
  /// In en, this message translates to:
  /// **'Choose Export Format'**
  String get chooseExportFormat;

  /// Chrome browser
  ///
  /// In en, this message translates to:
  /// **'Chrome'**
  String get chrome;

  /// Chrome import description
  ///
  /// In en, this message translates to:
  /// **'Import from Chrome password export (CSV)'**
  String get chromeImportDesc;

  /// Firefox browser
  ///
  /// In en, this message translates to:
  /// **'Firefox'**
  String get firefox;

  /// Firefox import description
  ///
  /// In en, this message translates to:
  /// **'Import from Firefox password export (CSV)'**
  String get firefoxImportDesc;

  /// Safari browser
  ///
  /// In en, this message translates to:
  /// **'Safari'**
  String get safari;

  /// Safari import description
  ///
  /// In en, this message translates to:
  /// **'Import from Safari password export (CSV)'**
  String get safariImportDesc;

  /// Bitwarden password manager
  ///
  /// In en, this message translates to:
  /// **'Bitwarden'**
  String get bitwarden;

  /// Bitwarden import description
  ///
  /// In en, this message translates to:
  /// **'Import from Bitwarden vault export (JSON)'**
  String get bitwardenImportDesc;

  /// LastPass password manager
  ///
  /// In en, this message translates to:
  /// **'LastPass'**
  String get lastpass;

  /// LastPass import description
  ///
  /// In en, this message translates to:
  /// **'Import from LastPass vault export (CSV)'**
  String get lastpassImportDesc;

  /// 1Password password manager
  ///
  /// In en, this message translates to:
  /// **'1Password'**
  String get onepassword;

  /// 1Password import description
  ///
  /// In en, this message translates to:
  /// **'Import from 1Password export (CSV)'**
  String get onepasswordImportDesc;

  /// Generic CSV format
  ///
  /// In en, this message translates to:
  /// **'Generic CSV'**
  String get genericCSV;

  /// Generic CSV description
  ///
  /// In en, this message translates to:
  /// **'Import from any CSV file'**
  String get genericCSVDesc;

  /// JSON file format
  ///
  /// In en, this message translates to:
  /// **'JSON File'**
  String get jsonFile;

  /// JSON file description
  ///
  /// In en, this message translates to:
  /// **'Import from JSON file'**
  String get jsonFileDesc;

  /// Encrypted export format
  ///
  /// In en, this message translates to:
  /// **'Encrypted Export'**
  String get encryptedExport;

  /// Encrypted export description
  ///
  /// In en, this message translates to:
  /// **'Secure export with password protection (Recommended)'**
  String get encryptedExportDesc;

  /// CSV export format
  ///
  /// In en, this message translates to:
  /// **'CSV Export'**
  String get csvExport;

  /// CSV export description
  ///
  /// In en, this message translates to:
  /// **'Compatible with most password managers'**
  String get csvExportDesc;

  /// JSON export format
  ///
  /// In en, this message translates to:
  /// **'JSON Export'**
  String get jsonExport;

  /// JSON export description
  ///
  /// In en, this message translates to:
  /// **'Structured data format with metadata'**
  String get jsonExportDesc;

  /// Secure label
  ///
  /// In en, this message translates to:
  /// **'SECURE'**
  String get secure;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// Cloud sync option
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// Cloud sync description
  ///
  /// In en, this message translates to:
  /// **'Sync data across devices'**
  String get cloudSyncDesc;

  /// Privacy policy option
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy description
  ///
  /// In en, this message translates to:
  /// **'View our privacy policy'**
  String get privacyPolicyDesc;

  /// Data usage option
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// Data usage description
  ///
  /// In en, this message translates to:
  /// **'See how your data is used'**
  String get dataUsageDesc;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Theme option
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Compact view option
  ///
  /// In en, this message translates to:
  /// **'Compact View'**
  String get compactView;

  /// Compact view description
  ///
  /// In en, this message translates to:
  /// **'Show more items on screen'**
  String get compactViewDesc;

  /// Show passwords option
  ///
  /// In en, this message translates to:
  /// **'Show Passwords'**
  String get showPasswords;

  /// Show passwords description
  ///
  /// In en, this message translates to:
  /// **'Display passwords by default'**
  String get showPasswordsDesc;

  /// Data management section title
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// Import & Export description
  ///
  /// In en, this message translates to:
  /// **'Import from other password managers'**
  String get importExportDesc;

  /// Backup & Restore option
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// Backup & Restore description
  ///
  /// In en, this message translates to:
  /// **'Create and restore backups'**
  String get backupRestoreDesc;

  /// Clear cache option
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// Clear cache description
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get clearCacheDesc;

  /// Reset app option
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetApp;

  /// Reset app description
  ///
  /// In en, this message translates to:
  /// **'Delete all data and reset'**
  String get resetAppDesc;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Help & Support option
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Help & Support description
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get helpSupportDesc;

  /// Rate app option
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// Rate app description
  ///
  /// In en, this message translates to:
  /// **'Rate SecureVault on the app store'**
  String get rateAppDesc;

  /// Terms of service option
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service description
  ///
  /// In en, this message translates to:
  /// **'View terms and conditions'**
  String get termsOfServiceDesc;

  /// Biometric authentication option
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthentication;

  /// Biometric authentication description
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face unlock'**
  String get biometricAuthDesc;

  /// Auto-lock option
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock'**
  String get autoLock;

  /// Auto-lock description
  ///
  /// In en, this message translates to:
  /// **'Lock app when inactive'**
  String get autoLockDesc;

  /// Auto-lock timer option
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock Timer'**
  String get autoLockTimer;

  /// Lock after minutes description
  ///
  /// In en, this message translates to:
  /// **'Lock after {minutes} minutes'**
  String lockAfterMinutes(int minutes);

  /// Language option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// French language
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// German language
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// Italian language
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// Portuguese language
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// Russian language
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// Chinese language
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// Japanese language
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// Korean language
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get korean;

  /// Arabic language
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// Hindi language
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Warning message title
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Info message title
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search accounts placeholder
  ///
  /// In en, this message translates to:
  /// **'Search accounts...'**
  String get searchAccounts;

  /// No accounts found message
  ///
  /// In en, this message translates to:
  /// **'No accounts found'**
  String get noAccountsFound;

  /// Add first account message
  ///
  /// In en, this message translates to:
  /// **'Add your first account to get started'**
  String get addYourFirstAccount;

  /// Copied to clipboard message
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// Copied to clipboard full message
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Developer label
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Family sharing page title
  ///
  /// In en, this message translates to:
  /// **'Family Sharing'**
  String get familySharing;

  /// Overview tab title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Members tab title
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// Shared tab title
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shared;

  /// Share password button text
  ///
  /// In en, this message translates to:
  /// **'Share Password'**
  String get sharePassword;

  /// Create family vault title
  ///
  /// In en, this message translates to:
  /// **'Create Your Family Vault'**
  String get createYourFamilyVault;

  /// Family vault description
  ///
  /// In en, this message translates to:
  /// **'Share passwords securely with your family members. Create a family vault to get started.'**
  String get sharePasswordsSecurely;

  /// Create family vault button text
  ///
  /// In en, this message translates to:
  /// **'Create Family Vault'**
  String get createFamilyVault;

  /// Recent activity section title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// Shared items label
  ///
  /// In en, this message translates to:
  /// **'Shared Items'**
  String get sharedItems;

  /// Your name field label
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// Enter full name hint
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// Your email field label
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get yourEmail;

  /// Enter email address hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmailAddress;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Family vault created success message
  ///
  /// In en, this message translates to:
  /// **'Family vault created successfully!'**
  String get familyVaultCreatedSuccessfully;

  /// Failed to create family vault error message
  ///
  /// In en, this message translates to:
  /// **'Failed to create family vault: {error}'**
  String failedToCreateFamilyVault(String error);

  /// Invite family member dialog title
  ///
  /// In en, this message translates to:
  /// **'Invite Family Member'**
  String get inviteFamilyMember;

  /// Generate invite code description
  ///
  /// In en, this message translates to:
  /// **'Generate an invite code to share with your family member.'**
  String get generateInviteCode;

  /// Generate code button text
  ///
  /// In en, this message translates to:
  /// **'Generate Code'**
  String get generateCode;

  /// Invite code generated dialog title
  ///
  /// In en, this message translates to:
  /// **'Invite Code Generated'**
  String get inviteCodeGenerated;

  /// Share invite code instruction
  ///
  /// In en, this message translates to:
  /// **'Share this code with your family member:'**
  String get shareThisCode;

  /// Code expiration notice
  ///
  /// In en, this message translates to:
  /// **'This code expires in 7 days.'**
  String get codeExpiresInDays;

  /// Copy code button text
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// Failed to generate invite code error message
  ///
  /// In en, this message translates to:
  /// **'Failed to generate invite code: {error}'**
  String failedToGenerateInviteCode(String error);

  /// Password sharing dialog placeholder message
  ///
  /// In en, this message translates to:
  /// **'Password sharing dialog would open here'**
  String get passwordSharingDialog;

  /// Edit role menu item
  ///
  /// In en, this message translates to:
  /// **'Edit Role'**
  String get editRole;

  /// Remove menu item
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Account ID label
  ///
  /// In en, this message translates to:
  /// **'Account ID: {id}'**
  String accountId(String id);

  /// Shared with members count
  ///
  /// In en, this message translates to:
  /// **'Shared with {count} member(s)'**
  String sharedWithMembers(int count);

  /// Shared on date
  ///
  /// In en, this message translates to:
  /// **'Shared on {date}'**
  String sharedOn(String date);

  /// Password shared activity message
  ///
  /// In en, this message translates to:
  /// **'Password shared with {count} member(s)'**
  String passwordSharedWithMembers(int count);

  /// Failed to load family data error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load family data: {error}'**
  String failedToLoadFamilyData(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
