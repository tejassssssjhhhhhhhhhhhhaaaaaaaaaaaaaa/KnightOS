import 'package:flutter/material.dart';

/// Official Horizon Design Identity — Version 2.0 (Design Freeze)
class DesignColors {
  const DesignColors._();

  // Primary Palette
  static const Color background = Color(0xFF020408); // Deep Navy
  static const Color surface = Color(0xFF0A0C14); // Surface Low
  static const Color surfaceHigh = Color(0xFF121620); // Surface High
  static const Color primary = Color(0xFFFFFFFF); // Text Primary
  static const Color secondary = Color(0xFF94A3B8); // Text Secondary

  // Brand Accents
  static const Color accentBlue = Color(0xFF0EA5E9); // Electric Blue (Primary)
  static const Color accentPurple = Color(0xFF6366F1); // Radiant Indigo (Logo related)
  static const Color accentCyan = Color(0xFF22D3EE); // Neon Cyan (Logo related)

  // Functional Colors (Strictly Brand Derived)
  static const Color success = Color(0xFF22D3EE);
  static const Color warning = Color(0xFF38BDF8);
  static const Color error = Color(0xFF0EA5E9); // Use primary for errors to stay brand safe, or a variant

  // Life Area Accents (All BLUE based)
  static const Color health = Color(0xFF0EA5E9);
  static const Color finance = Color(0xFF38BDF8);
  static const Color career = Color(0xFF6366F1);
  static const Color knowledge = Color(0xFF22D3EE);
  static const Color travel = Color(0xFF7DD3FC);
  static const Color focus = Color(0xFF0EA5E9);
  static const Color achievements = Color(0xFF38BDF8);

  // Utility
  static const Color white05 = Color(0x0DFFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color glowBlue = Color(0x400EA5E9);
}

class DesignGradients {
  const DesignGradients._();

  static LinearGradient get horizon => const LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF020408)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient get cinematicLunar => const LinearGradient(
    colors: [
      Color(0xFF0F172A), // Deep Blue Top
      Color(0xFF020408), // Horizon Line
      Color(0xFF0A0C14), // Surface Bottom
    ],
    stops: [0.0, 0.45, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static RadialGradient get fabGlow => const RadialGradient(
    colors: [DesignColors.accentBlue, Colors.transparent],
    radius: 0.8,
  );

  static LinearGradient get glass => LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.08),
      Colors.white.withValues(alpha: 0.02),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class DesignSpacing {
  const DesignSpacing._();
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double sectionGap = 40.0;
}

class DesignRadius {
  const DesignRadius._();
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const BorderRadius card = BorderRadius.all(Radius.circular(l));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(100));
  static const BorderRadius sheet =
      BorderRadius.vertical(top: Radius.circular(xl));
}

class DesignAnimations {
  const DesignAnimations._();
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration standard = Duration(milliseconds: 450);
  static const Duration slow = Duration(milliseconds: 900);
  static const Curve curve = Curves.fastOutSlowIn;
}

class DesignShadows {
  const DesignShadows._();

  static List<BoxShadow> get soft => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get sharp => [
    const BoxShadow(
      color: Colors.black54,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get glowBlue => [
    BoxShadow(
      color: DesignColors.accentBlue.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> get subtle => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get highImpact => [
    BoxShadow(
      color: DesignColors.accentBlue.withValues(alpha: 0.1),
      blurRadius: 40,
      offset: const Offset(0, 0),
    ),
  ];
}

class DesignIconSize {
  const DesignIconSize._();
  static const double s = 18.0;
  static const double m = 24.0;
  static const double l = 32.0;
  static const double xl = 64.0;
}
