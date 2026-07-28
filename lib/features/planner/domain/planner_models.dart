import 'package:flutter/material.dart';
import '../../../core/design_system/design_constants.dart';

enum TaskPriority {
  low('Low', Colors.white24),
  medium('Medium', DesignColors.travel),
  high('High', DesignColors.health),
  critical('Critical', DesignColors.health);

  const TaskPriority(this.label, this.color);
  final String label;
  final Color color;
}

enum TaskStatus { pending, inProgress, completed }

class PlannerTask {
  const PlannerTask({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dueTime,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.category = 'General',
    this.tags = const [],
    this.hasNotes = false,
  });

  final String id;
  final String title;
  final String? subtitle;
  final DateTime dueTime;
  final TaskPriority priority;
  final TaskStatus status;
  final String category;
  final List<String> tags;
  final bool hasNotes;

  static List<PlannerTask> get samples => [
    PlannerTask(
      id: 't1',
      title: 'Finalize Phase 5 UI',
      subtitle: 'Complete all planner widgets and layout',
      dueTime: DateTime.now().add(const Duration(hours: 2)),
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      category: 'Work',
      tags: ['knight-os', 'ui'],
    ),
    PlannerTask(
      id: 't2',
      title: 'Review Knowledge Vault Specs',
      dueTime: DateTime.now().add(const Duration(hours: 5)),
      priority: TaskPriority.medium,
      category: 'Work',
      hasNotes: true,
    ),
    PlannerTask(
      id: 't3',
      title: 'Prepare SSC Mock Test',
      dueTime: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.critical,
      category: 'Learning',
    ),
  ];
}

class PlannerGoal {
  const PlannerGoal({
    required this.id,
    required this.title,
    required this.targetDate,
    required this.progress,
    required this.category,
    this.color = DesignColors.focus,
  });

  final String id;
  final String title;
  final DateTime targetDate;
  final double progress; // 0.0 to 1.0
  final String category;
  final Color color;

  static List<PlannerGoal> get samples => [
    PlannerGoal(
      id: 'g1',
      title: 'Master Flutter Internals',
      targetDate: DateTime.now().add(const Duration(days: 90)),
      progress: 0.65,
      category: 'Career',
      color: DesignColors.travel,
    ),
    PlannerGoal(
      id: 'g2',
      title: 'Read 24 Books',
      targetDate: DateTime.now().add(const Duration(days: 180)),
      progress: 0.42,
      category: 'Personal',
      color: DesignColors.knowledge,
    ),
  ];
}

class PlannerHabit {
  const PlannerHabit({
    required this.id,
    required this.title,
    required this.streak,
    required this.weeklyCompletion, // 0 to 7
    required this.icon,
    this.color = DesignColors.primary,
  });

  final String id;
  final String title;
  final int streak;
  final int weeklyCompletion;
  final IconData icon;
  final Color color;

  static List<PlannerHabit> get samples => [
    const PlannerHabit(
      id: 'h1',
      title: 'Drink 3L Water',
      streak: 12,
      weeklyCompletion: 5,
      icon: Icons.water_drop_rounded,
      color: DesignColors.travel,
    ),
    const PlannerHabit(
      id: 'h2',
      title: 'Morning Run',
      streak: 4,
      weeklyCompletion: 3,
      icon: Icons.directions_run_rounded,
      color: DesignColors.health,
    ),
    const PlannerHabit(
      id: 'h3',
      title: 'Meditation',
      streak: 21,
      weeklyCompletion: 7,
      icon: Icons.self_improvement_rounded,
      color: DesignColors.focus,
    ),
  ];
}
