import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Categories for timeline entries.
enum TimelineCategory {
  memory,
  journal,
  milestone,
  achievement,
  health,
  work,
  finance;

  String get label {
    switch (this) {
      case TimelineCategory.memory:
        return 'Memory';
      case TimelineCategory.journal:
        return 'Journal';
      case TimelineCategory.milestone:
        return 'Milestone';
      case TimelineCategory.achievement:
        return 'Achievement';
      case TimelineCategory.health:
        return 'Health';
      case TimelineCategory.work:
        return 'Work';
      case TimelineCategory.finance:
        return 'Finance';
    }
  }

  IconData get icon {
    switch (this) {
      case TimelineCategory.memory:
        return Icons.auto_awesome_rounded;
      case TimelineCategory.journal:
        return Icons.book_rounded;
      case TimelineCategory.milestone:
        return Icons.flag_rounded;
      case TimelineCategory.achievement:
        return Icons.emoji_events_rounded;
      case TimelineCategory.health:
        return Icons.favorite_rounded;
      case TimelineCategory.work:
        return Icons.work_rounded;
      case TimelineCategory.finance:
        return Icons.payments_rounded;
    }
  }
}

/// Importance levels for timeline entries.
enum TimelineImportance { low, medium, high, critical }

@immutable
class TimelineEntry {
  TimelineEntry({
    String? id,
    required this.title,
    required this.description,
    required this.category,
    DateTime? timestamp,
    this.importance = TimelineImportance.medium,
    this.favorite = false,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  final String id;
  final String title;
  final String description;
  final TimelineCategory category;
  final DateTime timestamp;
  final TimelineImportance importance;
  final bool favorite;

  TimelineEntry copyWith({
    String? title,
    String? description,
    TimelineCategory? category,
    DateTime? timestamp,
    TimelineImportance? importance,
    bool? favorite,
  }) {
    return TimelineEntry(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      importance: importance ?? this.importance,
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'timestamp': timestamp.toIso8601String(),
      'importance': importance.name,
      'favorite': favorite,
    };
  }

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: TimelineCategory.values.byName(json['category'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      importance: TimelineImportance.values.byName(
        json['importance'] as String,
      ),
      favorite: json['favorite'] as bool,
    );
  }

  static List<TimelineEntry> get defaults {
    final now = DateTime.now();
    return [
      TimelineEntry(
        title: 'Project Inception',
        description: 'Began the journey of building KnightOS.',
        category: TimelineCategory.milestone,
        timestamp: now.subtract(const Duration(days: 30)),
        importance: TimelineImportance.high,
      ),
      TimelineEntry(
        title: 'First AI Interaction',
        description: 'Successfully integrated the conversation foundation.',
        category: TimelineCategory.achievement,
        timestamp: now.subtract(const Duration(days: 15)),
        importance: TimelineImportance.medium,
        favorite: true,
      ),
      TimelineEntry(
        title: 'Health Milestone',
        description:
            'Maintained optimal recovery score for 7 consecutive days.',
        category: TimelineCategory.health,
        timestamp: now.subtract(const Duration(days: 2)),
        importance: TimelineImportance.medium,
      ),
    ];
  }
}
