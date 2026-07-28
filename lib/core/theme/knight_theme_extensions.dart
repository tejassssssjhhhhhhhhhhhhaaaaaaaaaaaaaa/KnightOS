import 'package:flutter/material.dart';

@immutable
class KnightPremiumTheme extends ThemeExtension<KnightPremiumTheme> {
  const KnightPremiumTheme({
    required this.auroraColors,
    required this.glassBlur,
    required this.glassOpacity,
    required this.accentColor,
  });

  final List<Color> auroraColors;
  final double glassBlur;
  final double glassOpacity;
  final Color accentColor;

  @override
  KnightPremiumTheme copyWith({
    List<Color>? auroraColors,
    double? glassBlur,
    double? glassOpacity,
    Color? accentColor,
  }) {
    return KnightPremiumTheme(
      auroraColors: auroraColors ?? this.auroraColors,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  KnightPremiumTheme lerp(ThemeExtension<KnightPremiumTheme>? other, double t) {
    if (other is! KnightPremiumTheme) return this;
    return KnightPremiumTheme(
      auroraColors:
          Color.lerp(auroraColors.first, other.auroraColors.first, t) != null
          ? [
              Color.lerp(auroraColors[0], other.auroraColors[0], t)!,
              Color.lerp(auroraColors[1], other.auroraColors[1], t)!,
              Color.lerp(auroraColors[2], other.auroraColors[2], t)!,
            ]
          : auroraColors,
      glassBlur: Tween<double>(
        begin: glassBlur,
        end: other.glassBlur,
      ).transform(t),
      glassOpacity: Tween<double>(
        begin: glassOpacity,
        end: other.glassOpacity,
      ).transform(t),
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
    );
  }
}
