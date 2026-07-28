import 'package:flutter/material.dart';
import '../../design_system/design_constants.dart';

enum TimelineCategory {
  health('Health', Icons.favorite_rounded, DesignColors.health),
  finance(
    'Finance',
    Icons.account_balance_wallet_rounded,
    DesignColors.finance,
  ),
  travel('Travel', Icons.explore_rounded, DesignColors.travel),
  learning('Learning', Icons.school_rounded, DesignColors.knowledge),
  work('Work', Icons.work_rounded, DesignColors.focus),
  fitness('Fitness', Icons.fitness_center_rounded, DesignColors.health),
  personal('Personal', Icons.person_rounded, DesignColors.primary),
  achievement(
    'Achievement',
    Icons.emoji_events_rounded,
    DesignColors.achievements,
  );

  const TimelineCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class TimelineEvent {
  const TimelineEvent({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.category,
    this.subtitle,
    this.content = const {},
    this.tags = const [],
    this.isHighlight = false,
    this.locationId,
  });

  final String id;
  final String title;
  final String? subtitle;
  final DateTime timestamp;
  final TimelineCategory category;
  final Map<String, dynamic> content;
  final List<String> tags;
  final bool isHighlight;
  final String? locationId;

  static List<TimelineEvent> get samples => [
    TimelineEvent(
      id: '1',
      title: 'Design System Frozen',
      subtitle: 'Completed visual framework for KnightOS v1.0.',
      timestamp: DateTime.now(),
      category: TimelineCategory.work,
      tags: ['ui', 'ux', 'milestone'],
      isHighlight: true,
    ),
    TimelineEvent(
      id: '2',
      title: 'Morning Run',
      subtitle: '5.2km in 28 minutes. Pace: 5:23 min/km.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      category: TimelineCategory.fitness,
      tags: ['cardio', 'health'],
    ),
    TimelineEvent(
      id: '7',
      title: 'Brainstorming Session',
      subtitle: 'Defining the Life Atlas interactive experience.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      category: TimelineCategory.work,
    ),
    TimelineEvent(
      id: '3',
      title: 'Subscription Renewal',
      subtitle: 'Cloud compute services renewed for 12 months.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: TimelineCategory.finance,
      tags: ['recurring', 'compute'],
    ),
    TimelineEvent(
      id: '4',
      title: 'Tokyo Trip Booked',
      subtitle: 'Flight NH806 confirmed. Departure Oct 12.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      category: TimelineCategory.travel,
      tags: ['japan', 'vacation'],
      isHighlight: true,
    ),
  ];
}
