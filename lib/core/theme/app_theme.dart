import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system/design_constants.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData darkTheme({bool isTest = false}) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DesignColors.background,
      colorScheme: const ColorScheme.dark(
        surface: DesignColors.surface,
        onSurface: Colors.white,
        primary: DesignColors.accentBlue,
        onPrimary: Colors.white,
        secondary: DesignColors.accentPurple,
        onSecondary: Colors.white,
      ),
    );

    if (isTest) return baseTheme;

    final interTextTheme = GoogleFonts.interTextTheme(baseTheme.textTheme);

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      textTheme: interTextTheme.copyWith(
        displayLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w900,
          fontSize: 48,
          letterSpacing: -1.5,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          fontSize: 32,
          letterSpacing: -1.0,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          fontSize: 28,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          height: 1.5,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: DesignColors.secondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: 2.0,
          color: DesignColors.secondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: DesignColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.card,
          side: const BorderSide(color: DesignColors.white05),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: DesignRadius.pill),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignColors.white05,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: DesignColors.white10),
        ),
        labelStyle: const TextStyle(color: DesignColors.secondary),
        hintStyle: const TextStyle(color: Colors.white24),
      ),
      dividerTheme: const DividerThemeData(
        color: DesignColors.white10,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
