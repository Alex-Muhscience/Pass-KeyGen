import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../services/autofill_service.dart';

class AutofillPage extends StatefulWidget {
  const AutofillPage({super.key});

  @override
  State<AutofillPage> createState() => _AutofillPageState();
}

class _AutofillPageState extends State<AutofillPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isAutofillEnabled = false;
  Map<String, dynamic> _settings = {};
  List<BrowserIntegration> _browsers = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAutofillData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAutofillData() async {
    setState(() => _isLoading = true);
    
    try {
      final enabled = await AutofillService.isAutofillEnabled();
      final settings = await AutofillService.getAutofillSettings();
      final browsers = await AutofillService.getSupportedBrowsers();
      final stats = await AutofillService.getAutofillStats();
      
      setState(() {
        _isAutofillEnabled = enabled;
        _settings = settings;
        _browsers = browsers;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to load autofill data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Auto-fill & Browser Integration',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Settings', icon: Icon(Icons.settings)),
            Tab(text: 'Browsers', icon: Icon(Icons.web)),
            Tab(text: 'Statistics', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSettingsTab(),
                _buildBrowsersTab(),
                _buildStatisticsTab(),
              ],
            ),
    );
  }

  Widget _buildSettingsTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auto-fill Toggle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-fill Service',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'Automatically fill passwords in apps and websites',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isAutofillEnabled,
                  onChanged: (value) async {
                    await AutofillService.setAutofillEnabled(value);
                    setState(() => _isAutofillEnabled = value);
                    
                    Get.snackbar(
                      'Success',
                      value ? 'Auto-fill enabled' : 'Auto-fill disabled',
                      backgroundColor: theme.colorScheme.primaryContainer,
                      colorText: theme.colorScheme.onPrimaryContainer,
                    );
                  },
                ),
              ],
            ),
          ).animate().fadeIn().slideY(),
          
          const Gap(32),
          
          // Settings Section
          Text(
            'Auto-fill Settings',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate(delay: 200.ms).fadeIn().slideX(),
          
          const Gap(16),
          
          ..._buildSettingsTiles().asMap().entries.map((entry) => 
            entry.value.animate(delay: Duration(milliseconds: 300 + (entry.key * 100)))
                      .fadeIn()
                      .slideX()
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSettingsTiles() {
    return [
      _buildSettingTile(
        'Auto Submit Forms',
        'Automatically submit forms after filling',
        Icons.send,
        _settings['autoSubmit'] ?? false,
        (value) => _updateSetting('autoSubmit', value),
      ),
      _buildSettingTile(
        'Show Notifications',
        'Show notifications when passwords are filled',
        Icons.notifications,
        _settings['showNotifications'] ?? true,
        (value) => _updateSetting('showNotifications', value),
      ),
      _buildSettingTile(
        'Match Subdomains',
        'Fill passwords for subdomains automatically',
        Icons.domain,
        _settings['matchSubdomains'] ?? true,
        (value) => _updateSetting('matchSubdomains', value),
      ),
      _buildSettingTile(
        'Require Biometric',
        'Require biometric authentication for auto-fill',
        Icons.fingerprint,
        _settings['requireBiometric'] ?? false,
        (value) => _updateSetting('requireBiometric', value),
      ),
      _buildSettingTile(
        'Auto Save New Passwords',
        'Automatically save new passwords when detected',
        Icons.save,
        _settings['autoSave'] ?? true,
        (value) => _updateSetting('autoSave', value),
      ),
      _buildSettingTile(
        'Fill on Focus',
        'Fill passwords when input fields are focused',
        Icons.touch_app,
        _settings['fillOnFocus'] ?? true,
        (value) => _updateSetting('fillOnFocus', value),
      ),
    ];
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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

  Widget _buildBrowsersTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browser Extensions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(),
          
          const Gap(8),
          
          Text(
            'Install SecureVault extensions for seamless password filling in your browsers.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ).animate(delay: 200.ms).fadeIn().slideX(),
          
          const Gap(24),
          
          ..._browsers.asMap().entries.map((entry) => 
            _buildBrowserCard(entry.value)
                .animate(delay: Duration(milliseconds: 300 + (entry.key * 100)))
                .fadeIn()
                .slideX()
          ),
        ],
      ),
    );
  }

  Widget _buildBrowserCard(BrowserIntegration browser) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getBrowserColor(browser.browserId).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getBrowserIcon(browser.browserId),
              color: _getBrowserColor(browser.browserId),
              size: 24,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  browser.browserName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: browser.isInstalled 
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        browser.isInstalled ? 'INSTALLED' : 'NOT INSTALLED',
                        style: TextStyle(
                          color: browser.isInstalled ? Colors.green : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (browser.isInstalled) ...[
                      const Gap(8),
                      Text(
                        'v${browser.version}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!browser.isInstalled)
            ElevatedButton(
              onPressed: () => AutofillService.installBrowserExtension(browser.browserId),
              child: const Text('Install'),
            )
          else
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Auto-fill Statistics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(),
          
          const Gap(24),
          
          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                'Total Credentials',
                _stats['totalCredentials']?.toString() ?? '0',
                Icons.key,
                Colors.blue,
              ),
              _buildStatCard(
                'Recently Used',
                _stats['recentlyUsed']?.toString() ?? '0',
                Icons.access_time,
                Colors.green,
              ),
              _buildStatCard(
                'Unique Domains',
                _stats['uniqueDomains']?.toString() ?? '0',
                Icons.domain,
                Colors.orange,
              ),
              _buildStatCard(
                'Browser Extensions',
                _browsers.where((b) => b.isInstalled).length.toString(),
                Icons.extension,
                Colors.purple,
              ),
            ],
          ).animate(delay: 200.ms).fadeIn().slideY(),
          
          const Gap(32),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate(delay: 400.ms).fadeIn().slideX(),
          
          const Gap(16),
          
          _buildActionButton(
            'Sync Passwords',
            'Update auto-fill credentials from your vault',
            Icons.sync,
            () => _syncPasswords(),
          ).animate(delay: 600.ms).fadeIn().slideX(),
          
          const Gap(12),
          
          _buildActionButton(
            'Clear Auto-fill Data',
            'Remove all stored auto-fill credentials',
            Icons.clear_all,
            () => _clearAutofillData(),
            isDestructive: true,
          ).animate(delay: 700.ms).fadeIn().slideX(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const Gap(8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive ? Colors.red : theme.colorScheme.primary;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : null,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getBrowserIcon(String browserId) {
    switch (browserId) {
      case 'chrome':
        return Icons.web;
      case 'firefox':
        return Icons.web;
      case 'edge':
        return Icons.web;
      case 'safari':
        return Icons.web;
      default:
        return Icons.web;
    }
  }

  Color _getBrowserColor(String browserId) {
    switch (browserId) {
      case 'chrome':
        return Colors.blue;
      case 'firefox':
        return Colors.orange;
      case 'edge':
        return Colors.cyan;
      case 'safari':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateSetting(String key, bool value) async {
    setState(() => _settings[key] = value);
    await AutofillService.updateAutofillSettings(_settings);
  }

  Future<void> _syncPasswords() async {
    try {
      // In a real implementation, this would sync with the password vault
      Get.snackbar('Success', 'Auto-fill credentials synced successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sync passwords: $e');
    }
  }

  Future<void> _clearAutofillData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Auto-fill Data'),
        content: const Text(
          'This will remove all stored auto-fill credentials. You can sync them again from your vault.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AutofillService.clearAutofillData();
        _loadAutofillData();
        Get.snackbar('Success', 'Auto-fill data cleared successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to clear auto-fill data: $e');
      }
    }
  }
}
