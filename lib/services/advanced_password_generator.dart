import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart';

enum PasswordStrength { weak, fair, good, strong, veryStrong }

class PasswordGeneratorOptions {
  final int length;
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSymbols;
  final bool excludeSimilar;
  final bool excludeAmbiguous;
  final String customCharacters;
  final List<String> excludeWords;

  const PasswordGeneratorOptions({
    this.length = 16,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
    this.excludeSimilar = false,
    this.excludeAmbiguous = false,
    this.customCharacters = '',
    this.excludeWords = const [],
  });
}

class PasswordAnalysis {
  final PasswordStrength strength;
  final int score;
  final List<String> suggestions;
  final double entropy;
  final bool isCompromised;

  const PasswordAnalysis({
    required this.strength,
    required this.score,
    required this.suggestions,
    required this.entropy,
    this.isCompromised = false,
  });
}

class AdvancedPasswordGenerator {
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _numbers = '0123456789';
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  static const String _similarChars = 'il1Lo0O';
  static const String _ambiguousChars = '{}[]()/\\\'"`~,;.<>';

  static final List<String> _commonPasswords = [
    'password', '123456', 'password123', 'admin', 'qwerty',
    'letmein', 'welcome', 'monkey', '1234567890', 'abc123'
  ];

  late SecureRandom _secureRandom;

  AdvancedPasswordGenerator() {
    _initializeSecureRandom();
  }

