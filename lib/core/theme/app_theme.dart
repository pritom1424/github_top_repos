import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF2F4F8),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.light,
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 2,
        backgroundColor: Color(0xFFF2F4F8),
        foregroundColor: Color(0xFF111827),
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
        ),
        iconTheme: IconThemeData(color: Color(0xFF111827)),
      ),

      cardTheme: CardThemeData(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 0.6,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF60A5FA),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF020617),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
