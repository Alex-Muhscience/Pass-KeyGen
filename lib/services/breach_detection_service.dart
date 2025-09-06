import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BreachInfo {
  final String name;
  final String domain;
  final DateTime breachDate;
  final int pwnCount;
  final List<String> dataClasses;
  final bool isVerified;
  final bool isSensitive;

  const BreachInfo({
    required this.name,
    required this.domain,
    required this.breachDate,
    required this.pwnCount,
    required this.dataClasses,
    required this.isVerified,
    required this.isSensitive,
  });

  factory BreachInfo.fromJson(Map<String, dynamic> json) {
    return BreachInfo(
      name: json['Name'] ?? '',
      domain: json['Domain'] ?? '',
      breachDate: DateTime.parse(json['BreachDate']),
      pwnCount: json['PwnCount'] ?? 0,
      dataClasses: List<String>.from(json['DataClasses'] ?? []),
      isVerified: json['IsVerified'] ?? false,
      isSensitive: json['IsSensitive'] ?? false,
    );
  }
}

class PasswordBreachResult {
  final bool isBreached;
  final int occurrences;
  final String riskLevel;

  const PasswordBreachResult({
    required this.isBreached,
    required this.occurrences,
    required this.riskLevel,
  });
}

class BreachDetectionService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static const String _baseUrl = 'https://api.pwnedpasswords.com';
  static const String _haveibeenpwnedUrl = 'https://haveibeenpwned.com/api/v3';
  static const String _lastCheckKey = 'last_breach_check';
  static const String _breachCacheKey = 'breach_cache';

  /// Check if password has been breached using k-anonymity
  Future<PasswordBreachResult> checkPasswordBreach(String password) async {
    try {
      // Hash the password with SHA-1
      final bytes = utf8.encode(password);
      final digest = sha1.convert(bytes);
      final hash = digest.toString().toUpperCase();
      
      // Use k-anonymity: send only first 5 characters
      final prefix = hash.substring(0, 5);
      final suffix = hash.substring(5);
      
      final response = await http.get(
        Uri.parse('$_baseUrl/range/$prefix'),
        headers: {'User-Agent': 'SecureVault-PasswordManager'},
      );

      if (response.statusCode == 200) {
        final lines = response.body.split('\n');
        
        for (final line in lines) {
          final parts = line.split(':');
          if (parts.length == 2 && parts[0].trim() == suffix) {
            final occurrences = int.parse(parts[1].trim());
            return PasswordBreachResult(
              isBreached: true,
              occurrences: occurrences,
              riskLevel: _getRiskLevel(occurrences),
            );
          }
        }
      }
      
      return const PasswordBreachResult(
        isBreached: false,
        occurrences: 0,
        riskLevel: 'Safe',
      );
    } catch (e) {
      // Return safe result if API is unavailable
      return const PasswordBreachResult(
        isBreached: false,
        occurrences: 0,
        riskLevel: 'Unknown',
      );
    }
  }

  /// Check if email has been involved in breaches
  Future<List<BreachInfo>> checkEmailBreaches(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$_haveibeenpwnedUrl/breachedaccount/$email'),
        headers: {
          'User-Agent': 'SecureVault-PasswordManager',
          'hibp-api-key': 'YOUR_API_KEY_HERE', // User needs to provide this
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> breachData = jsonDecode(response.body);
        return breachData.map((breach) => BreachInfo.fromJson(breach)).toList();
      } else if (response.statusCode == 404) {
        // No breaches found
        return [];
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Batch check multiple passwords
  Future<Map<String, PasswordBreachResult>> checkMultiplePasswords(List<String> passwords) async {
    final results = <String, PasswordBreachResult>{};
    
    for (final password in passwords) {
      results[password] = await checkPasswordBreach(password);
      // Add small delay to be respectful to the API
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    return results;
  }

  /// Get breach statistics for user's passwords
  Future<Map<String, dynamic>> getBreachStatistics(List<String> passwords) async {
    final results = await checkMultiplePasswords(passwords);
    
    int breachedCount = 0;
    int totalOccurrences = 0;
    int highRiskCount = 0;
    
    for (final result in results.values) {
      if (result.isBreached) {
        breachedCount++;
        totalOccurrences += result.occurrences;
        
        if (result.riskLevel == 'Critical' || result.riskLevel == 'High') {
          highRiskCount++;
        }
      }
    }
    
    return {
      'totalPasswords': passwords.length,
      'breachedPasswords': breachedCount,
      'safePasswords': passwords.length - breachedCount,
      'totalOccurrences': totalOccurrences,
      'highRiskPasswords': highRiskCount,
      'breachPercentage': passwords.isEmpty ? 0.0 : (breachedCount / passwords.length) * 100,
    };
  }

  /// Check if it's time for periodic breach check
  Future<bool> shouldPerformPeriodicCheck() async {
    final lastCheckString = await _storage.read(key: _lastCheckKey);
    if (lastCheckString == null) return true;
    
    final lastCheck = DateTime.parse(lastCheckString);
    final now = DateTime.now();
    
    // Check every 7 days
    return now.difference(lastCheck).inDays >= 7;
  }

  /// Update last check timestamp
  Future<void> updateLastCheckTime() async {
    await _storage.write(key: _lastCheckKey, value: DateTime.now().toIso8601String());
  }

  /// Cache breach results to avoid repeated API calls
  Future<void> cacheBreachResults(Map<String, PasswordBreachResult> results) async {
    final cacheData = <String, Map<String, dynamic>>{};
    
    for (final entry in results.entries) {
      cacheData[_hashForCache(entry.key)] = {
        'isBreached': entry.value.isBreached,
        'occurrences': entry.value.occurrences,
        'riskLevel': entry.value.riskLevel,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
    
    await _storage.write(key: _breachCacheKey, value: jsonEncode(cacheData));
  }

  /// Get cached breach result
  Future<PasswordBreachResult?> getCachedResult(String password) async {
    try {
      final cacheJson = await _storage.read(key: _breachCacheKey);
      if (cacheJson == null) return null;
      
      final cache = Map<String, dynamic>.from(jsonDecode(cacheJson));
      final hashedPassword = _hashForCache(password);
      final cachedData = cache[hashedPassword];
      
      if (cachedData != null) {
        final timestamp = DateTime.parse(cachedData['timestamp']);
        // Cache valid for 24 hours
        if (DateTime.now().difference(timestamp).inHours < 24) {
          return PasswordBreachResult(
            isBreached: cachedData['isBreached'],
            occurrences: cachedData['occurrences'],
            riskLevel: cachedData['riskLevel'],
          );
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Generate security recommendations based on breach data
  List<String> generateSecurityRecommendations(Map<String, PasswordBreachResult> results) {
    final recommendations = <String>[];
    
    int breachedCount = 0;
    int highRiskCount = 0;
    
    for (final result in results.values) {
      if (result.isBreached) {
        breachedCount++;
        if (result.riskLevel == 'Critical' || result.riskLevel == 'High') {
          highRiskCount++;
        }
      }
    }
    
    if (breachedCount > 0) {
      recommendations.add('Change $breachedCount compromised password${breachedCount > 1 ? 's' : ''} immediately');
    }
    
    if (highRiskCount > 0) {
      recommendations.add('$highRiskCount password${highRiskCount > 1 ? 's' : ''} found in major breaches - prioritize changing these');
    }
    
    if (breachedCount > results.length * 0.3) {
      recommendations.add('Consider using unique passwords for each account');
      recommendations.add('Enable two-factor authentication where possible');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Great! No compromised passwords detected');
      recommendations.add('Continue using strong, unique passwords');
    }
    
    return recommendations;
  }

  String _getRiskLevel(int occurrences) {
    if (occurrences > 100000) return 'Critical';
    if (occurrences > 10000) return 'High';
    if (occurrences > 1000) return 'Medium';
    if (occurrences > 0) return 'Low';
    return 'Safe';
  }

  String _hashForCache(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
