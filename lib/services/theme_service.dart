import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting theme preference.
/// Equivalent to the web project's localStorage theme handling.
class ThemeService {
  static const String _themeKey = 'theme_mode';

  /// Load saved theme preference.
  /// Returns true for dark mode, false for light mode.
  static Future<bool> loadIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? true; // Default to dark mode on mobile
  }

  /// Save theme preference.
  static Future<void> saveIsDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}
