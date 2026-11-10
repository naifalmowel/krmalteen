import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static const String fontCairo = 'Cairo';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontCairo,
      primaryColor: AppColors.forestGreen,
      scaffoldBackgroundColor: AppColors.softCream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.forestGreen,
        secondary: AppColors.figGold,
        surface: AppColors.warmCard,
        onPrimary: Colors.white,
        onSecondary: AppColors.deepCharcoal,
        onSurface: AppColors.deepCharcoal,
        error: AppColors.errorRed,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontCairo,
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: AppColors.deepCharcoal,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontFamily: fontCairo,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.deepCharcoal,
          height: 1.25,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontCairo,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.forestGreen,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontCairo,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.forestGreen,
        ),
        titleLarge: TextStyle(
          fontFamily: fontCairo,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.deepCharcoal,
        ),
        titleMedium: TextStyle(
          fontFamily: fontCairo,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.deepCharcoal,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontCairo,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.deepCharcoal,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontCairo,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.mutedText,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontFamily: fontCairo,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.forestGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.warmCard,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderLight.withAlpha(204)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.figGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.figGold,
          foregroundColor: AppColors.darkForest,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontCairo,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.forestGreen,
          side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: fontCairo,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
