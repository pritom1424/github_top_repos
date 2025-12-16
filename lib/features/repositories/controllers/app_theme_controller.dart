import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_top_repos/core/storage/local_storage_service.dart';
//import 'package:shared_preferences/shared_preferences.dart';

/// Provider
final appThemeProvider = NotifierProvider<AppThemeNotifier, ThemeMode>(
  AppThemeNotifier.new, //() => AppThemeNotifier()
);

class AppThemeNotifier extends Notifier<ThemeMode> {
  final LocalStorageService _localStorage = LocalStorageService();

  // Initial state
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light; // default until prefs load
  }

  bool get isDarkMode => state == ThemeMode.dark;

  Future<void> _loadTheme() async {
    try {
      final storedMode = await _localStorage.getThemeMode();
      state = storedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      state = ThemeMode.light;
    }
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      final modeString = mode == ThemeMode.dark ? 'dark' : 'light';
      await _localStorage.saveThemeMode(modeString);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Toggle theme
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    _saveTheme(state);
  }

  // Helper for colors
  Color setColor({required Color light, required Color dark}) {
    return isDarkMode ? dark : light;
  }
}
