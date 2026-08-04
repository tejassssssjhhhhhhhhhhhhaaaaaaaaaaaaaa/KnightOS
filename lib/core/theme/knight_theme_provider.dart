import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../internal/services/greeting_service.dart';
import '../intelligence/providers/intelligence_providers.dart';
import 'app_theme.dart';

/// Notifier for the global theme mode.
class KnightThemeMode extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  void setThemeMode(ThemeMode mode) => state = mode;
}

final knightThemeModeProvider = NotifierProvider<KnightThemeMode, ThemeMode>(KnightThemeMode.new);

/// Debug/Dev override for simulating specific hours (P0-5)
class SimulatedHour extends Notifier<int?> {
  @override
  int? build() => null;
  void set(int? hour) => state = hour;
}

final simulatedHourProvider = NotifierProvider<SimulatedHour, int?>(SimulatedHour.new);

/// Watches the current time of day and returns the appropriate visual period.
final currentPeriodProvider = Provider<KnightDayPeriod>((ref) {
  final simulatedHour = ref.watch(simulatedHourProvider);
  return ref.watch(greetingServiceProvider).getDayPeriod(overrideHour: simulatedHour);
});

/// Provides the globally adapted accent color based on time of day.
final adaptiveAccentProvider = Provider<Color>((ref) {
  final period = ref.watch(currentPeriodProvider);
  return AppTheme.accentForPeriod(period);
});

/// Provides the fully adapted theme based on time of day.
final knightAppThemeProvider = Provider<ThemeData>((ref) {
  final period = ref.watch(currentPeriodProvider);
  final baseTheme = AppTheme.darkTheme();
  final accentColor = AppTheme.accentForPeriod(period);

  return baseTheme.copyWith(
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: accentColor,
      secondary: accentColor.withValues(alpha: 0.7),
    ),
    appBarTheme: baseTheme.appBarTheme.copyWith(
      titleTextStyle: baseTheme.appBarTheme.titleTextStyle?.copyWith(color: accentColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentColor,
    ),
  );
});
