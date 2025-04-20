import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const _keyUserName = 'userName';

  /// Retrieves the saved username from SharedPreferences, or returns 'Guest' if not found
  Future<String> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserName) ?? 'Guest';
    } catch (e) {
      // Handle errors (e.g., log them)
      return 'Guest'; // Fallback value
    }
  }

  /// Saves the provided username to SharedPreferences
  Future<void> setUserName(String userName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserName, userName);
    } catch (e) {
      // Handle errors (e.g., log them)
    }
  }
}
