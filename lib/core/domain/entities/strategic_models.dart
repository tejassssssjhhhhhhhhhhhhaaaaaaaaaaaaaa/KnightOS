import 'package:equatable/equatable.dart';

/// The highest level of purpose for a KnightOS user.
class LifeVision extends Equatable {
  const LifeVision({
    required this.id,
    required this.title,
    this.description,
    this.purpose,
    this.coreValues = const [],
    this.isPrimary = true,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? description;
  final String? purpose;
  final List<String> coreValues;
  final bool isPrimary;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, description, purpose, coreValues, isPrimary, createdAt];
}

/// A strategic, multi-domain goal that guides the user towards their Life Vision.
class NorthStar extends Equatable {
  const NorthStar({
    required this.id,
    required this.lifeVisionId,
    required this.title,
    this.description,
    required this.domain, // 'career', 'finance', 'health', etc.
    this.targetState,
    this.progress = 0.0,
    required this.priority,
    this.dueDate,
    this.isArchived = false,
    required this.createdAt,
    this.metadata = const {},
  });

  final String id;
  final String lifeVisionId;
  final String title;
  final String? description;
  final String domain;
  final String? targetState;
  final double progress;
  final int priority; // 1-10
  final DateTime? dueDate;
  final bool isArchived;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [
        id,
        lifeVisionId,
        title,
        description,
        domain,
        targetState,
        progress,
        priority,
        dueDate,
        isArchived,
        createdAt,
        metadata,
      ];
}

/// A measurable objective that contributes to a North Star.
class StrategicObjective extends Equatable {
  const StrategicObjective({
    required this.id,
    required this.northStarId,
    required this.title,
    this.description,
    this.targetMetric,
    this.currentMetric,
    this.progress = 0.0,
    required this.createdAt,
  });

  final String id;
  final String northStarId;
  final String title;
  final String? description;
  final String? targetMetric;
  final String? currentMetric;
  final double progress;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, northStarId, title, description, targetMetric, currentMetric, progress, createdAt];
}

/// A significant milestone within a Strategic Objective or Project.
class StrategicMilestone extends Equatable {
  const StrategicMilestone({
    required this.id,
    required this.objectiveId,
    required this.title,
    required this.date,
    this.isReached = false,
    this.evidenceCaid,
  });

  final String id;
  final String objectiveId;
  final String title;
  final DateTime date;
  final bool isReached;
  final String? evidenceCaid;

  @override
  List<Object?> get props => [id, objectiveId, title, date, isReached, evidenceCaid];
}
