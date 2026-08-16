import 'package:flutter/material.dart';

/// App color constants for Driver Ledger
/// Using Material 3 color scheme with a blue seed color
class AppColors {
  AppColors._();

  // Primary seed color for Material 3
  static const Color seedColor = Color(0xFF1565C0);

  // Light theme colors
  static const Color lightPrimary = Color(0xFF1565C0);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFD8E2FF);
  static const Color lightOnPrimaryContainer = Color(0xFF001A41);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFFADC6FF);
  static const Color darkOnPrimary = Color(0xFF002E6B);
  static const Color darkPrimaryContainer = Color(0xFF004593);
  static const Color darkOnPrimaryContainer = Color(0xFFD8E2FF);

  // Neutral colors
  static const Color surfaceLight = Color(0xFFFEFBFF);
  static const Color surfaceDark = Color(0xFF1B1B1F);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
}
