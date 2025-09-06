import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import '../models/account_model.dart';
import 'advanced_password_generator.dart';
import 'breach_detection_service.dart';

enum SecurityIssueType { 
  weakPassword, 
  reusedPassword, 
  oldPassword, 
  breachedPassword, 
  noTwoFactor,
  insecureWebsite,
  duplicateAccount
}

enum SecurityRiskLevel { low, medium, high, critical }

class SecurityIssue {
  final String id;
  final SecurityIssueType type;
  final SecurityRiskLevel riskLevel;
  final String title;
  final String description;
  final List<String> recommendations;
  final List<String> affectedAccounts;
  final DateTime detectedAt;

  const SecurityIssue({
    required this.id,
    required this.type,
    required this.riskLevel,
    required this.title,
    required this.description,
    required this.recommendations,
    required this.affectedAccounts,
    required this.detectedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'riskLevel': riskLevel.toString(),
    'title': title,
    'description': description,
    'recommendations': recommendations,
    'affectedAccounts': affectedAccounts,
    'detectedAt': detectedAt.toIso8601String(),
  };
}

class SecurityReport {
  final DateTime generatedAt;
  final int totalAccounts;
  final int securityScore;
  final List<SecurityIssue> issues;
  final Map<SecurityRiskLevel, int> riskBreakdown;
  final Map<String, dynamic> statistics;

  const SecurityReport({
    required this.generatedAt,
    required this.totalAccounts,
    required this.securityScore,
    required this.issues,
    required this.riskBreakdown,
    required this.statistics,
  });
}

class SecurityAuditService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static const String _lastAuditKey = 'last_security_audit';
  static const String _auditHistoryKey = 'audit_history';

  final AdvancedPasswordGenerator _passwordGenerator;
  final BreachDetectionService _breachService;

  SecurityAuditService(this._passwordGenerator, this._breachService);

  /// Perform comprehensive security audit
  Future<SecurityReport> performSecurityAudit(List<AccountModel> accounts) async {
    final issues = <SecurityIssue>[];
    final statistics = <String, dynamic>{};
    
    // Analyze password strength
    final weakPasswords = await _analyzePasswordStrength(accounts);
    issues.addAll(weakPasswords);
    
    // Check for password reuse
    final reusedPasswords = _analyzePasswordReuse(accounts);
    issues.addAll(reusedPasswords);
    
    // Check password age
    final oldPasswords = _analyzePasswordAge(accounts);
    issues.addAll(oldPasswords);
    
    // Check for breached passwords
    final breachedPasswords = await _analyzeBreachedPasswords(accounts);
    issues.addAll(breachedPasswords);
    
    // Check for duplicate accounts
    final duplicateAccounts = _analyzeDuplicateAccounts(accounts);
    issues.addAll(duplicateAccounts);
    
    // Check for insecure websites
    final insecureWebsites = _analyzeInsecureWebsites(accounts);
    issues.addAll(insecureWebsites);
    
    // Calculate security score
    final securityScore = _calculateSecurityScore(accounts, issues);
    
    // Generate risk breakdown
    final riskBreakdown = _generateRiskBreakdown(issues);
    
    // Generate statistics
    statistics.addAll(_generateStatistics(accounts, issues));
    
    final report = SecurityReport(
      generatedAt: DateTime.now(),
      totalAccounts: accounts.length,
      securityScore: securityScore,
      issues: issues,
      riskBreakdown: riskBreakdown,
      statistics: statistics,
    );
    
    // Save audit history
    await _saveAuditHistory(report);
    
    return report;
  }

  /// Analyze password strength for all accounts
  Future<List<SecurityIssue>> _analyzePasswordStrength(List<AccountModel> accounts) async {
    final issues = <SecurityIssue>[];
    
    for (final account in accounts) {
      final analysis = _passwordGenerator.analyzePassword(account.password);
      
      if (analysis.strength == PasswordStrength.weak || analysis.strength == PasswordStrength.fair) {
        issues.add(SecurityIssue(
          id: _generateIssueId(),
          type: SecurityIssueType.weakPassword,
          riskLevel: analysis.strength == PasswordStrength.weak 
              ? SecurityRiskLevel.high 
              : SecurityRiskLevel.medium,
          title: 'Weak Password Detected',
          description: 'The password for ${account.accountName} is weak and easily guessable.',
          recommendations: [
            'Generate a new strong password with at least 12 characters',
            'Include uppercase, lowercase, numbers, and special characters',
            'Avoid common words and patterns',
            ...analysis.suggestions,
          ],
          affectedAccounts: [account.accountName],
          detectedAt: DateTime.now(),
        ));
      }
    }
    
    return issues;
  }

