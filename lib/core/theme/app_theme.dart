import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radii.dart';

/// Material 3 Theme Configuration for Driver Ledger
/// Uses ColorScheme.fromSeed for automatic color generation
class AppTheme {
  AppTheme._();

  /// Light theme with Material 3 enabled
  static ThemeData get light => _themeFrom(
    ColorScheme.fromSeed(seedColor: AppColors.seedColor, brightness: .light),
  );

  /// Dark theme with Material 3 enabled
  static ThemeData get dark => _themeFrom(
    ColorScheme.fromSeed(seedColor: AppColors.seedColor, brightness: .dark),
  );

  static ThemeData _themeFrom(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: AppRadii.fieldRadius),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 2,
      ),
    );
  }
}
