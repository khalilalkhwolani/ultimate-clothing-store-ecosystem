import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 58, 49, 222);
  static const Color primaryLight = Color.fromARGB(255, 96, 91, 196);
  static const Color primaryDark = Color.fromARGB(255, 11, 10, 30);

  static const Color secondaryColor = Color.fromARGB(255, 244, 7, 7);
  static const Color tertiaryColor = Color.fromARGB(255, 11, 210, 84);

  static const List<Color> primaryGradient = [primaryColor, Color(0xFF6366F1)];

  // Premium gradient for headers (blue to purple)
  static const List<Color> premiumGradient = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF7C3AED), // Purple
    Color.fromARGB(255, 94, 47, 233), // Light Purple
  ];

  // Light Theme Colors
  static const Color backgroundColor = Color.fromARGB(255, 236, 235, 241);
  static const Color surfaceColor = Color(0xFFFF8FAFC);
  static const Color textPrimary = Color(0xFF1E2938);
  static const Color textsecandery = Color(0xFF647488);

  // Dark Theme Colors
  static const Color backgroundColorDark = Color(0xFF121212);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE1E1E1);
  static const Color textsecanderyDark = Color(0xFF9E9E9E);

  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        error: error,
      ),
      fontFamily: 'Poppis',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColorDark,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColorDark,
        error: error,
      ),
      fontFamily: 'Poppis',
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColorDark,
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimaryDark,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimaryDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textPrimaryDark, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimaryDark, fontSize: 14),
      ),
    );
  }
}
