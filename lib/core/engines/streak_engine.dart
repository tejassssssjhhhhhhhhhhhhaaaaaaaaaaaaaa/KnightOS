class StreakEngine {
  const StreakEngine();

  StreakSummary calculateStreak({required List<DateTime> activeDates, required DateTime now}) {
    if (activeDates.isEmpty) {
      return const StreakSummary(currentStreak: 0, longestStreak: 0, lastActive: null, daysMissed: 0);
    }

    final sortedDates = activeDates.toSet().toList()..sort();
    var longestStreak = 0;
    var streakLength = 0;
    var previousDate = sortedDates.first;

    for (final date in sortedDates) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if (normalizedDate.difference(previousDate).inDays == 1) {
        streakLength += 1;
      } else {
        streakLength = 1;
      }

      previousDate = normalizedDate;
      longestStreak = longestStreak > streakLength ? longestStreak : streakLength;
    }

    final lastActive = sortedDates.last;
    var currentStreak = 0;
    var missedDays = 0;
    for (var index = 0; index < sortedDates.length; index += 1) {
      final date = DateTime(sortedDates[index].year, sortedDates[index].month, sortedDates[index].day);
      if (date.isAtSameMomentAs(lastActive)) {
        currentStreak = 1;
        var nextIndex = index - 1;
        while (nextIndex >= 0) {
          final previousDate = DateTime(sortedDates[nextIndex].year, sortedDates[nextIndex].month, sortedDates[nextIndex].day);
          final gap = date.difference(previousDate).inDays;
          if (gap == 1) {
            currentStreak += 1;
            nextIndex -= 1;
          } else if (gap == 2) {
            currentStreak += 1;
            missedDays += 1;
            break;
          } else {
            break;
          }
        }
        break;
      }
    }

    if (currentStreak == 0 && sortedDates.length > 1) {
      currentStreak = 1;
    }

    return StreakSummary(
      currentStreak: currentStreak.clamp(0, longestStreak),
      longestStreak: longestStreak,
      lastActive: lastActive,
      daysMissed: missedDays.clamp(0, 365),
    );
  }
}

class StreakSummary {
  const StreakSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActive,
    required this.daysMissed,
  });

  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActive;
  final int daysMissed;
}
