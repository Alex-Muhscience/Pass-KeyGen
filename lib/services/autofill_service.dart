import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../models/account_model.dart';

class AutofillCredential {
  final String id;
  final String username;
  final String password;
  final String domain;
  final String appPackage;
  final DateTime lastUsed;

  AutofillCredential({
    required this.id,
    required this.username,
    required this.password,
    required this.domain,
    required this.appPackage,
    required this.lastUsed,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'password': password,
    'domain': domain,
    'appPackage': appPackage,
    'lastUsed': lastUsed.toIso8601String(),
  };

  factory AutofillCredential.fromJson(Map<String, dynamic> json) => AutofillCredential(
    id: json['id'],
    username: json['username'],
    password: json['password'],
    domain: json['domain'],
    appPackage: json['appPackage'],
    lastUsed: DateTime.parse(json['lastUsed']),
  );
}

class BrowserIntegration {
  final String browserId;
  final String browserName;
  final String extensionId;
  final bool isInstalled;
  final String version;

  BrowserIntegration({
    required this.browserId,
    required this.browserName,
    required this.extensionId,
    required this.isInstalled,
    required this.version,
  });
}

class AutofillService {
  static const _storage = FlutterSecureStorage();
  static const String _autofillEnabledKey = 'autofill_enabled';
  static const String _autofillCredentialsKey = 'autofill_credentials';
  static const String _autofillSettingsKey = 'autofill_settings';
  static const String _browserIntegrationsKey = 'browser_integrations';

  // Auto-fill Configuration
  static Future<bool> isAutofillEnabled() async {
    try {
      final enabled = await _storage.read(key: _autofillEnabledKey);
      return enabled == 'true';
    } catch (e) {
      debugPrint('Error checking autofill status: $e');
      return false;
    }
  }

  static Future<void> setAutofillEnabled(bool enabled) async {
    try {
      await _storage.write(key: _autofillEnabledKey, value: enabled.toString());
    } catch (e) {
      debugPrint('Error setting autofill status: $e');
    }
  }

  static Future<Map<String, dynamic>> getAutofillSettings() async {
    try {
      final settingsJson = await _storage.read(key: _autofillSettingsKey);
      if (settingsJson != null) {
        return Map<String, dynamic>.from(jsonDecode(settingsJson));
      }
    } catch (e) {
      debugPrint('Error loading autofill settings: $e');
    }
    
    // Default settings
    return {
      'autoSubmit': false,
      'showNotifications': true,
      'matchSubdomains': true,
      'requireBiometric': false,
      'autoSave': true,
      'fillOnFocus': true,
    };
  }

  static Future<void> updateAutofillSettings(Map<String, dynamic> settings) async {
    try {
      final settingsJson = jsonEncode(settings);
      await _storage.write(key: _autofillSettingsKey, value: settingsJson);
    } catch (e) {
      debugPrint('Error saving autofill settings: $e');
    }
  }

