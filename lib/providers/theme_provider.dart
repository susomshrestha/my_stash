import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // Constructor to load saved theme and listen for system theme changes
  ThemeProvider() {
    _loadTheme();
    _listenToSystemThemeChanges();
  }

  // Load the theme saved in SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('theme');
    if (savedTheme != null) {
      _themeMode = _getThemeMode(savedTheme);
    } else {
      _themeMode = ThemeMode.system; // Default to system theme if not set
    }
    notifyListeners();
  }

  // Save the theme to SharedPreferences
  Future<void> setTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    switch (theme) {
      case ThemeMode.system:
        prefs.setString('theme', 'system');
        break;
      case ThemeMode.light:
        prefs.setString('theme', 'light');
        break;
      case ThemeMode.dark:
        prefs.setString('theme', 'dark');
        break;
    }
    _themeMode = theme;
    notifyListeners();
  }

  // Map string value to ThemeMode
  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Get the current theme based on system or user preference
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return _getPlatformBrightness() == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Get the platform's brightness (light/dark mode)
  Brightness _getPlatformBrightness() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  // Listen to the system theme change
  void _listenToSystemThemeChanges() {
    var dispatcher = SchedulerBinding.instance.platformDispatcher;
    dispatcher.onPlatformBrightnessChanged = () {
      // Only notify if we're using system theme
      if (_themeMode == ThemeMode.system) {
        notifyListeners();
      }
    };
  }
}