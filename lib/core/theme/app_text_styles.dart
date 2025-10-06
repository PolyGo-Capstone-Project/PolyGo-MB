import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextTheme getTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryColor =
    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryColor =
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  }
}