  /// Analyze password reuse across accounts
  List<SecurityIssue> _analyzePasswordReuse(List<AccountModel> accounts) {
    final issues = <SecurityIssue>[];
    final passwordGroups = <String, List<String>>{};
    
    // Group accounts by password
    for (final account in accounts) {
      final passwordHash = sha256.convert(utf8.encode(account.password)).toString();
      passwordGroups.putIfAbsent(passwordHash, () => []).add(account.accountName);
    }
    
    // Find reused passwords
    for (final entry in passwordGroups.entries) {
      if (entry.value.length > 1) {
        issues.add(SecurityIssue(
          id: _generateIssueId(),
          type: SecurityIssueType.reusedPassword,
          riskLevel: entry.value.length > 3 
              ? SecurityRiskLevel.critical 
              : SecurityRiskLevel.high,
          title: 'Password Reuse Detected',
          description: 'The same password is used for ${entry.value.length} different accounts.',
          recommendations: [
            'Generate unique passwords for each account',
            'Use the password generator to create strong, unique passwords',
            'Consider enabling password auto-generation',
          ],
          affectedAccounts: entry.value,
          detectedAt: DateTime.now(),
        ));
      }
    }
    
    return issues;
  }

  /// Analyze password age
  List<SecurityIssue> _analyzePasswordAge(List<AccountModel> accounts) {
    final issues = <SecurityIssue>[];
    final now = DateTime.now();
    
    for (final account in accounts) {
      final daysSinceUpdate = now.difference(account.updatedAt).inDays;
      
      if (daysSinceUpdate > 365) {
        issues.add(SecurityIssue(
          id: _generateIssueId(),
          type: SecurityIssueType.oldPassword,
          riskLevel: daysSinceUpdate > 730 
              ? SecurityRiskLevel.high 
              : SecurityRiskLevel.medium,
          title: 'Old Password Detected',
          description: 'The password for ${account.accountName} hasn\'t been changed in ${(daysSinceUpdate / 365).floor()} year(s).',
          recommendations: [
            'Change your password regularly (every 6-12 months)',
            'Generate a new strong password',
            'Enable notifications for password age reminders',
          ],
          affectedAccounts: [account.accountName],
          detectedAt: DateTime.now(),
        ));
      }
    }
    
    return issues;
  }

  /// Analyze breached passwords
  Future<List<SecurityIssue>> _analyzeBreachedPasswords(List<AccountModel> accounts) async {
    final issues = <SecurityIssue>[];
    
    for (final account in accounts) {
      final breachResult = await _breachService.checkPasswordBreach(account.password);
      
      if (breachResult.isBreached) {
        SecurityRiskLevel riskLevel;
        if (breachResult.riskLevel == 'Critical') {
          riskLevel = SecurityRiskLevel.critical;
        } else if (breachResult.riskLevel == 'High') {
          riskLevel = SecurityRiskLevel.high;
        } else {
          riskLevel = SecurityRiskLevel.medium;
        }
        
        issues.add(SecurityIssue(
          id: _generateIssueId(),
          type: SecurityIssueType.breachedPassword,
          riskLevel: riskLevel,
          title: 'Breached Password Detected',
          description: 'The password for ${account.accountName} has been found in ${breachResult.occurrences} data breaches.',
          recommendations: [
            'Change this password immediately',
            'Generate a new unique password',
            'Enable two-factor authentication if available',
            'Monitor this account for suspicious activity',
          ],
          affectedAccounts: [account.accountName],
          detectedAt: DateTime.now(),
        ));
      }
    }
    
    return issues;
  }

  /// Analyze duplicate accounts
  List<SecurityIssue> _analyzeDuplicateAccounts(List<AccountModel> accounts) {
    final issues = <SecurityIssue>[];
    final websiteGroups = <String, List<String>>{};
    
    // Group accounts by website
    for (final account in accounts) {
      final domain = _extractDomain(account.website);
      if (domain.isNotEmpty) {
        websiteGroups.putIfAbsent(domain, () => []).add(account.accountName);
      }
    }
    
    // Find duplicate accounts
    for (final entry in websiteGroups.entries) {
      if (entry.value.length > 1) {
        issues.add(SecurityIssue(
          id: _generateIssueId(),
          type: SecurityIssueType.duplicateAccount,
          riskLevel: SecurityRiskLevel.low,
          title: 'Duplicate Accounts Detected',
          description: 'Multiple accounts found for ${entry.key}.',
          recommendations: [
            'Review and consolidate duplicate accounts',
            'Keep only the active account',
            'Update account information if needed',
          ],
          affectedAccounts: entry.value,
          detectedAt: DateTime.now(),
        ));
      }
    }
    
    return issues;
  }

