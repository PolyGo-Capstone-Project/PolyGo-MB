import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      background: AppColors.lightBackground,
      surface: AppColors.lightBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: AppColors.lightTextPrimary,
      onSurface: AppColors.lightTextPrimary,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: AppTextStyles.getTextTheme(Brightness.light),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      background: AppColors.darkBackground,
      surface: AppColors.darkBackground,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: AppTextStyles.getTextTheme(Brightness.dark),
  );
}
