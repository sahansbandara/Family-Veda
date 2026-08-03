// Shared clinical-calm design tokens from design.md.
import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const primary = Color(0xFF0F6D63);
  static const background = Color(0xFFF7F9F9);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFDDE4E3);
  static const text = Color(0xFF132220);
  static const muted = Color(0xFF5C6D6A);
  static const danger = Color(0xFFB3261E);
  static const warning = Color(0xFFA66300);
  static const success = Color(0xFF1F7A45);
  static const emergency = Color(0xFF8B0000);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    surface: AppColors.surface,
    error: AppColors.danger,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, height: 1.55, color: AppColors.text),
      bodyMedium: TextStyle(fontSize: 15, height: 1.55, color: AppColors.text),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: AppColors.text),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: AppColors.surface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(44, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(44, 48)),
    ),
  );
}
