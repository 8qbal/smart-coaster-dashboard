import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// Manages theme state (light/dark mode).
/// Equivalent to the web project's theme toggle with localStorage persistence.
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true; // Default to dark mode on mobile.

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Load saved theme preference.
  Future<void> loadTheme() async {
    _isDarkMode = await ThemeService.loadIsDarkMode();
    notifyListeners();
  }

  /// Toggle between light and dark mode.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await ThemeService.saveIsDarkMode(_isDarkMode);
    notifyListeners();
  }
}
