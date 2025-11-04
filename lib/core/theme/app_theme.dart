import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF6750A4),
      secondary: Color(0xFF625B71),
      surface: Color(0xFFFEF7FF),
      background: Color(0xFFFFFBFF),
      error: Color(0xFFB3261E),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    appBarTheme: AppBarTheme(centerTitle: true, elevation: 0),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFD0BCFF),
      secondary: Color(0xFFCCC2DC),
      surface: Color(0xFF1C1B1F),
      background: Color(0xFF1C1B1F),
      error: Color(0xFFF2B8B5),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    appBarTheme: AppBarTheme(centerTitle: true, elevation: 0),
  );
}
