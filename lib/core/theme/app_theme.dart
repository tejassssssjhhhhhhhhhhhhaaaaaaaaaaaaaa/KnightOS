import 'package:flutter/material.dart';
import '../design_system/design_constants.dart';
import '../internal/services/greeting_service.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme({bool isTest = false}) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50
      colorScheme: const ColorScheme.light(
        surface: Colors.white,
        onSurface: Color(0xFF0F172A),
        primary: DesignColors.accentBlue,
        onPrimary: Colors.white,
        secondary: DesignColors.accentPurple,
        onSecondary: Colors.white,
      ),
    );

    if (isTest) return baseTheme;

    // Temporarily disabled GoogleFonts for debugging white screen on physical devices
    // final interTextTheme = GoogleFonts.interTextTheme(baseTheme.textTheme);
    final interTextTheme = baseTheme.textTheme;

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        titleTextStyle: const TextStyle( // GoogleFonts.inter fallback
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: Color(0xFF0F172A),
        ),
      ),
      textTheme: interTextTheme.copyWith(
        displayLarge: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 48,
          letterSpacing: -1.5,
          color: Color(0xFF0F172A),
        ),
        displayMedium: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 32,
          letterSpacing: -1.0,
          color: Color(0xFF0F172A),
        ),
        headlineLarge: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 28,
          letterSpacing: -0.5,
          color: Color(0xFF0F172A),
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: Color(0xFF0F172A),
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color(0xFF0F172A),
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xFF1E293B),
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Color(0xFF475569),
        ),
        labelLarge: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: 2.0,
          color: Color(0xFF64748B),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.card,
          side: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: DesignRadius.pill),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.03),
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
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
        labelStyle: const TextStyle(color: Color(0xFF64748B)),
        hintStyle: const TextStyle(color: Colors.black26),
      ),
    );
  }

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

    // Temporarily disabled GoogleFonts for debugging
    // final interTextTheme = GoogleFonts.interTextTheme(baseTheme.textTheme);
    final interTextTheme = baseTheme.textTheme;

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle( // fallback
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      textTheme: interTextTheme.copyWith(
        displayLarge: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 48,
          letterSpacing: -1.5,
          color: Colors.white,
        ),
        displayMedium: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 32,
          letterSpacing: -1.0,
          color: Colors.white,
        ),
        headlineLarge: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 28,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: Colors.white,
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: DesignColors.secondary,
        ),
        labelLarge: const TextStyle(
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

  /// Adaptive "Time-Aware" Theme Decoration
  static BoxDecoration dynamicBackground(KnightDayPeriod period) {
    switch (period) {
      case KnightDayPeriod.morning:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF020408), Color(0xFF1E1B4B)],
          ),
        );
      case KnightDayPeriod.day:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020617), Color(0xFF020408), Color(0xFF0C4A6E)],
          ),
        );
      case KnightDayPeriod.afternoon:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        );
      case KnightDayPeriod.evening:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020408), Color(0xFF1E1B4B), Color(0xFF312E81)],
          ),
        );
      case KnightDayPeriod.night:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF020408), Color(0xFF020617)],
          ),
        );
      case KnightDayPeriod.lateNight:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF010204), Color(0xFF020408)],
          ),
        );
    }
  }

  static Color accentForPeriod(KnightDayPeriod period) {
    switch (period) {
      case KnightDayPeriod.morning: return const Color(0xFF818CF8); // Indigo
      case KnightDayPeriod.day: return const Color(0xFF0EA5E9); // Sky Blue
      case KnightDayPeriod.afternoon: return const Color(0xFF38BDF8); // Light Sky
      case KnightDayPeriod.evening: return const Color(0xFF6366F1); // Indigo Radiant
      case KnightDayPeriod.night: return const Color(0xFF22D3EE); // Cyan
      case KnightDayPeriod.lateNight: return const Color(0xFF0EA5E9); // Electric Blue
    }
  }
}
