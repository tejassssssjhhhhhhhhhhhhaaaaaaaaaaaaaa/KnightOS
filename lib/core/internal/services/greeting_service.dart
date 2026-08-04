enum KnightDayPeriod { dawn, day, dusk, night }

class GreetingService {
  const GreetingService();

  /// Standardized Global Greeting (P0-4)
  String getGreeting({int? overrideHour}) {
    final period = getDayPeriod(overrideHour: overrideHour);
    switch (period) {
      case KnightDayPeriod.dawn: return 'Good Morning, Knight';
      case KnightDayPeriod.day: return 'Good Afternoon, Knight';
      case KnightDayPeriod.dusk: return 'Good Evening, Knight';
      case KnightDayPeriod.night: return 'Good Night, Knight';
    }
  }

  KnightDayPeriod getDayPeriod({int? overrideHour}) {
    final hour = overrideHour ?? DateTime.now().hour;
    if (hour >= 5 && hour < 12) return KnightDayPeriod.dawn;
    if (hour >= 12 && hour < 17) return KnightDayPeriod.day;
    if (hour >= 17 && hour < 21) return KnightDayPeriod.dusk;
    return KnightDayPeriod.night;
  }
}
