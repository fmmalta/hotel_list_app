import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D3C4E),
        primary: const Color(0xFF1A2941),
        secondary: const Color(0xFF1A2941),
        error: Colors.red.shade800,
      ),

      useMaterial3: true,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D3C4E),
        brightness: Brightness.dark,
        primary: const Color(0xFF4D6F97),
        onPrimary: Colors.black,
        secondary: const Color(0xFF4D6F97),
        onSecondary: Colors.black,
        error: Colors.red.shade300,
        onError: Colors.black,
      ),

      useMaterial3: true,
    );
  }

  static ThemeData highContrastLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D3C4E),
        brightness: Brightness.light,
        primary: const Color(0xFF1A2941),
        onPrimary: Colors.white,
        secondary: const Color(0xFF1A2941),
        onSecondary: Colors.white,
        error: Colors.red.shade800,
        onError: Colors.white,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData highContrastDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D3C4E),
        brightness: Brightness.dark,
        primary: const Color(0xFF4D6F97),
        onPrimary: Colors.black,
        secondary: const Color(0xFF4D6F97),
        onSecondary: Colors.black,
        error: Colors.red.shade300,
        onError: Colors.black,
      ),
      useMaterial3: true,
    );
  }
}
