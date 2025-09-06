import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../services/two_factor_auth_service.dart';

class TwoFactorSetupPage extends StatefulWidget {
  const TwoFactorSetupPage({super.key});

  @override
  State<TwoFactorSetupPage> createState() => _TwoFactorSetupPageState();
}

class _TwoFactorSetupPageState extends State<TwoFactorSetupPage> {
  final TwoFactorAuthService _twoFactorService = TwoFactorAuthService();
  final TextEditingController _codeController = TextEditingController();
  
  bool _is2FAEnabled = false;
  bool _isLoading = true;
  String? _secret;
  String? _qrCodeData;
  List<String> _backupCodes = [];
  int _currentStep = 0;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentStatus();
  }

  Future<void> _checkCurrentStatus() async {
    setState(() => _isLoading = true);
    
    try {
      _is2FAEnabled = await _twoFactorService.is2FAEnabled();
      if (_is2FAEnabled) {
        _backupCodes = await _twoFactorService.getBackupCodes();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to check 2FA status: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _startSetup() async {
    setState(() => _isLoading = true);
    
    try {
      _secret = await _twoFactorService.generateSecret();
      _qrCodeData = await _twoFactorService.generateQRCodeData(
        accountName: 'user@securevault.com', // This should be the actual user email
        issuer: 'SecureVault',
      );
      setState(() => _currentStep = 1);
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate 2FA secret: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _verifyAndEnable() async {
    if (_codeController.text.length != 6) {
      Get.snackbar('Error', 'Please enter a 6-digit code');
      return;
    }

    setState(() => _isVerifying = true);
    
    try {
      final isValid = await _twoFactorService.verifyTOTP(_codeController.text);
      
      if (isValid) {
        await _twoFactorService.enable2FA();
        _backupCodes = await _twoFactorService.generateBackupCodes();
        setState(() {
          _is2FAEnabled = true;
          _currentStep = 2;
        });
        Get.snackbar('Success', '2FA has been enabled successfully!');
      } else {
        Get.snackbar('Error', 'Invalid verification code. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification failed: $e');
    }
    
    setState(() => _isVerifying = false);
  }

  Future<void> _disable2FA() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Disable 2FA'),
        content: const Text('Are you sure you want to disable two-factor authentication? This will make your account less secure.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Disable'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _twoFactorService.disable2FA();
        setState(() {
          _is2FAEnabled = false;
          _currentStep = 0;
          _secret = null;
          _qrCodeData = null;
          _backupCodes.clear();
        });
        Get.snackbar('Success', '2FA has been disabled');
      } catch (e) {
        Get.snackbar('Error', 'Failed to disable 2FA: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Two-Factor Authentication',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _is2FAEnabled
              ? _buildEnabledView()
              : _buildSetupFlow(),
    );
  }

  Widget _buildEnabledView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildStatusCard()
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.3),
        ),
        SliverToBoxAdapter(
          child: _buildBackupCodes()
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
        ),
        SliverToBoxAdapter(
          child: _buildManagementOptions()
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.3),
        ),
        const SliverToBoxAdapter(child: Gap(100)),
      ],
    );
  }

  Widget _buildSetupFlow() {
    switch (_currentStep) {
      case 0:
        return _buildIntroduction();
      case 1:
        return _buildQRCodeStep();
      case 2:
        return _buildBackupCodesStep();
      default:
        return _buildIntroduction();
    }
  }

  Widget _buildIntroduction() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Gap(40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.security,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
              .animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut),
          
          const Gap(32),
          
          Text(
            'Secure Your Account',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
          
          const Gap(16),
          
          Text(
            'Two-factor authentication adds an extra layer of security to your account by requiring a verification code from your phone.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
          
          const Gap(40),
          
          _buildFeatureList()
              .animate(delay: 600.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.3),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startSetup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enable 2FA',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
              .animate(delay: 800.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.5),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      {'icon': Icons.shield, 'title': 'Enhanced Security', 'description': 'Protect against unauthorized access'},
      {'icon': Icons.phone_android, 'title': 'Mobile App Support', 'description': 'Works with Google Authenticator, Authy, and more'},
      {'icon': Icons.backup, 'title': 'Backup Codes', 'description': 'Recovery codes in case you lose your device'},
    ];

    return Column(
      children: features.map((feature) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    feature['description'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildQRCodeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Scan QR Code',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.3),
          
          const Gap(16),
          
          Text(
            'Use your authenticator app to scan this QR code',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms),
          
          const Gap(32),
          
          // QR Code placeholder (you'll need to implement actual QR code generation)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _qrCodeData != null
                ? FutureBuilder<Widget>(
                    future: _twoFactorService.generateQRCodeWidget(
                      accountName: 'user@securevault.com',
                      issuer: 'SecureVault',
                      size: 180,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          )
              .animate(delay: 400.ms)
              .scale(duration: 800.ms, curve: Curves.elasticOut),
          
          const Gap(24),
          
          Text(
            'Manual Entry Code',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Gap(8),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _secret ?? '',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_secret != null) {
                      Clipboard.setData(ClipboardData(text: _secret!));
                      Get.snackbar('Copied', 'Secret key copied to clipboard');
                    }
                  },
                  icon: const Icon(Icons.copy, size: 20),
                ),
              ],
            ),
          )
              .animate(delay: 600.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
          
          const Gap(32),
          
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: 'Verification Code',
              hintText: 'Enter 6-digit code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.security),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          )
              .animate(delay: 800.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.3),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isVerifying ? null : _verifyAndEnable,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isVerifying
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Verify & Enable',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          )
              .animate(delay: 1000.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.5),
        ],
      ),
    );
  }

  Widget _buildBackupCodesStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            size: 80,
            color: Colors.green,
          )
              .animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut),
          
          const Gap(24),
          
          Text(
            '2FA Enabled Successfully!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms),
          
          const Gap(16),
          
          Text(
            'Save these backup codes in a secure location. You can use them to access your account if you lose your authenticator device.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms),
          
          const Gap(32),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Colors.orange,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'Backup Codes',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _backupCodes.join('\n')));
                        Get.snackbar('Copied', 'Backup codes copied to clipboard');
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
                const Gap(16),
                ...List.generate(_backupCodes.length, (index) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      _backupCodes[index],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate(delay: 600.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
              .animate(delay: 800.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.5),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withValues(alpha: 0.1), Colors.green.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.verified_user,
              color: Colors.green,
              size: 32,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2FA Enabled',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'Your account is protected with two-factor authentication',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupCodes() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Backup Codes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  _backupCodes = await _twoFactorService.generateBackupCodes();
                  setState(() {});
                  Get.snackbar('Success', 'New backup codes generated');
                },
                child: const Text('Regenerate'),
              ),
            ],
          ),
          const Gap(16),
          Text(
            'You have ${_backupCodes.length} backup codes remaining',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Gap(16),
          ElevatedButton.icon(
            onPressed: () => _showBackupCodes(),
            icon: const Icon(Icons.visibility),
            label: const Text('View Codes'),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementOptions() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.blue),
            title: const Text('Regenerate Backup Codes'),
            subtitle: const Text('Generate new backup codes'),
            onTap: () async {
              _backupCodes = await _twoFactorService.generateBackupCodes();
              setState(() {});
              Get.snackbar('Success', 'New backup codes generated');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security_update_warning, color: Colors.orange),
            title: const Text('Reset 2FA'),
            subtitle: const Text('Generate new secret key'),
            onTap: () => _resetTwoFactor(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.disabled_by_default, color: Colors.red),
            title: const Text('Disable 2FA'),
            subtitle: const Text('Turn off two-factor authentication'),
            onTap: _disable2FA,
          ),
        ],
      ),
    );
  }

  void _showBackupCodes() {
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
            Row(
              children: [
                Text(
                  'Backup Codes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _backupCodes.map((code) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    code,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                    ),
                  ),
                )).toList(),
              ),
            ),
            const Gap(16),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _backupCodes.join('\n')));
                Get.snackbar('Copied', 'Backup codes copied to clipboard');
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy All Codes'),
            ),
          ],
        ),
      ),
    );
  }

  void _resetTwoFactor() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reset 2FA'),
        content: const Text('This will generate a new secret key. You\'ll need to set up your authenticator app again.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _twoFactorService.disable2FA();
      setState(() {
        _is2FAEnabled = false;
        _currentStep = 0;
      });
      _startSetup();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
