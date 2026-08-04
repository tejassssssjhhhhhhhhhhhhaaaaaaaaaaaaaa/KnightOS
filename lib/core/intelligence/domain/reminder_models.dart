import 'package:flutter/foundation.dart';

enum ReminderType {
  health,
  workout,
  water,
  medication,
  sleep,
  travel,
  bill,
  subscription,
  finance,
  general,
}

enum ReminderPriority { low, medium, high, critical }

@immutable
class UnifiedReminder {
  const UnifiedReminder({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.scheduledAt,
    this.priority = ReminderPriority.medium,
    this.isCompleted = false,
    this.metadata = const {},
  });

  final String id;
  final ReminderType type;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final ReminderPriority priority;
  final bool isCompleted;
  final Map<String, dynamic> metadata;
}
