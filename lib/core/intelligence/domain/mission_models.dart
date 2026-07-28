import 'package:flutter/foundation.dart';
import 'knight_memory.dart';
import 'memory_category.dart';

enum MissionStatus { draft, active, paused, completed, archived }

enum MissionPriority { critical, high, medium, low }

@immutable
class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.status = MissionStatus.draft,
    this.priority = MissionPriority.medium,
    required this.createdAt,
    this.targetCompletionDate,
  });

  final String id;
  final String title;
  final String description;
  final BookCategory category;
  final MissionStatus status;
  final MissionPriority priority;
  final DateTime createdAt;
  final DateTime? targetCompletionDate;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'categoryId': category.id,
    'status': status.name,
    'priority': priority.name,
    'createdAt': createdAt.toIso8601String(),
    'targetCompletionDate': targetCompletionDate?.toIso8601String(),
  };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: BookCategory.fromId(json['categoryId'] as int),
    status: MissionStatus.values.byName(json['status'] as String),
    priority: MissionPriority.values.byName(json['priority'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    targetCompletionDate: json['targetCompletionDate'] != null
        ? DateTime.parse(json['targetCompletionDate'] as String)
        : null,
  );
}

@immutable
class Goal {
  const Goal({
    required this.id,
    required this.missionId,
    required this.title,
    this.isCompleted = false,
    this.progress = 0.0,
  });

  final String id;
  final String missionId;
  final String title;
  final bool isCompleted;
  final double progress;

  Map<String, dynamic> toJson() => {
    'id': id,
    'missionId': missionId,
    'title': title,
    'isCompleted': isCompleted,
    'progress': progress,
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'] as String,
    missionId: json['missionId'] as String,
    title: json['title'] as String,
    isCompleted: json['isCompleted'] as bool? ?? false,
    progress: (json['progress'] as num? ?? 0.0).toDouble(),
  );
}

@immutable
class Milestone {
  const Milestone({
    required this.id,
    required this.goalId,
    required this.title,
    required this.targetDate,
    this.isReached = false,
  });

  final String id;
  final String goalId;
  final String title;
  final DateTime targetDate;
  final bool isReached;

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalId': goalId,
    'title': title,
    'targetDate': targetDate.toIso8601String(),
    'isReached': isReached,
  };

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
    id: json['id'] as String,
    goalId: json['goalId'] as String,
    title: json['title'] as String,
    targetDate: DateTime.parse(json['targetDate'] as String),
    isReached: json['isReached'] as bool? ?? false,
  );
}

@immutable
class Task {
  const Task({
    required this.id,
    required this.goalId,
    required this.title,
    this.isCompleted = false,
    this.priority = MissionPriority.medium,
  });

  final String id;
  final String goalId;
  final String title;
  final bool isCompleted;
  final MissionPriority priority;

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalId': goalId,
    'title': title,
    'isCompleted': isCompleted,
    'priority': priority.name,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    goalId: json['goalId'] as String,
    title: json['title'] as String,
    isCompleted: json['isCompleted'] as bool? ?? false,
    priority: MissionPriority.values.byName(
      json['priority'] as String? ?? 'medium',
    ),
  );
}

@immutable
class Habit {
  const Habit({
    required this.id,
    required this.title,
    required this.frequencyPerWeek,
    this.currentStreak = 0,
  });

  final String id;
  final String title;
  final int frequencyPerWeek;
  final int currentStreak;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'frequencyPerWeek': frequencyPerWeek,
    'currentStreak': currentStreak,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'] as String,
    title: json['title'] as String,
    frequencyPerWeek: json['frequencyPerWeek'] as int,
    currentStreak: json['currentStreak'] as int? ?? 0,
  );
}

extension MissionMemoryExtension on KnightMemory {
  bool get isMissionType => content.containsKey('missionDataType');

  String? get missionDataType => content['missionDataType'] as String?;

  Mission? toMission() {
    if (missionDataType != 'mission') return null;
    return Mission.fromJson(content);
  }

  Goal? toGoal() {
    if (missionDataType != 'goal') return null;
    return Goal.fromJson(content);
  }

  Task? toTask() {
    if (missionDataType != 'task') return null;
    return Task.fromJson(content);
  }

  Habit? toHabit() {
    if (missionDataType != 'habit') return null;
    return Habit.fromJson(content);
  }
}
