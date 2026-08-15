enum KnightDayPeriod { morning, day, afternoon, evening, night, lateNight }

class GreetingService {
  const GreetingService();

  /// Standardized Global Greeting (P0-4)
  String getGreeting({int? overrideHour}) {
    final period = getDayPeriod(overrideHour: overrideHour);
    switch (period) {
      case KnightDayPeriod.morning: return 'Good Morning, Knight';
      case KnightDayPeriod.day: return 'Good Day, Knight';
      case KnightDayPeriod.afternoon: return 'Good Afternoon, Knight';
      case KnightDayPeriod.evening: return 'Good Evening, Knight';
      case KnightDayPeriod.night: return 'Good Night, Knight';
      case KnightDayPeriod.lateNight: return 'Welcome to the Late Shift';
    }
  }

  KnightDayPeriod getDayPeriod({int? overrideHour}) {
    final hour = overrideHour ?? DateTime.now().hour;
    // Morning: 5:00 AM – 11:00 AM
    if (hour >= 5 && hour < 11) return KnightDayPeriod.morning;
    // Day: 11:00 AM – 2:00 PM (14:00)
    if (hour >= 11 && hour < 14) return KnightDayPeriod.day;
    // Afternoon: 2:00 PM – 5:00 PM (17:00)
    if (hour >= 14 && hour < 17) return KnightDayPeriod.afternoon;
    // Evening: 5:00 PM – 9:00 PM (21:00)
    if (hour >= 17 && hour < 21) return KnightDayPeriod.evening;
    // Night: 9:00 PM – 1:00 AM
    if (hour >= 21 || hour < 1) return KnightDayPeriod.night;
    // Late Night: 1:00 AM – 5:00 AM
    return KnightDayPeriod.lateNight;
  }
}
