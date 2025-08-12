import 'package:flutter/material.dart';

/// AppColors defines Jello Mark's representative brand colors.
///
/// How to use:
/// - Import this file and reference colors as `AppColors.primaryBlue`, etc.
/// - Do NOT hardcode hex colors in UI code. This makes theme changes trivial
///   and keeps a single source of truth aligned with Clean Architecture.
///
/// To update brand colors globally:
/// - Change the values here and (optionally) adjust ThemeData wiring in AppTheme/MaterialApp.
class AppColors {
  const AppColors._();

  // Brand palette
  static const Color primaryBlue = Color(0xFF6B8BFF);
  static const Color softPeach = Color(0xFFFFDAB9);
  static const Color mintGreen = Color(0xFF98FB98);
  static const Color lavender = Color(0xFFE6E6FA);
}
