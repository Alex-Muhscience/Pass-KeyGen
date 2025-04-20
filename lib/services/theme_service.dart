import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static const _themeKey = 'theme_mode';

  /// Initializes the theme by loading the saved theme mode from SharedPreferences
  Future<void> initializeTheme() async {
    try {
      final themeMode = await loadTheme();
      Get.changeThemeMode(themeMode);
    } catch (e) {
      // Handle errors (e.g., log them)
      Get.changeThemeMode(ThemeMode.light); // Fallback to default theme
    }
  }

  /// Loads the saved theme mode from SharedPreferences
  Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    return ThemeMode.values[themeIndex];
  }

  /// Updates the theme mode in both GetX and SharedPreferences
  Future<void> updateTheme(ThemeMode mode) async {
    try {
      Get.changeThemeMode(mode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
    } catch (e) {
      // Handle errors (e.g., log them)
    }
  }

  /// Retrieves the current theme mode from SharedPreferences
  Future<ThemeMode> getCurrentTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      return ThemeMode.values[themeIndex];
    } catch (e) {
      // Handle errors (e.g., log them)
      return ThemeMode.light; // Fallback to default theme
    }
  }
}
