import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Categories for upcoming items.
enum UpcomingCategory {
  event,
  task,
  deadline,
  reminder;

  String get label {
    switch (this) {
      case UpcomingCategory.event:
        return 'Event';
      case UpcomingCategory.task:
        return 'Task';
      case UpcomingCategory.deadline:
        return 'Deadline';
      case UpcomingCategory.reminder:
        return 'Reminder';
    }
  }

  IconData get icon {
    switch (this) {
      case UpcomingCategory.event:
        return Icons.event_rounded;
      case UpcomingCategory.task:
        return Icons.task_alt_rounded;
      case UpcomingCategory.deadline:
        return Icons.notification_important_rounded;
      case UpcomingCategory.reminder:
        return Icons.alarm_rounded;
    }
  }
}

/// Priority levels for upcoming items.
enum PriorityLevel {
  low,
  medium,
  high;

  Color get color {
    switch (this) {
      case PriorityLevel.low:
        return Colors.blue;
      case PriorityLevel.medium:
        return Colors.orange;
      case PriorityLevel.high:
        return Colors.red;
    }
  }
}

@immutable
class UpcomingItem {
  UpcomingItem({
    String? id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.dueDate,
    this.priority = PriorityLevel.medium,
    this.completed = false,
    DateTime? lastUpdated,
  }) : id = id ?? const Uuid().v4(),
       lastUpdated = lastUpdated ?? DateTime.now();

  final String id;
  final String title;
  final String subtitle;
  final UpcomingCategory category;
  final DateTime dueDate;
  final PriorityLevel priority;
  final bool completed;
  final DateTime lastUpdated;

  UpcomingItem copyWith({
    String? title,
    String? subtitle,
    UpcomingCategory? category,
    DateTime? dueDate,
    PriorityLevel? priority,
    bool? completed,
    DateTime? lastUpdated,
  }) {
    return UpcomingItem(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category.name,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.name,
      'completed': completed,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory UpcomingItem.fromJson(Map<String, dynamic> json) {
    return UpcomingItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      category: UpcomingCategory.values.byName(json['category'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: PriorityLevel.values.byName(json['priority'] as String),
      completed: json['completed'] as bool,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  static List<UpcomingItem> get defaults {
    final now = DateTime.now();
    return [
      UpcomingItem(
        title: 'Strategy Meeting',
        subtitle: 'Q3 planning with stakeholders',
        category: UpcomingCategory.event,
        dueDate: now.add(const Duration(hours: 2)),
        priority: PriorityLevel.high,
      ),
      UpcomingItem(
        title: 'Review Sprint Report',
        subtitle: 'Finalize metrics for Sprint 6',
        category: UpcomingCategory.task,
        dueDate: now.add(const Duration(hours: 5)),
        priority: PriorityLevel.medium,
      ),
      UpcomingItem(
        title: 'Patent Filing',
        subtitle: 'Hard deadline for mobile SDK',
        category: UpcomingCategory.deadline,
        dueDate: now.add(const Duration(days: 1)),
        priority: PriorityLevel.high,
      ),
      UpcomingItem(
        title: 'Check Maintenance Logs',
        subtitle: 'Routine system verification',
        category: UpcomingCategory.reminder,
        dueDate: now.add(const Duration(days: 2)),
        priority: PriorityLevel.low,
      ),
    ];
  }
}
