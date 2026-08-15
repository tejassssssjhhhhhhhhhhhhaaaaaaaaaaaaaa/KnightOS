class NaturalTimeResolver {
  const NaturalTimeResolver._();

  static DateTimeRange resolve(String query) {
    final now = DateTime.now();
    final input = query.toLowerCase();

    if (input.contains('today')) {
      return DateTimeRange(
        start: DateTime(now.year, now.month, now.day),
        end: now,
      );
    }

    if (input.contains('yesterday')) {
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTimeRange(
        start: DateTime(yesterday.year, yesterday.month, yesterday.day),
        end: DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
      );
    }

    if (input.contains('this week')) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return DateTimeRange(
        start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
        end: now,
      );
    }

    if (input.contains('last week')) {
      final startOfLastWeek = now.subtract(Duration(days: now.weekday + 6));
      final endOfLastWeek = now.subtract(Duration(days: now.weekday));
      return DateTimeRange(
        start: DateTime(startOfLastWeek.year, startOfLastWeek.month, startOfLastWeek.day),
        end: DateTime(endOfLastWeek.year, endOfLastWeek.month, endOfLastWeek.day, 23, 59, 59),
      );
    }

    if (input.contains('this month')) {
      return DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now,
      );
    }

    if (input.contains('last month')) {
      final lastMonth = DateTime(now.year, now.month - 1, 1);
      final endOfLastMonth = DateTime(now.year, now.month, 0, 23, 59, 59);
      return DateTimeRange(
        start: lastMonth,
        end: endOfLastMonth,
      );
    }

    if (input.contains('past 7 days')) {
      return DateTimeRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      );
    }

    if (input.contains('past 30 days')) {
      return DateTimeRange(
        start: now.subtract(const Duration(days: 30)),
        end: now,
      );
    }

    if (input.contains('this year')) {
      return DateTimeRange(
        start: DateTime(now.year, 1, 1),
        end: now,
      );
    }

    // Default to past 30 days if "recently" or unspecified
    return DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }
}

class DateTimeRange {
  const DateTimeRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}
