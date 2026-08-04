import 'package:flutter/material.dart';
import '../internal/services/greeting_service.dart';

class KnightTokens {
  const KnightTokens._();

  static const Color midnight = Color(0xFF020408);
  static const Color slateLow = Color(0xFF0F172A);
  static const Color slateHigh = Color(0xFF1E293B);

  // Material Identity colors based on period
  static Color shieldPrimary(KnightDayPeriod period) {
    switch (period) {
      case KnightDayPeriod.dawn: return const Color(0xFFFDE68A); // Gold
      case KnightDayPeriod.day: return const Color(0xFFE2E8F0); // Silver
      case KnightDayPeriod.dusk: return const Color(0xFFFB923C); // Copper
      case KnightDayPeriod.night: return const Color(0xFF0C4A6E); // Navy
    }
  }

  static Color accent(KnightDayPeriod period) {
    switch (period) {
      case KnightDayPeriod.dawn: return const Color(0xFF818CF8); // Indigo
      case KnightDayPeriod.day: return const Color(0xFF0EA5E9); // Sky
      case KnightDayPeriod.dusk: return const Color(0xFFF43F5E); // Rose
      case KnightDayPeriod.night: return const Color(0xFF22D3EE); // Cyan
    }
  }

  static List<Color> backgroundGradient(KnightDayPeriod period) {
    switch (period) {
      case KnightDayPeriod.dawn: 
        return [const Color(0xFF0F172A), const Color(0xFF1E1B4B), const Color(0xFF312E81)];
      case KnightDayPeriod.day: 
        return [const Color(0xFF020617), const Color(0xFF020408), const Color(0xFF0C4A6E)];
      case KnightDayPeriod.dusk: 
        return [const Color(0xFF020408), const Color(0xFF1E1B4B), const Color(0xFF312E81)];
      case KnightDayPeriod.night: 
        return [const Color(0xFF000000), const Color(0xFF020408), const Color(0xFF020617)];
    }
  }

  static BoxDecoration glass({required Color accentColor, double opacity = 0.05}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: radiusCard,
      border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
    );
  }

  static List<BoxShadow> glow(Color color) {
    return [
      BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2),
    ];
  }

  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;

  static BorderRadius radiusCard = BorderRadius.circular(24.0);
  static BorderRadius radiusPill = BorderRadius.circular(100.0);

  static const Duration transitionSlow = Duration(milliseconds: 2000);
  static const Duration transitionStandard = Duration(milliseconds: 450);

  // P0-7 Typography
  static const TextStyle headline = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  static const TextStyle subheadline = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.white38,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w900,
    color: Colors.white24,
    letterSpacing: 2.0,
  );
}