  // Credential Management
  static Future<List<AutofillCredential>> getAutofillCredentials() async {
    try {
      final credentialsJson = await _storage.read(key: _autofillCredentialsKey);
      if (credentialsJson != null) {
        final List<dynamic> credentialsList = jsonDecode(credentialsJson);
        return credentialsList.map((json) => AutofillCredential.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading autofill credentials: $e');
    }
    return [];
  }

  static Future<void> saveAutofillCredential(AutofillCredential credential) async {
    try {
      final credentials = await getAutofillCredentials();
      
      // Remove existing credential for same domain/app
      credentials.removeWhere((c) => 
        c.domain == credential.domain && 
        c.appPackage == credential.appPackage &&
        c.username == credential.username
      );
      
      credentials.add(credential);
      
      final credentialsJson = jsonEncode(credentials.map((c) => c.toJson()).toList());
      await _storage.write(key: _autofillCredentialsKey, value: credentialsJson);
    } catch (e) {
      debugPrint('Error saving autofill credential: $e');
    }
  }

  static Future<List<AutofillCredential>> findCredentialsForDomain(String domain) async {
    final credentials = await getAutofillCredentials();
    final settings = await getAutofillSettings();
    final matchSubdomains = settings['matchSubdomains'] ?? true;
    
    return credentials.where((credential) {
      if (matchSubdomains) {
        return _domainMatches(credential.domain, domain);
      } else {
        return credential.domain.toLowerCase() == domain.toLowerCase();
      }
    }).toList()
      ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  }

  static Future<List<AutofillCredential>> findCredentialsForApp(String packageName) async {
    final credentials = await getAutofillCredentials();
    return credentials.where((credential) => 
      credential.appPackage == packageName
    ).toList()
      ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  }

  static Future<void> updateCredentialLastUsed(String credentialId) async {
    try {
      final credentials = await getAutofillCredentials();
      final index = credentials.indexWhere((c) => c.id == credentialId);
      
      if (index != -1) {
        final updatedCredential = AutofillCredential(
          id: credentials[index].id,
          username: credentials[index].username,
          password: credentials[index].password,
          domain: credentials[index].domain,
          appPackage: credentials[index].appPackage,
          lastUsed: DateTime.now(),
        );
        
        credentials[index] = updatedCredential;
        
        final credentialsJson = jsonEncode(credentials.map((c) => c.toJson()).toList());
        await _storage.write(key: _autofillCredentialsKey, value: credentialsJson);
      }
    } catch (e) {
      debugPrint('Error updating credential last used: $e');
    }
  }

  // Browser Integration
  static Future<List<BrowserIntegration>> getSupportedBrowsers() async {
    return [
      BrowserIntegration(
        browserId: 'chrome',
        browserName: 'Google Chrome',
        extensionId: 'securevault-chrome-extension',
        isInstalled: await _isBrowserExtensionInstalled('chrome'),
        version: '1.0.0',
      ),
      BrowserIntegration(
        browserId: 'firefox',
        browserName: 'Mozilla Firefox',
        extensionId: 'securevault-firefox-addon',
        isInstalled: await _isBrowserExtensionInstalled('firefox'),
        version: '1.0.0',
      ),
      BrowserIntegration(
        browserId: 'edge',
        browserName: 'Microsoft Edge',
        extensionId: 'securevault-edge-extension',
        isInstalled: await _isBrowserExtensionInstalled('edge'),
        version: '1.0.0',
      ),
      BrowserIntegration(
        browserId: 'safari',
        browserName: 'Safari',
        extensionId: 'securevault-safari-extension',
        isInstalled: await _isBrowserExtensionInstalled('safari'),
        version: '1.0.0',
      ),
    ];
  }

  static Future<Map<String, bool>> getBrowserIntegrationSettings() async {
    try {
      final settingsJson = await _storage.read(key: _browserIntegrationsKey);
      if (settingsJson != null) {
        final Map<String, dynamic> settings = jsonDecode(settingsJson);
        return settings.map((key, value) => MapEntry(key, value as bool));
      }
    } catch (e) {
      debugPrint('Error loading browser integration settings: $e');
    }
    
    // Default settings - all browsers disabled by default
    return {
      'chrome': false,
      'firefox': false,
      'edge': false,
      'safari': false,
    };
  }

  static Future<void> updateBrowserIntegrationSettings(Map<String, bool> settings) async {
    try {
      final settingsJson = jsonEncode(settings);
      await _storage.write(key: _browserIntegrationsKey, value: settingsJson);
    } catch (e) {
      debugPrint('Error saving browser integration settings: $e');
    }
  }

  static Future<bool> _isBrowserExtensionInstalled(String browserId) async {
    // In a real implementation, this would check for actual browser extensions
    // For demo purposes, we'll simulate some installations
    switch (browserId) {
      case 'chrome':
        return true; // Simulate Chrome extension installed
      case 'firefox':
        return false;
      case 'edge':
        return false;
      case 'safari':
        return false;
      default:
        return false;
    }
  }

  static Future<void> installBrowserExtension(String browserId) async {
    final urls = {
      'chrome': 'https://chrome.google.com/webstore/detail/securevault',
      'firefox': 'https://addons.mozilla.org/firefox/addon/securevault',
      'edge': 'https://microsoftedge.microsoft.com/addons/detail/securevault',
      'safari': 'https://apps.apple.com/app/securevault-safari-extension',
    };

    final url = urls[browserId];
    if (url != null) {
      try {
        await launchUrl(Uri.parse(url));
      } catch (e) {
        debugPrint('Error launching browser extension URL: $e');
      }
    }
  }

  // Auto-fill Actions
  static Future<void> fillCredentials(String username, String password) async {
    try {
      // Copy to clipboard as fallback
      await Clipboard.setData(ClipboardData(text: username));
      
      // In a real implementation, this would interact with the system autofill service
      // For now, we'll simulate the action
      debugPrint('Auto-filling credentials for: $username');
      
    } catch (e) {
      debugPrint('Error filling credentials: $e');
    }
  }

  static Future<void> copyToClipboard(String text, {String? label}) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      debugPrint('Copied ${label ?? 'text'} to clipboard');
    } catch (e) {
      debugPrint('Error copying to clipboard: $e');
    }
  }