  /// Analyze insecure websites (HTTP vs HTTPS)
  List<SecurityIssue> _analyzeInsecureWebsites(List<AccountModel> accounts) {
    final issues = <SecurityIssue>[];
    
    for (final account in accounts) {
      if (account.website.startsWith('http://')) {
        issues.add(SecurityIssue(
          id: _generateIssueId(),
          type: SecurityIssueType.insecureWebsite,
          riskLevel: SecurityRiskLevel.medium,
          title: 'Insecure Website Detected',
          description: 'The website for ${account.accountName} uses HTTP instead of HTTPS.',
          recommendations: [
            'Check if the website supports HTTPS',
            'Update the URL to use HTTPS if available',
            'Be cautious when entering credentials on HTTP sites',
          ],
          affectedAccounts: [account.accountName],
          detectedAt: DateTime.now(),
        ));
      }
    }
    
    return issues;
  }

  /// Calculate overall security score (0-100)
  int _calculateSecurityScore(List<AccountModel> accounts, List<SecurityIssue> issues) {
    if (accounts.isEmpty) return 100;
    
    int score = 100;
    
    // Deduct points for each issue based on severity
    for (final issue in issues) {
      switch (issue.riskLevel) {
        case SecurityRiskLevel.critical:
          score -= 20;
          break;
        case SecurityRiskLevel.high:
          score -= 15;
          break;
        case SecurityRiskLevel.medium:
          score -= 10;
          break;
        case SecurityRiskLevel.low:
          score -= 5;
          break;
      }
    }
    
    return max(0, score);
  }

  /// Generate risk breakdown statistics
  Map<SecurityRiskLevel, int> _generateRiskBreakdown(List<SecurityIssue> issues) {
    final breakdown = <SecurityRiskLevel, int>{
      SecurityRiskLevel.critical: 0,
      SecurityRiskLevel.high: 0,
      SecurityRiskLevel.medium: 0,
      SecurityRiskLevel.low: 0,
    };
    
    for (final issue in issues) {
      breakdown[issue.riskLevel] = (breakdown[issue.riskLevel] ?? 0) + 1;
    }
    
    return breakdown;
  }

  /// Generate detailed statistics
  Map<String, dynamic> _generateStatistics(List<AccountModel> accounts, List<SecurityIssue> issues) {
    final weakPasswords = issues.where((i) => i.type == SecurityIssueType.weakPassword).length;
    final reusedPasswords = issues.where((i) => i.type == SecurityIssueType.reusedPassword).length;
    final breachedPasswords = issues.where((i) => i.type == SecurityIssueType.breachedPassword).length;
    final oldPasswords = issues.where((i) => i.type == SecurityIssueType.oldPassword).length;
    
    return {
      'totalIssues': issues.length,
      'weakPasswords': weakPasswords,
      'reusedPasswords': reusedPasswords,
      'breachedPasswords': breachedPasswords,
      'oldPasswords': oldPasswords,
      'averagePasswordAge': _calculateAveragePasswordAge(accounts),
      'strongPasswordPercentage': _calculateStrongPasswordPercentage(accounts),
    };
  }

  /// Save audit history
  Future<void> _saveAuditHistory(SecurityReport report) async {
    await _storage.write(key: _lastAuditKey, value: DateTime.now().toIso8601String());
    
    // Save simplified history (last 10 audits)
    final historyJson = await _storage.read(key: _auditHistoryKey);
    List<Map<String, dynamic>> history = [];
    
    if (historyJson != null) {
      try {
        history = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
      } catch (e) {
        history = [];
      }
    }
    
    history.insert(0, {
      'date': report.generatedAt.toIso8601String(),
      'score': report.securityScore,
      'totalIssues': report.issues.length,
      'criticalIssues': report.riskBreakdown[SecurityRiskLevel.critical] ?? 0,
    });
    
    // Keep only last 10 audits
    if (history.length > 10) {
      history = history.take(10).toList();
    }
    
    await _storage.write(key: _auditHistoryKey, value: jsonEncode(history));
  }

  /// Get audit history
  Future<List<Map<String, dynamic>>> getAuditHistory() async {
    final historyJson = await _storage.read(key: _auditHistoryKey);
    if (historyJson == null) return [];
    
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(historyJson));
    } catch (e) {
      return [];
    }
  }

  String _generateIssueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
      return uri.host.toLowerCase();
    } catch (e) {
      return '';
    }
  }

  double _calculateAveragePasswordAge(List<AccountModel> accounts) {
    if (accounts.isEmpty) return 0;
    
    final now = DateTime.now();
    final totalDays = accounts.fold<int>(0, (sum, account) => 
        sum + now.difference(account.updatedAt).inDays);
    
    return totalDays / accounts.length;
  }

  double _calculateStrongPasswordPercentage(List<AccountModel> accounts) {
    if (accounts.isEmpty) return 100;
    
    int strongCount = 0;
    for (final account in accounts) {
      final analysis = _passwordGenerator.analyzePassword(account.password);
      if (analysis.strength == PasswordStrength.strong || 
          analysis.strength == PasswordStrength.veryStrong) {
        strongCount++;
      }
    }
    
    return (strongCount / accounts.length) * 100;
  }
}
