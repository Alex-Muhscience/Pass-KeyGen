import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
import 'package:keygen/services/theme_service.dart';
=======
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/two_factor_auth_service.dart';
import '../services/backup_sync_service.dart';
import '../services/advanced_encryption_service.dart';
import 'security_dashboard_page.dart';
import 'password_generator_page.dart';
import 'two_factor_setup_page.dart';
import 'import_export_page.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
<<<<<<< HEAD
  _SettingsPageState createState() => _SettingsPageState();
=======
  State<SettingsPage> createState() => _SettingsPageState();
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
}

class _SettingsPageState extends State<SettingsPage> {
  final ThemeService _themeService = Get.find<ThemeService>();
<<<<<<< HEAD
  late ThemeMode _currentThemeMode;
=======
  final TwoFactorAuthService _twoFactorService = TwoFactorAuthService();
  late BackupSyncService _backupService;
  
  late ThemeMode _currentThemeMode;
  bool _is2FAEnabled = false;
  bool _isSyncEnabled = false;
  bool _biometricEnabled = false;
  bool _autoLockEnabled = true;
  int _autoLockMinutes = 5;
  String _appVersion = '';
  bool _isLoading = true;
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    _currentThemeMode = await _themeService.getCurrentTheme();
    setState(() {}); // Refresh the widget to show the current theme
  }

  void _updateTheme(ThemeMode themeMode) {
    _themeService.updateTheme(themeMode);
    setState(() {
      _currentThemeMode = themeMode;
    });
=======
    _backupService = BackupSyncService(AdvancedEncryptionService());
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      _currentThemeMode = await _themeService.getCurrentTheme();
      _is2FAEnabled = await _twoFactorService.is2FAEnabled();
      _isSyncEnabled = await _backupService.isSyncEnabled();
      
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load settings: $e');
    }
    
    setState(() => _isLoading = false);
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 16),
            RadioListTile<ThemeMode>(
              title: const Text('Light Mode'),
              value: ThemeMode.light,
              groupValue: _currentThemeMode,
              onChanged: (value) {
                if (value != null) {
                  _updateTheme(value);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark Mode'),
              value: ThemeMode.dark,
              groupValue: _currentThemeMode,
              onChanged: (value) {
                if (value != null) {
                  _updateTheme(value);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: _currentThemeMode,
              onChanged: (value) {
                if (value != null) {
                  _updateTheme(value);
                }
=======
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          l10n.settings,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Security Section
                SliverToBoxAdapter(
                  child: _buildSecuritySection()
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.3),
                ),
                
                // Privacy Section
                SliverToBoxAdapter(
                  child: _buildPrivacySection()
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.3),
                ),
                
                // Appearance Section
                SliverToBoxAdapter(
                  child: _buildAppearanceSection()
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: 0.3),
                ),
                
                // Data Management Section
                SliverToBoxAdapter(
                  child: _buildDataSection()
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3),
                ),
                
                // About Section
                SliverToBoxAdapter(
                  child: _buildAboutSection()
                      .animate(delay: 800.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3),
                ),
                
                const SliverToBoxAdapter(child: Gap(100)),
              ],
            ),
    );
  }

  Widget _buildSecuritySection() {
    return _buildSection(
      'Security',
      Icons.security,
      Colors.red,
      [
        _buildNavigationTile(
          'Security Dashboard',
          'View security audit and recommendations',
          Icons.dashboard,
          () => Get.to(() => const SecurityDashboardPage()),
        ),
        _buildSwitchTile(
          'Two-Factor Authentication',
          'Add an extra layer of security',
          Icons.verified_user,
          _is2FAEnabled,
          (value) => _toggle2FA(),
        ),
        _buildSwitchTile(
          'Biometric Authentication',
          'Use fingerprint or face unlock',
          Icons.fingerprint,
          _biometricEnabled,
          (value) => setState(() => _biometricEnabled = value),
        ),
        _buildSwitchTile(
          'Auto-Lock',
          'Lock app when inactive',
          Icons.lock_clock,
          _autoLockEnabled,
          (value) => setState(() => _autoLockEnabled = value),
        ),
        if (_autoLockEnabled)
          _buildSliderTile(
            'Auto-Lock Timer',
            'Lock after $_autoLockMinutes minutes',
            Icons.timer,
            _autoLockMinutes.toDouble(),
            1,
            30,
            (value) => setState(() => _autoLockMinutes = value.toInt()),
          ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return _buildSection(
      'Privacy',
      Icons.privacy_tip,
      Colors.blue,
      [
        _buildNavigationTile(
          'Password Generator',
          'Generate secure passwords',
          Icons.vpn_key,
          () => Get.to(() => const PasswordGeneratorPage()),
        ),
        _buildSwitchTile(
          'Cloud Sync',
          'Sync data across devices',
          Icons.cloud_sync,
          _isSyncEnabled,
          (value) => _toggleSync(value),
        ),
        _buildNavigationTile(
          'Privacy Policy',
          'View our privacy policy',
          Icons.policy,
          () => _showPrivacyPolicy(),
        ),
        _buildNavigationTile(
          'Data Usage',
          'See how your data is used',
          Icons.analytics,
          () => _showDataUsage(),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      'Appearance',
      Icons.palette,
      Colors.purple,
      [
        _buildThemeSelector(),
        _buildLanguageSelector(),
        _buildSwitchTile(
          'Compact View',
          'Show more items on screen',
          Icons.view_compact,
          false,
          (value) => {},
        ),
        _buildSwitchTile(
          'Show Passwords',
          'Display passwords by default',
          Icons.visibility,
          false,
          (value) => {},
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return _buildSection(
      'Data Management',
      Icons.storage,
      Colors.green,
      [
        _buildNavigationTile(
          'Import & Export',
          'Import from other password managers',
          Icons.import_export,
          () => Get.to(() => const ImportExportPage()),
        ),
        _buildNavigationTile(
          'Backup & Restore',
          'Create and restore backups',
          Icons.backup,
          () => _showBackupOptions(),
        ),
        _buildNavigationTile(
          'Clear Cache',
          'Free up storage space',
          Icons.cleaning_services,
          () => _clearCache(),
        ),
        _buildNavigationTile(
          'Reset App',
          'Delete all data and reset',
          Icons.restore,
          () => _showResetDialog(),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      'About',
      Icons.info,
      Colors.orange,
      [
        _buildInfoTile('Version', _appVersion, Icons.info),
        _buildNavigationTile(
          'Help & Support',
          'Get help and contact support',
          Icons.help,
          () => _showHelpDialog(),
        ),
        _buildNavigationTile(
          'Rate App',
          'Rate SecureVault on the app store',
          Icons.star,
          () => _rateApp(),
        ),
        _buildNavigationTile(
          'Terms of Service',
          'View terms and conditions',
          Icons.description,
          () => _showTermsOfService(),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Gap(12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildNavigationTile(String title, String subtitle, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                size: 24,
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDestructive ? Colors.red : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(String title, String subtitle, IconData icon, double value, double min, double max, Function(double) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                size: 24,
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
          const Gap(16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_6,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: _buildThemeOption('Light', ThemeMode.light, Icons.light_mode),
              ),
              const Gap(12),
              Expanded(
                child: _buildThemeOption('Dark', ThemeMode.dark, Icons.dark_mode),
              ),
              const Gap(12),
              Expanded(
                child: _buildThemeOption('System', ThemeMode.system, Icons.settings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed('/language_selection'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Language',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(4),
                      FutureBuilder<Locale>(
                        future: LanguageService.getCurrentLocale(),
                        builder: (context, snapshot) {
                          final currentLanguage = snapshot.data?.languageCode ?? 'en';
                          final languageName = LanguageService.getNativeLanguageName(currentLanguage);
                          return Text(
                            languageName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label, ThemeMode mode, IconData icon) {
    final isSelected = _currentThemeMode == mode;
    
    return GestureDetector(
      onTap: () => _updateTheme(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            const Gap(4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTheme(ThemeMode themeMode) {
    _themeService.updateTheme(themeMode);
    setState(() => _currentThemeMode = themeMode);
  }

  void _toggle2FA() {
    Get.to(() => const TwoFactorSetupPage())?.then((_) => _loadSettings());
  }

  void _toggleSync(bool enabled) async {
    if (enabled) {
      await _backupService.enableSync();
    } else {
      await _backupService.disableSync();
    }
    setState(() => _isSyncEnabled = enabled);
  }

  void _showBackupOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Backup Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Create Backup'),
              onTap: () {
                Get.back();
                // Implement backup creation
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore Backup'),
              onTap: () {
                Get.back();
                // Implement backup restoration
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
              },
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  void _clearCache() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear temporary files and free up storage space.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.snackbar('Success', 'Cache cleared successfully');
    }
  }

  void _showResetDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset App'),
        content: const Text('This will delete all your data and cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Implement app reset
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text('Your privacy is important to us. SecureVault uses end-to-end encryption to protect your data...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDataUsage() {
    Get.dialog(
      AlertDialog(
        title: const Text('Data Usage'),
        content: const Text('SecureVault only collects anonymous usage statistics to improve the app. No personal data is shared.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('For help and support, please visit our website or contact us at support@securevault.com'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    Get.snackbar('Rate App', 'Thank you for using SecureVault!');
  }

  void _showTermsOfService() {
    Get.dialog(
      AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text('By using SecureVault, you agree to our terms of service...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
}
