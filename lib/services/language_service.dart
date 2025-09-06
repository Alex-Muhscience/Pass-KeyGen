import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageService {
  static const _storage = FlutterSecureStorage();
  static const String _languageKey = 'selected_language';
  
  // Supported languages with their locale codes and display names
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {'name': 'English', 'nativeName': 'English'},
    'es': {'name': 'Spanish', 'nativeName': 'Español'},
    'fr': {'name': 'French', 'nativeName': 'Français'},
    'de': {'name': 'German', 'nativeName': 'Deutsch'},
    'it': {'name': 'Italian', 'nativeName': 'Italiano'},
    'pt': {'name': 'Portuguese', 'nativeName': 'Português'},
    'ru': {'name': 'Russian', 'nativeName': 'Русский'},
    'zh': {'name': 'Chinese', 'nativeName': '中文'},
    'ja': {'name': 'Japanese', 'nativeName': '日本語'},
    'ko': {'name': 'Korean', 'nativeName': '한국어'},
    'ar': {'name': 'Arabic', 'nativeName': 'العربية'},
    'hi': {'name': 'Hindi', 'nativeName': 'हिन्दी'},
  };
  
  // Get current saved language or system default
  static Future<Locale> getCurrentLocale() async {
    try {
      final savedLanguage = await _storage.read(key: _languageKey);
      if (savedLanguage != null && supportedLanguages.containsKey(savedLanguage)) {
        return Locale(savedLanguage);
      }
    } catch (e) {
      debugPrint('Error reading saved language: $e');
    }
    
    // Return system default or English as fallback
    return const Locale('en');
  }
  
  // Save selected language
  static Future<void> setLanguage(String languageCode) async {
    try {
      if (supportedLanguages.containsKey(languageCode)) {
        await _storage.write(key: _languageKey, value: languageCode);
      }
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }
  
  // Get language display name
  static String getLanguageName(String languageCode) {
    return supportedLanguages[languageCode]?['name'] ?? 'Unknown';
  }
  
  // Get native language name
  static String getNativeLanguageName(String languageCode) {
    return supportedLanguages[languageCode]?['nativeName'] ?? 'Unknown';
  }
  
  // Check if language is RTL (Right-to-Left)
  static bool isRTL(String languageCode) {
    return ['ar', 'he', 'fa', 'ur'].contains(languageCode);
  }
  
  // Get list of supported locales
  static List<Locale> getSupportedLocales() {
    return supportedLanguages.keys.map((code) => Locale(code)).toList();
  }
  
  // Get language options for UI
  static List<Map<String, String>> getLanguageOptions() {
    return supportedLanguages.entries.map((entry) => {
      'code': entry.key,
      'name': entry.value['name']!,
      'nativeName': entry.value['nativeName']!,
    }).toList();
  }
  
  // Detect system language and return best match
  static String detectSystemLanguage() {
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    
    for (final locale in systemLocales) {
      if (supportedLanguages.containsKey(locale.languageCode)) {
        return locale.languageCode;
      }
    }
    
    // Default to English if no match found
    return 'en';
  }
  
  // Initialize language service
  static Future<void> initialize() async {
    final currentLocale = await getCurrentLocale();
    debugPrint('Language service initialized with locale: ${currentLocale.languageCode}');
  }
}
