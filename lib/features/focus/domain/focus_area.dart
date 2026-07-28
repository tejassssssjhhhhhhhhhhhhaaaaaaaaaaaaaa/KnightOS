import 'package:flutter/material.dart';

/// Categories for daily focus areas.
enum FocusCategory {
  /// Health and physical well-being.
  health,

  /// Work, missions, and productivity.
  work,

  /// Personal growth and balance.
  personal;

  /// Returns the localized label for the category.
  String get label {
    switch (this) {
      case FocusCategory.health:
        return 'Health';
      case FocusCategory.work:
        return 'Work';
      case FocusCategory.personal:
        return 'Personal';
    }
  }

  /// Returns the representative icon for the category.
  IconData get icon {
    switch (this) {
      case FocusCategory.health:
        return Icons.favorite_rounded;
      case FocusCategory.work:
        return Icons.work_rounded;
      case FocusCategory.personal:
        return Icons.person_rounded;
    }
  }
}

/// Represents a specific area of focus for the user's day.
@immutable
class FocusArea {
  /// Creates a [FocusArea].
  const FocusArea({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.completionProgress,
    this.statusBadge,
    this.isAiPrioritized = false,
    this.reminderCount = 0,
    required this.lastUpdated,
  });

  /// The category this focus area belongs to.
  final FocusCategory category;

  /// The main title of the focus area.
  final String title;

  /// A brief description or status update.
  final String subtitle;

  /// Completion progress from 0.0 to 1.0.
  final double completionProgress;

  /// Optional high-level status badge text.
  final String? statusBadge;

  /// Whether this area has been flagged as a priority by the AI.
  final bool isAiPrioritized;

  /// Count of active reminders for this area.
  final int reminderCount;

  /// Timestamp of the last update.
  final DateTime lastUpdated;

  /// Centralized placeholder data for the "Today's Focus" section.
  static List<FocusArea> get placeholders => [
    FocusArea(
      category: FocusCategory.health,
      title: 'Health',
      subtitle: 'Tracking recovery and vitals',
      completionProgress: 0.0,
      statusBadge: 'Resting',
      lastUpdated: DateTime.now(),
    ),
    FocusArea(
      category: FocusCategory.work,
      title: 'Work',
      subtitle: 'Active mission management',
      completionProgress: 0.0,
      statusBadge: 'On track',
      isAiPrioritized: true,
      lastUpdated: DateTime.now(),
    ),
    FocusArea(
      category: FocusCategory.personal,
      title: 'Personal',
      subtitle: 'Balance and growth',
      completionProgress: 0.0,
      reminderCount: 2,
      lastUpdated: DateTime.now(),
    ),
  ];

  FocusArea copyWith({
    double? completionProgress,
    String? statusBadge,
    DateTime? lastUpdated,
  }) {
    return FocusArea(
      category: category,
      title: title,
      subtitle: subtitle,
      completionProgress: completionProgress ?? this.completionProgress,
      statusBadge: statusBadge ?? this.statusBadge,
      isAiPrioritized: isAiPrioritized,
      reminderCount: reminderCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'title': title,
      'subtitle': subtitle,
      'completionProgress': completionProgress,
      'statusBadge': statusBadge,
      'isAiPrioritized': isAiPrioritized,
      'reminderCount': reminderCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory FocusArea.fromJson(Map<String, dynamic> json) {
    return FocusArea(
      category: FocusCategory.values.byName(json['category'] as String),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      completionProgress: (json['completionProgress'] as num).toDouble(),
      statusBadge: json['statusBadge'] as String?,
      isAiPrioritized: json['isAiPrioritized'] as bool? ?? false,
      reminderCount: json['reminderCount'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}
