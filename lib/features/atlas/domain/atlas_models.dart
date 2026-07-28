import 'package:flutter/material.dart';
import '../../../core/design_system/design_constants.dart';

enum AtlasCategory {
  all('All', Icons.all_inclusive_rounded, DesignColors.primary),
  health('Health', Icons.favorite_rounded, DesignColors.health),
  finance(
    'Finance',
    Icons.account_balance_wallet_rounded,
    DesignColors.finance,
  ),
  travel('Travel', Icons.explore_rounded, DesignColors.travel),
  learning('Learning', Icons.school_rounded, DesignColors.knowledge),
  documents('Documents', Icons.description_rounded, DesignColors.secondary),
  work('Work', Icons.work_rounded, DesignColors.focus),
  fitness('Fitness', Icons.fitness_center_rounded, DesignColors.health),
  photos('Photos', Icons.photo_rounded, DesignColors.travel),
  achievements(
    'Achievements',
    Icons.emoji_events_rounded,
    DesignColors.achievements,
  );

  const AtlasCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class AtlasEvent {
  const AtlasEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.category,
    this.tags = const [],
    this.imageUrl,
    this.isHighlight = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final AtlasCategory category;
  final List<String> tags;
  final String? imageUrl;
  final bool isHighlight;

  static List<AtlasEvent> get samples => [
    AtlasEvent(
      id: '1',
      title: 'Design System Frozen',
      subtitle: 'Completed visual framework for KnightOS v1.0.',
      timestamp: DateTime.now(),
      category: AtlasCategory.work,
      tags: ['ui', 'ux', 'milestone'],
      isHighlight: true,
    ),
    AtlasEvent(
      id: '2',
      title: 'Morning Run',
      subtitle: '5.2km in 28 minutes. Pace: 5:23 min/km.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      category: AtlasCategory.fitness,
      tags: ['cardio', 'health'],
    ),
    AtlasEvent(
      id: '7',
      title: 'Brainstorming Session',
      subtitle: 'Defining the Life Atlas interactive experience.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      category: AtlasCategory.work,
    ),
    AtlasEvent(
      id: '3',
      title: 'Subscription Renewal',
      subtitle: 'Cloud compute services renewed for 12 months.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: AtlasCategory.finance,
      tags: ['recurring', 'compute'],
    ),
    AtlasEvent(
      id: '8',
      title: 'Daily Meditation',
      subtitle: '15 minutes of mindfulness. HR variability improved.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      category: AtlasCategory.health,
    ),
    AtlasEvent(
      id: '4',
      title: 'Tokyo Trip Booked',
      subtitle: 'Flight NH806 confirmed. Departure Oct 12.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      category: AtlasCategory.travel,
      tags: ['japan', 'vacation'],
      isHighlight: true,
    ),
    AtlasEvent(
      id: '5',
      title: 'Medical Checkup',
      subtitle: 'Blood panel results received. Vital signs optimal.',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      category: AtlasCategory.health,
      tags: ['prevention'],
    ),
    AtlasEvent(
      id: '6',
      title: 'Mastered Dart Macros',
      subtitle: 'Completed advanced metaprogramming module.',
      timestamp: DateTime.now().subtract(const Duration(days: 12)),
      category: AtlasCategory.learning,
      tags: ['dart', 'advanced'],
    ),
  ];
}
