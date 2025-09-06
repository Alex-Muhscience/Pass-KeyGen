// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SecureVault';

  @override
  String get login => 'Login';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to access your secure vault';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signUpTitle => 'Create Account';

  @override
  String get signUpSubtitle => 'Join SecureVault to protect your passwords';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get biometricLogin => 'Use Biometric';

  @override
  String get home => 'Home';

  @override
  String get accounts => 'Accounts';

  @override
  String get addAccount => 'Add Account';

  @override
  String get accountName => 'Account Name';

  @override
  String get website => 'Website';

  @override
  String get notes => 'Notes';

  @override
  String get category => 'Category';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get copy => 'Copy';

  @override
  String get generate => 'Generate';

  @override
  String get settings => 'Settings';

  @override
  String get security => 'Security';

  @override
  String get securityDashboard => 'Security Dashboard';

  @override
  String get securityDashboardSubtitle =>
      'View security audit and recommendations';

  @override
  String get securityScore => 'Security Score';

  @override
  String get excellentSecurity => 'Excellent security';

  @override
  String get goodSecurity => 'Good security';

  @override
  String get fairSecurity => 'Fair security';

  @override
  String get poorSecurity => 'Poor security';

  @override
  String get criticalSecurityIssues => 'Critical security issues';

  @override
  String get totalAccounts => 'Total Accounts';

  @override
  String get issuesFound => 'Issues Found';

  @override
  String get strongPasswords => 'Strong Passwords';

  @override
  String get riskBreakdown => 'Risk Breakdown';

  @override
  String get critical => 'Critical';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get securityIssues => 'Security Issues';

  @override
  String get allClear => 'All Clear!';

  @override
  String get noSecurityIssues => 'No security issues detected';

  @override
  String viewAllIssues(int count) {
    return 'View All $count Issues';
  }

  @override
  String get passwordGenerator => 'Password Generator';

  @override
  String get passwordGeneratorSubtitle => 'Generate secure passwords';

  @override
  String get generatedPassword => 'Generated Password';

  @override
  String get generatedPassphrase => 'Generated Passphrase';

  @override
  String get passphrase => 'Passphrase';

  @override
  String get passwordAnalysis => 'Password Analysis';

  @override
  String get strength => 'Strength';

  @override
  String get score => 'Score';

  @override
  String get entropy => 'Entropy';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get alternativeOptions => 'Alternative Options';

  @override
  String get passwordSettings => 'Password Settings';

  @override
  String get passphraseSettings => 'Passphrase Settings';

  @override
  String length(int length) {
    return 'Length: $length';
  }

  @override
  String wordCount(int count) {
    return 'Word Count: $count';
  }

  @override
  String get separator => 'Separator';

  @override
  String get space => 'Space';

  @override
  String get includeUppercase => 'Uppercase (A-Z)';

  @override
  String get includeLowercase => 'Lowercase (a-z)';

  @override
  String get includeNumbers => 'Numbers (0-9)';

  @override
  String get includeSymbols => 'Symbols (!@#\$)';

  @override
  String get includeNumbersInPassphrase => 'Include Numbers';

  @override
  String get capitalizeWords => 'Capitalize Words';

  @override
  String get advancedOptions => 'Advanced Options';

  @override
  String get excludeSimilar => 'Exclude Similar (il1Lo0O)';

  @override
  String get excludeAmbiguous => 'Exclude Ambiguous Characters';

  @override
  String get twoFactorAuthentication => 'Two-Factor Authentication';

  @override
  String get twoFactorAuthSubtitle => 'Add an extra layer of security';

  @override
  String get secureYourAccount => 'Secure Your Account';

  @override
  String get twoFactorDescription =>
      'Two-factor authentication adds an extra layer of security to your account by requiring a verification code from your phone.';

  @override
  String get enhancedSecurity => 'Enhanced Security';

  @override
  String get enhancedSecurityDesc => 'Protect against unauthorized access';

  @override
  String get mobileAppSupport => 'Mobile App Support';

  @override
  String get mobileAppSupportDesc =>
      'Works with Google Authenticator, Authy, and more';

  @override
  String get backupCodes => 'Backup Codes';

  @override
  String get backupCodesDesc => 'Recovery codes in case you lose your device';

  @override
  String get enable2FA => 'Enable 2FA';

  @override
  String get scanQRCode => 'Scan QR Code';

  @override
  String get scanQRCodeDesc =>
      'Use your authenticator app to scan this QR code';

  @override
  String get manualEntryCode => 'Manual Entry Code';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get enterSixDigitCode => 'Enter 6-digit code';

  @override
  String get verifyAndEnable => 'Verify & Enable';

  @override
  String get twoFAEnabledSuccessfully => '2FA Enabled Successfully!';

  @override
  String get saveBackupCodes =>
      'Save these backup codes in a secure location. You can use them to access your account if you lose your authenticator device.';

  @override
  String get done => 'Done';

  @override
  String get twoFAEnabled => '2FA Enabled';

  @override
  String get accountProtected =>
      'Your account is protected with two-factor authentication';

  @override
  String get regenerate => 'Regenerate';

  @override
  String backupCodesRemaining(int count) {
    return 'You have $count backup codes remaining';
  }

  @override
  String get viewCodes => 'View Codes';

  @override
  String get regenerateBackupCodes => 'Regenerate Backup Codes';

  @override
  String get generateNewBackupCodes => 'Generate new backup codes';

  @override
  String get reset2FA => 'Reset 2FA';

  @override
  String get generateNewSecretKey => 'Generate new secret key';

  @override
  String get disable2FA => 'Disable 2FA';

  @override
  String get turnOff2FA => 'Turn off two-factor authentication';

  @override
  String get copyAllCodes => 'Copy All Codes';

  @override
  String get importExport => 'Import & Export';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get importPasswords => 'Import Passwords';

  @override
  String get importPasswordsDesc =>
      'Import your passwords from other password managers';

  @override
  String get exportPasswords => 'Export Passwords';

  @override
  String get exportPasswordsDesc =>
      'Create a backup or migrate to another password manager';

  @override
  String get exportDataWarning =>
      'Make sure to export your data from the other password manager first';

  @override
  String get sensitiveDataWarning =>
      'Exported files contain sensitive data. Store them securely and delete after use.';

  @override
  String get chooseImportSource => 'Choose Import Source';

  @override
  String get chooseExportFormat => 'Choose Export Format';

  @override
  String get chrome => 'Chrome';

  @override
  String get chromeImportDesc => 'Import from Chrome password export (CSV)';

  @override
  String get firefox => 'Firefox';

  @override
  String get firefoxImportDesc => 'Import from Firefox password export (CSV)';

  @override
  String get safari => 'Safari';

  @override
  String get safariImportDesc => 'Import from Safari password export (CSV)';

  @override
  String get bitwarden => 'Bitwarden';

  @override
  String get bitwardenImportDesc => 'Import from Bitwarden vault export (JSON)';

  @override
  String get lastpass => 'LastPass';

  @override
  String get lastpassImportDesc => 'Import from LastPass vault export (CSV)';

  @override
  String get onepassword => '1Password';

  @override
  String get onepasswordImportDesc => 'Import from 1Password export (CSV)';

  @override
  String get genericCSV => 'Generic CSV';

  @override
  String get genericCSVDesc => 'Import from any CSV file';

  @override
  String get jsonFile => 'JSON File';

  @override
  String get jsonFileDesc => 'Import from JSON file';

  @override
  String get encryptedExport => 'Encrypted Export';

  @override
  String get encryptedExportDesc =>
      'Secure export with password protection (Recommended)';

  @override
  String get csvExport => 'CSV Export';

  @override
  String get csvExportDesc => 'Compatible with most password managers';

  @override
  String get jsonExport => 'JSON Export';

  @override
  String get jsonExportDesc => 'Structured data format with metadata';

  @override
  String get secure => 'SECURE';

  @override
  String get privacy => 'Privacy';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get cloudSyncDesc => 'Sync data across devices';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc => 'View our privacy policy';

  @override
  String get dataUsage => 'Data Usage';

  @override
  String get dataUsageDesc => 'See how your data is used';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get compactView => 'Compact View';

  @override
  String get compactViewDesc => 'Show more items on screen';

  @override
  String get showPasswords => 'Show Passwords';

  @override
  String get showPasswordsDesc => 'Display passwords by default';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get importExportDesc => 'Import from other password managers';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get backupRestoreDesc => 'Create and restore backups';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheDesc => 'Free up storage space';

  @override
  String get resetApp => 'Reset App';

  @override
  String get resetAppDesc => 'Delete all data and reset';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get helpSupportDesc => 'Get help and contact support';

  @override
  String get rateApp => 'Rate App';

  @override
  String get rateAppDesc => 'Rate SecureVault on the app store';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceDesc => 'View terms and conditions';

  @override
  String get biometricAuthentication => 'Biometric Authentication';

  @override
  String get biometricAuthDesc => 'Use fingerprint or face unlock';

  @override
  String get autoLock => 'Auto-Lock';

  @override
  String get autoLockDesc => 'Lock app when inactive';

  @override
  String get autoLockTimer => 'Auto-Lock Timer';

  @override
  String lockAfterMinutes(int minutes) {
    return 'Lock after $minutes minutes';
  }

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Français';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Português';

  @override
  String get russian => 'Русский';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get arabic => 'العربية';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get searchAccounts => 'Search accounts...';

  @override
  String get noAccountsFound => 'No accounts found';

  @override
  String get addYourFirstAccount => 'Add your first account to get started';

  @override
  String get copied => 'Copied';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get developer => 'Developer';

  @override
  String get familySharing => 'Family Sharing';

  @override
  String get overview => 'Overview';

  @override
  String get members => 'Members';

  @override
  String get shared => 'Shared';

  @override
  String get sharePassword => 'Share Password';

  @override
  String get createYourFamilyVault => 'Create Your Family Vault';

  @override
  String get sharePasswordsSecurely =>
      'Share passwords securely with your family members. Create a family vault to get started.';

  @override
  String get createFamilyVault => 'Create Family Vault';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get sharedItems => 'Shared Items';

  @override
  String get yourName => 'Your Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get enterYourEmailAddress => 'Enter your email address';

  @override
  String get create => 'Create';

  @override
  String get familyVaultCreatedSuccessfully =>
      'Family vault created successfully!';

  @override
  String failedToCreateFamilyVault(String error) {
    return 'Failed to create family vault: $error';
  }

  @override
  String get inviteFamilyMember => 'Invite Family Member';

  @override
  String get generateInviteCode =>
      'Generate an invite code to share with your family member.';

  @override
  String get generateCode => 'Generate Code';

  @override
  String get inviteCodeGenerated => 'Invite Code Generated';

  @override
  String get shareThisCode => 'Share this code with your family member:';

  @override
  String get codeExpiresInDays => 'This code expires in 7 days.';

  @override
  String get copyCode => 'Copy Code';

  @override
  String failedToGenerateInviteCode(String error) {
    return 'Failed to generate invite code: $error';
  }

  @override
  String get passwordSharingDialog => 'Password sharing dialog would open here';

  @override
  String get editRole => 'Edit Role';

  @override
  String get remove => 'Remove';

  @override
  String accountId(String id) {
    return 'Account ID: $id';
  }

  @override
  String sharedWithMembers(int count) {
    return 'Shared with $count member(s)';
  }

  @override
  String sharedOn(String date) {
    return 'Shared on $date';
  }

  @override
  String passwordSharedWithMembers(int count) {
    return 'Password shared with $count member(s)';
  }

  @override
  String failedToLoadFamilyData(String error) {
    return 'Failed to load family data: $error';
  }
}
