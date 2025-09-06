import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../models/account_model.dart';
import 'advanced_encryption_service.dart';

enum ImportFormat { csv, json, chrome, firefox, safari, bitwarden, lastpass, onepassword }
enum ExportFormat { csv, json, encrypted }

class ImportResult {
  final List<AccountModel> accounts;
  final List<String> errors;
  final int successCount;
  final int errorCount;

  const ImportResult({
    required this.accounts,
    required this.errors,
    required this.successCount,
    required this.errorCount,
  });
}

class ImportExportService {
  final AdvancedEncryptionService _encryptionService;

  ImportExportService(this._encryptionService);

  /// Import passwords from various formats
  Future<ImportResult> importPasswords(ImportFormat format) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _getAllowedExtensions(format),
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No file selected');
      }

      final file = File(result.files.first.path!);
      final content = await file.readAsString();

      switch (format) {
        case ImportFormat.csv:
          return await _importFromCSV(content);
        case ImportFormat.json:
          return await _importFromJSON(content);
        case ImportFormat.chrome:
          return await _importFromChrome(content);
        case ImportFormat.firefox:
          return await _importFromFirefox(content);
        case ImportFormat.safari:
          return await _importFromSafari(content);
        case ImportFormat.bitwarden:
          return await _importFromBitwarden(content);
        case ImportFormat.lastpass:
          return await _importFromLastPass(content);
        case ImportFormat.onepassword:
          return await _importFromOnePassword(content);
      }
    } catch (e) {
      return ImportResult(
        accounts: [],
        errors: ['Import failed: $e'],
        successCount: 0,
        errorCount: 1,
      );
    }
  }

  /// Export passwords to various formats
  Future<File> exportPasswords(List<AccountModel> accounts, ExportFormat format, {String? masterPassword}) async {
    try {
      String content;
      String extension;

      switch (format) {
        case ExportFormat.csv:
          content = _exportToCSV(accounts);
          extension = 'csv';
          break;
        case ExportFormat.json:
          content = _exportToJSON(accounts);
          extension = 'json';
          break;
        case ExportFormat.encrypted:
          if (masterPassword == null) {
            throw Exception('Master password required for encrypted export');
          }
          content = await _exportEncrypted(accounts, masterPassword);
          extension = 'svault';
          break;
      }

      final directory = Directory.systemTemp;
      final fileName = 'securevault_export_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(content);
      return file;
    } catch (e) {
      throw Exception('Export failed: $e');
    }
  }

  /// Share exported file
  Future<void> shareExportedFile(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: 'SecureVault Password Export');
  }

  /// Import from CSV format
  Future<ImportResult> _importFromCSV(String content) async {
    final accounts = <AccountModel>[];
    final errors = <String>[];
    int successCount = 0;
    int errorCount = 0;

    try {
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(content);
      
      // Skip header row if present
      final dataRows = csvData.length > 1 && _isHeaderRow(csvData[0]) ? csvData.skip(1) : csvData;

      for (int i = 0; i < dataRows.length; i++) {
        try {
          final row = dataRows.elementAt(i);
          if (row.length >= 3) {
            final account = AccountModel(
              id: 0,
              accountName: row[0]?.toString() ?? '',
              email: row[1]?.toString() ?? '',
              website: row.length > 3 ? row[3]?.toString() ?? '' : '',
              username: row[1]?.toString() ?? '',
              password: row[2]?.toString() ?? '',
              passwords: [],
            );
            accounts.add(account);
            successCount++;
          } else {
            errors.add('Row ${i + 1}: Insufficient data (minimum: name, username, password)');
            errorCount++;
          }
        } catch (e) {
          errors.add('Row ${i + 1}: $e');
          errorCount++;
        }
      }
    } catch (e) {
      errors.add('CSV parsing error: $e');
      errorCount++;
    }

    return ImportResult(
      accounts: accounts,
      errors: errors,
      successCount: successCount,
      errorCount: errorCount,
    );
  }

  /// Import from JSON format
  Future<ImportResult> _importFromJSON(String content) async {
    final accounts = <AccountModel>[];
    final errors = <String>[];
    int successCount = 0;
    int errorCount = 0;

    try {
      final jsonData = jsonDecode(content);
      final List<dynamic> accountsData = jsonData is List ? jsonData : jsonData['accounts'] ?? [];

      for (int i = 0; i < accountsData.length; i++) {
        try {
          final accountData = accountsData[i];
          final account = AccountModel(
            id: 0,
            accountName: accountData['name'] ?? accountData['accountName'] ?? '',
            email: accountData['email'] ?? '',
            website: accountData['website'] ?? accountData['uri'] ?? accountData['url'] ?? '',
            username: accountData['username'] ?? accountData['login'] ?? '',
            password: accountData['password'] ?? '',
            passwords: [],
          );
          accounts.add(account);
          successCount++;
        } catch (e) {
          errors.add('Account ${i + 1}: $e');
          errorCount++;
        }
      }
    } catch (e) {
      errors.add('JSON parsing error: $e');
      errorCount++;
    }

    return ImportResult(
      accounts: accounts,
      errors: errors,
      successCount: successCount,
      errorCount: errorCount,
    );
  }

  /// Import from Chrome passwords export
  Future<ImportResult> _importFromChrome(String content) async {
    // Chrome exports in CSV format with specific columns
    final lines = content.split('\n');
    if (lines.isEmpty) {
      return const ImportResult(accounts: [], errors: ['Empty file'], successCount: 0, errorCount: 1);
    }

    final accounts = <AccountModel>[];
    final errors = <String>[];
    int successCount = 0;
    int errorCount = 0;

    // Skip header: name,url,username,password
    for (int i = 1; i < lines.length; i++) {
      try {
        final parts = lines[i].split(',');
        if (parts.length >= 4) {
          final account = AccountModel(
            id: 0,
            accountName: parts[0].replaceAll('"', ''),
            email: parts[1].replaceAll('"', ''),
            website: parts[1].replaceAll('"', ''),
            username: parts[2].replaceAll('"', ''),
            password: parts[3].replaceAll('"', ''),
            passwords: [],
          );
          accounts.add(account);
          successCount++;
        }
      } catch (e) {
        errors.add('Line ${i + 1}: $e');
        errorCount++;
      }
    }

    return ImportResult(
      accounts: accounts,
      errors: errors,
      successCount: successCount,
      errorCount: errorCount,
    );
  }

  /// Import from Firefox passwords export
  Future<ImportResult> _importFromFirefox(String content) async {
    return await _importFromCSV(content); // Firefox uses CSV format
  }

  /// Import from Safari passwords export
  Future<ImportResult> _importFromSafari(String content) async {
    return await _importFromCSV(content); // Safari uses CSV format
  }

  /// Import from Bitwarden export
  Future<ImportResult> _importFromBitwarden(String content) async {
    final accounts = <AccountModel>[];
    final errors = <String>[];
    int successCount = 0;
    int errorCount = 0;

    try {
      final jsonData = jsonDecode(content);
      final List<dynamic> items = jsonData['items'] ?? [];

      for (int i = 0; i < items.length; i++) {
        try {
          final item = items[i];
          if (item['type'] == 1) { // Login type
            final login = item['login'];
            final account = AccountModel(
              id: 0,
              accountName: item['name'] ?? '',
              email: login['username'] ?? '',
              website: login['uris']?.isNotEmpty == true ? login['uris'][0]['uri'] ?? '' : '',
              username: login['username'] ?? '',
              password: login['password'] ?? '',
              passwords: [],
            );
            accounts.add(account);
            successCount++;
          }
        } catch (e) {
          errors.add('Item ${i + 1}: $e');
          errorCount++;
        }
      }
    } catch (e) {
      errors.add('Bitwarden parsing error: $e');
      errorCount++;
    }

    return ImportResult(
      accounts: accounts,
      errors: errors,
      successCount: successCount,
      errorCount: errorCount,
    );
  }

  /// Import from LastPass export
  Future<ImportResult> _importFromLastPass(String content) async {
    return await _importFromCSV(content); // LastPass uses CSV format
  }

  /// Import from 1Password export
  Future<ImportResult> _importFromOnePassword(String content) async {
    return await _importFromCSV(content); // 1Password uses CSV format
  }

  /// Export to CSV format
  String _exportToCSV(List<AccountModel> accounts) {
    final List<List<String>> csvData = [
      ['Name', 'Username', 'Password', 'Website', 'Notes', 'Category', 'Favorite']
    ];

    for (final account in accounts) {
      csvData.add([
        account.accountName,
        account.username,
        account.password,
        account.website,
        account.notes,
        account.category,
        account.isFavorite.toString(),
      ]);
    }

    return const ListToCsvConverter().convert(csvData);
  }

  /// Export to JSON format
  String _exportToJSON(List<AccountModel> accounts) {
    final exportData = {
      'version': '1.0.0',
      'exported': DateTime.now().toIso8601String(),
      'source': 'SecureVault',
      'accounts': accounts.map((account) => {
        'name': account.accountName,
        'username': account.username,
        'password': account.password,
        'website': account.website,
        'notes': account.notes,
        'category': account.category,
        'favorite': account.isFavorite,
        'created': account.createdAt.toIso8601String(),
        'updated': account.updatedAt.toIso8601String(),
      }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Export encrypted format
  Future<String> _exportEncrypted(List<AccountModel> accounts, String masterPassword) async {
    final jsonData = _exportToJSON(accounts);
    return await _encryptionService.encryptData(jsonData, masterPassword);
  }

  List<String> _getAllowedExtensions(ImportFormat format) {
    switch (format) {
      case ImportFormat.csv:
      case ImportFormat.chrome:
      case ImportFormat.firefox:
      case ImportFormat.safari:
      case ImportFormat.lastpass:
      case ImportFormat.onepassword:
        return ['csv'];
      case ImportFormat.json:
      case ImportFormat.bitwarden:
        return ['json'];
    }
  }

  bool _isHeaderRow(List<dynamic> row) {
    final firstCell = row[0]?.toString().toLowerCase() ?? '';
    return firstCell.contains('name') || firstCell.contains('title') || firstCell.contains('account');
  }
}