  // Account Integration
  static Future<void> syncAccountsToAutofill(List<AccountModel> accounts) async {
    try {
      final credentials = <AutofillCredential>[];
      
      for (final account in accounts) {
        if (account.website.isNotEmpty) {
          final domain = _extractDomain(account.website);
          final credential = AutofillCredential(
            id: account.id.toString(),
            username: account.username,
            password: account.password,
            domain: domain,
            appPackage: '', // Web-based
            lastUsed: DateTime.now(),
          );
          credentials.add(credential);
        }
      }
      
      final credentialsJson = jsonEncode(credentials.map((c) => c.toJson()).toList());
      await _storage.write(key: _autofillCredentialsKey, value: credentialsJson);
      
    } catch (e) {
      debugPrint('Error syncing accounts to autofill: $e');
    }
  }

  // Utility Methods
  static String _extractDomain(String url) {
    try {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      final uri = Uri.parse(url);
      return uri.host.toLowerCase();
    } catch (e) {
      return url.toLowerCase();
    }
  }

  static bool _domainMatches(String credentialDomain, String targetDomain) {
    final credDomain = credentialDomain.toLowerCase();
    final targDomain = targetDomain.toLowerCase();
    
    // Exact match
    if (credDomain == targDomain) return true;
    
    // Subdomain match
    if (targDomain.endsWith('.$credDomain') || credDomain.endsWith('.$targDomain')) {
      return true;
    }
    
    return false;
  }

  // Statistics and Analytics
  static Future<Map<String, dynamic>> getAutofillStats() async {
    try {
      final credentials = await getAutofillCredentials();
      final now = DateTime.now();
      
      final recentlyUsed = credentials.where((c) => 
        now.difference(c.lastUsed).inDays <= 30
      ).length;
      
      final domainCount = credentials.map((c) => c.domain).toSet().length;
      
      return {
        'totalCredentials': credentials.length,
        'recentlyUsed': recentlyUsed,
        'uniqueDomains': domainCount,
        'lastSync': now.toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error getting autofill stats: $e');
      return {};
    }
  }

  // Security Features
  static Future<bool> requiresBiometricForAutofill() async {
    final settings = await getAutofillSettings();
    return settings['requireBiometric'] ?? false;
  }

  static Future<void> clearAutofillData() async {
    try {
      await _storage.delete(key: _autofillCredentialsKey);
      await _storage.delete(key: _autofillSettingsKey);
    } catch (e) {
      debugPrint('Error clearing autofill data: $e');
    }
  }
}
