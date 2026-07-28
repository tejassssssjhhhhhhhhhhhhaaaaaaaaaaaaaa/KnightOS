enum TimePeriod {
  morning,
  afternoon,
  evening,
  night;

  static TimePeriod fromHour(int hour) {
    if (hour >= 5 && hour < 12) return TimePeriod.morning;
    if (hour >= 12 && hour < 17) return TimePeriod.afternoon;
    if (hour >= 17 && hour < 21) return TimePeriod.evening;
    return TimePeriod.night;
  }

  String get greeting {
    switch (this) {
      case TimePeriod.morning:
        return 'Good Morning';
      case TimePeriod.afternoon:
        return 'Good Afternoon';
      case TimePeriod.evening:
        return 'Good Evening';
      case TimePeriod.night:
        return 'Good Night';
    }
  }
}