  void _initializeSecureRandom() {
    _secureRandom = SecureRandom('Fortuna');
    final seed = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      seed[i] = Random.secure().nextInt(256);
    }
    _secureRandom.seed(KeyParameter(seed));
  }

  /// Generate a secure password with given options
  String generatePassword(PasswordGeneratorOptions options) {
    String charset = _buildCharset(options);
    
    if (charset.isEmpty) {
      throw ArgumentError('No character set available for password generation');
    }

    String password;
    int attempts = 0;
    const maxAttempts = 100;

    do {
      password = _generateRandomPassword(charset, options.length);
      attempts++;
    } while (!_isValidPassword(password, options) && attempts < maxAttempts);

    if (attempts >= maxAttempts) {
      throw Exception('Unable to generate valid password after $maxAttempts attempts');
    }

    return password;
  }

  /// Generate multiple password options
  List<String> generatePasswordOptions(PasswordGeneratorOptions options, {int count = 5}) {
    final passwords = <String>[];
    for (int i = 0; i < count; i++) {
      passwords.add(generatePassword(options));
    }
    return passwords;
  }

  /// Generate passphrase using word list
  String generatePassphrase({
    int wordCount = 4,
    String separator = '-',
    bool includeNumbers = false,
    bool capitalizeWords = false,
  }) {
    final words = _getRandomWords(wordCount);
    
    if (capitalizeWords) {
      for (int i = 0; i < words.length; i++) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    String passphrase = words.join(separator);
    
    if (includeNumbers) {
      passphrase += separator + _generateRandomNumber(2, 4);
    }

    return passphrase;
  }

  /// Analyze password strength and security
  PasswordAnalysis analyzePassword(String password) {
    int score = 0;
    final suggestions = <String>[];
    
    // Length check
    if (password.length >= 12) {
      score += 25;
    } else if (password.length >= 8) {
      score += 15;
    } else {
      suggestions.add('Use at least 12 characters for better security');
    }

    // Character variety checks
    if (password.contains(RegExp(r'[A-Z]'))) {
      score += 15;
    } else {
      suggestions.add('Include uppercase letters');
    }

    if (password.contains(RegExp(r'[a-z]'))) {
      score += 15;
    } else {
      suggestions.add('Include lowercase letters');
    }

    if (password.contains(RegExp(r'[0-9]'))) {
      score += 15;
    } else {
      suggestions.add('Include numbers');
    }

    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score += 20;
    } else {
      suggestions.add('Include special characters');
    }

    // Pattern checks
    if (!_hasRepeatingCharacters(password)) {
      score += 10;
    } else {
      suggestions.add('Avoid repeating characters');
    }

    // Common password check
    final isCompromised = _isCommonPassword(password);
    if (isCompromised) {
      score -= 50;
      suggestions.add('This password is commonly used and compromised');
    }

    // Calculate entropy
    final entropy = _calculateEntropy(password);
    
    // Determine strength
    PasswordStrength strength;
    if (score >= 90) {
      strength = PasswordStrength.veryStrong;
    } else if (score >= 70) {
      strength = PasswordStrength.strong;
    } else if (score >= 50) {
      strength = PasswordStrength.good;
    } else if (score >= 30) {
      strength = PasswordStrength.fair;
    } else {
      strength = PasswordStrength.weak;
    }

    return PasswordAnalysis(
      strength: strength,
      score: score.clamp(0, 100),
      suggestions: suggestions,
      entropy: entropy,
      isCompromised: isCompromised,
    );
  }

  String _buildCharset(PasswordGeneratorOptions options) {
    String charset = '';
    
    if (options.includeUppercase) charset += _uppercase;
    if (options.includeLowercase) charset += _lowercase;
    if (options.includeNumbers) charset += _numbers;
    if (options.includeSymbols) charset += _symbols;
    
    if (options.customCharacters.isNotEmpty) {
      charset += options.customCharacters;
    }

    if (options.excludeSimilar) {
      for (final char in _similarChars.split('')) {
        charset = charset.replaceAll(char, '');
      }
    }

    if (options.excludeAmbiguous) {
      for (final char in _ambiguousChars.split('')) {
        charset = charset.replaceAll(char, '');
      }
    }

    return charset;
  }

  String _generateRandomPassword(String charset, int length) {
    final password = StringBuffer();
    for (int i = 0; i < length; i++) {
      final randomIndex = Random.secure().nextInt(charset.length);
      password.write(charset[randomIndex]);
    }
    return password.toString();
  }

  bool _isValidPassword(String password, PasswordGeneratorOptions options) {
    // Check for excluded words
    for (final word in options.excludeWords) {
      if (password.toLowerCase().contains(word.toLowerCase())) {
        return false;
      }
    }

    // Ensure at least one character from each required set
    if (options.includeUppercase && !password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (options.includeLowercase && !password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (options.includeNumbers && !password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    if (options.includeSymbols && !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    return true;
  }

  List<String> _getRandomWords(int count) {
    final wordList = [
      'apple', 'brave', 'cloud', 'dance', 'eagle', 'flame', 'grace', 'happy',
      'island', 'jungle', 'knight', 'light', 'magic', 'noble', 'ocean', 'peace',
      'quest', 'river', 'storm', 'trust', 'unity', 'voice', 'wonder', 'youth',
      'zenith', 'bright', 'cosmic', 'dream', 'energy', 'forest', 'golden', 'harmony'
    ];
    
    final selectedWords = <String>[];
    for (int i = 0; i < count; i++) {
      final randomIndex = Random.secure().nextInt(wordList.length);
      selectedWords.add(wordList[randomIndex]);
    }
    return selectedWords;
  }

  String _generateRandomNumber(int minDigits, int maxDigits) {
    final digits = minDigits + Random.secure().nextInt(maxDigits - minDigits + 1);
    final number = StringBuffer();
    for (int i = 0; i < digits; i++) {
      number.write(Random.secure().nextInt(10));
    }
    return number.toString();
  }

  bool _hasRepeatingCharacters(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      if (password[i] == password[i + 1] && password[i + 1] == password[i + 2]) {
        return true;
      }
    }
    return false;
  }

  bool _isCommonPassword(String password) {
    return _commonPasswords.contains(password.toLowerCase());
  }

  double _calculateEntropy(String password) {
    final charset = <String>{};
    for (final char in password.split('')) {
      charset.add(char);
    }
    
    final charsetSize = charset.length;
    return password.length * (log(charsetSize) / log(2));
  }

  double log(num x) => math.log(x) / math.ln10;
}
