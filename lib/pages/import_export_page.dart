import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../services/import_export_service.dart';
import '../services/advanced_encryption_service.dart';
import '../services/database_helper.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late ImportExportService _importExportService;
  
  bool _isProcessing = false;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _importExportService = ImportExportService(AdvancedEncryptionService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Import & Export',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar()
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.3),
          
          Expanded(
            child: _selectedTabIndex == 0 
                ? _buildImportTab()
                : _buildExportTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_download,
                      color: _selectedTabIndex == 0
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    const Gap(8),
                    Text(
                      'Import',
                      style: TextStyle(
                        color: _selectedTabIndex == 0
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload,
                      color: _selectedTabIndex == 1
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    const Gap(8),
                    Text(
                      'Export',
                      style: TextStyle(
                        color: _selectedTabIndex == 1
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildImportHeader()
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
        ),
        
        SliverToBoxAdapter(
          child: _buildImportOptions()
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.3),
        ),
        
        const SliverToBoxAdapter(child: Gap(100)),
      ],
    );
  }

  Widget _buildExportTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildExportHeader()
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
        ),
        
        SliverToBoxAdapter(
          child: _buildExportOptions()
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: 0.3),
        ),
        
        const SliverToBoxAdapter(child: Gap(100)),
      ],
    );
  }

  Widget _buildImportHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.file_download,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Import Passwords',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Import your passwords from other password managers',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.orange, size: 20),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Make sure to export your data from the other password manager first',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportOptions() {
    final importOptions = [
      {
        'title': 'Chrome',
        'description': 'Import from Chrome password export (CSV)',
        'icon': Icons.web,
        'color': Colors.blue,
        'format': ImportFormat.chrome,
      },
      {
        'title': 'Firefox',
        'description': 'Import from Firefox password export (CSV)',
        'icon': Icons.web,
        'color': Colors.orange,
        'format': ImportFormat.firefox,
      },
      {
        'title': 'Safari',
        'description': 'Import from Safari password export (CSV)',
        'icon': Icons.web,
        'color': Colors.blue,
        'format': ImportFormat.safari,
      },
      {
        'title': 'Bitwarden',
        'description': 'Import from Bitwarden vault export (JSON)',
        'icon': Icons.security,
        'color': Colors.indigo,
        'format': ImportFormat.bitwarden,
      },
      {
        'title': 'LastPass',
        'description': 'Import from LastPass vault export (CSV)',
        'icon': Icons.lock,
        'color': Colors.red,
        'format': ImportFormat.lastpass,
      },
      {
        'title': '1Password',
        'description': 'Import from 1Password export (CSV)',
        'icon': Icons.vpn_key,
        'color': Colors.blue,
        'format': ImportFormat.onepassword,
      },
      {
        'title': 'Generic CSV',
        'description': 'Import from any CSV file',
        'icon': Icons.table_chart,
        'color': Colors.green,
        'format': ImportFormat.csv,
      },
      {
        'title': 'JSON File',
        'description': 'Import from JSON file',
        'icon': Icons.code,
        'color': Colors.purple,
        'format': ImportFormat.json,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Import Source',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          ...importOptions.map((option) => _buildImportOptionCard(option)),
        ],
      ),
    );
  }

  Widget _buildImportOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : () => _performImport(option['format']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (option['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    option['icon'],
                    color: option['color'],
                    size: 24,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        option['description'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.1),
            Colors.green.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.file_upload,
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
                      'Export Passwords',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Create a backup or migrate to another password manager',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.red, size: 20),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Exported files contain sensitive data. Store them securely and delete after use.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOptions() {
    final exportOptions = [
      {
        'title': 'Encrypted Export',
        'description': 'Secure export with password protection (Recommended)',
        'icon': Icons.enhanced_encryption,
        'color': Colors.green,
        'format': ExportFormat.encrypted,
        'secure': true,
      },
      {
        'title': 'CSV Export',
        'description': 'Compatible with most password managers',
        'icon': Icons.table_chart,
        'color': Colors.blue,
        'format': ExportFormat.csv,
        'secure': false,
      },
      {
        'title': 'JSON Export',
        'description': 'Structured data format with metadata',
        'icon': Icons.code,
        'color': Colors.purple,
        'format': ExportFormat.json,
        'secure': false,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Export Format',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          ...exportOptions.map((option) => _buildExportOptionCard(option)),
        ],
      ),
    );
  }

  Widget _buildExportOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : () => _performExport(option['format'], option['secure']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: option['secure'] 
                    ? Colors.green.withValues(alpha: 0.3)
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
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
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (option['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        option['icon'],
                        color: option['color'],
                        size: 24,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                option['title'],
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (option['secure']) ...[
                                const Gap(8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'SECURE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            option['description'],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performImport(ImportFormat format) async {
    setState(() => _isProcessing = true);
    
    try {
      final result = await _importExportService.importPasswords(format);
      
      if (result.accounts.isNotEmpty) {
        // Show import preview dialog
        final shouldImport = await _showImportPreview(result);
        
        if (shouldImport == true) {
          // Save accounts to database
          for (final account in result.accounts) {
            await _databaseHelper.insertAccount(account);
          }
          
          Get.snackbar(
            'Import Successful',
            'Imported ${result.successCount} passwords',
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
        }
      } else {
        Get.snackbar('Import Failed', 'No passwords found to import');
      }
      
      if (result.errors.isNotEmpty) {
        _showImportErrors(result.errors);
      }
    } catch (e) {
      Get.snackbar('Import Error', 'Failed to import: $e');
    }
    
    setState(() => _isProcessing = false);
  }

  Future<void> _performExport(ExportFormat format, bool isSecure) async {
    setState(() => _isProcessing = true);
    
    try {
      final accounts = await _databaseHelper.getAllAccounts();
      
      if (accounts.isEmpty) {
        Get.snackbar('Export Error', 'No passwords to export');
        setState(() => _isProcessing = false);
        return;
      }

      String? masterPassword;
      if (isSecure) {
        masterPassword = await _getMasterPasswordForExport();
        if (masterPassword == null) {
          setState(() => _isProcessing = false);
          return;
        }
      }

      final file = await _importExportService.exportPasswords(
        accounts,
        format,
        masterPassword: masterPassword,
      );
      
      await _importExportService.shareExportedFile(file);
      
      Get.snackbar(
        'Export Successful',
        'Exported ${accounts.length} passwords',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar('Export Error', 'Failed to export: $e');
    }
    
    setState(() => _isProcessing = false);
  }

  Future<bool?> _showImportPreview(ImportResult result) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Import Preview'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Found ${result.accounts.length} passwords to import:'),
              const Gap(16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: result.accounts.take(10).length,
                  itemBuilder: (context, index) {
                    final account = result.accounts[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.account_circle, size: 20),
                      title: Text(
                        account.accountName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        account.email,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              if (result.accounts.length > 10)
                Text('... and ${result.accounts.length - 10} more'),
              if (result.errors.isNotEmpty) ...[
                const Gap(8),
                Text(
                  '${result.errors.length} errors occurred during import',
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showImportErrors(List<String> errors) {
    Get.dialog(
      AlertDialog(
        title: const Text('Import Errors'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: errors.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                errors[index],
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String?> _getMasterPasswordForExport() async {
    final controller = TextEditingController();
    
    return await Get.dialog<String>(
      AlertDialog(
        title: const Text('Master Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter a master password to encrypt the export file:'),
            const Gap(16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Master Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Get.back(result: controller.text);
              }
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}
