import 'package:flutter/material.dart';

/// Design tokens pulled from `linguagodesigns/designs_system.png`
/// (LinguaLearn Design System v1.0).
abstract final class AppColors {
  static const primaryPurple = Color(0xFF7C3AED);
  static const accentGreen = Color(0xFF10B981);
  static const highlightYellow = Color(0xFFF59E0B);
  static const textGray = Color(0xFF6B7280);
  static const backgroundGray = Color(0xFFE5E7EB);

  static const surface = Colors.white;
  static const error = Color(0xFFDC2626);
}

/// Builds the single light `ThemeData` for the app. Offline TTS/ASR have no
/// bearing on visuals, so this is the only theme surface the UI layer needs.
class AppTheme {
  const AppTheme._();

  /// Declared in pubspec.yaml from assets/fonts/. Applied as the theme's
  /// `fontFamily` so every widget inherits it.
  static const String fontFamily = 'PlusJakartaSans';

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryPurple,
      brightness: Brightness.light,
      primary: AppColors.primaryPurple,
      secondary: AppColors.accentGreen,
      tertiary: AppColors.highlightYellow,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    // Bundled font, set once on the theme so no widget needs to name it —
    // and nothing reaches the network to render text.
    const baseTextTheme = TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryPurple,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryPurple,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryPurple,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.textGray),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundGray,
      fontFamily: AppTheme.fontFamily,
      textTheme: baseTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          side: const BorderSide(color: AppColors.primaryPurple),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.backgroundGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.backgroundGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
        ),
      ),
    );
  }
}
