import 'package:equatable/equatable.dart';

/// Categories of missions in KnightOS.
enum MissionType {
  habit,
  task,
  learning,
  project,
  certification,
  health,
  finance,
  travel,
  career,
  personal,
  milestone,
  networking,
  portfolio,
  communication,
  personalGrowth,
}

/// Current state of a mission.
enum MissionStatus {
  draft,
  active,
  paused,
  completed,
  cancelled,
  failed,
}

/// Priority levels for missions.
enum MissionPriority {
  low,
  medium,
  high,
  critical,
}

/// A measurable, goal-oriented unit of work or habit in KnightOS.
class Mission extends Equatable {
  const Mission({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.owningDomain,
    required this.status,
    this.relatedEvidenceIds = const [],
    this.relatedTimelineEventIds = const [],
    this.relatedNorthStarGoalId,
    this.parentMissionId,
    this.childMissionIds = const [],
    this.dependencies = const [],
    this.estimatedDurationMinutes,
    this.estimatedEnergyRequirement,
    this.successProbability = 0.5,
    required this.priority,
    required this.importance, // 1-10
    required this.urgency, // 1-10
    this.dueDate,
    this.progress = 0.0, // 0.0 - 1.0
    this.verificationMethod,
    this.completionEvidenceId,
    this.aiNotes,
    this.userNotes,
    this.explainabilityMetadata = const {},
    required this.alignmentScore, // North Star alignment 0.0 - 1.0
    required this.createdAt,
    this.completedAt,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String? description;
  final MissionType type;
  
  /// The domain this mission belongs to (e.g., 'career', 'finance').
  final String owningDomain;
  
  final MissionStatus status;

  /// IDs of Evidence nodes backing this mission.
  final List<String> relatedEvidenceIds;

  /// IDs of Timeline events associated with this mission.
  final List<String> relatedTimelineEventIds;

  /// ID of the North Star goal this mission contributes to.
  final String? relatedNorthStarGoalId;

  final String? parentMissionId;
  final List<String> childMissionIds;
  
  /// IDs of missions that must be completed before this one.
  final List<String> dependencies;

  final int? estimatedDurationMinutes;
  final int? estimatedEnergyRequirement;
  
  /// Estimated probability of success (0.0 - 1.0).
  final double successProbability;
  
  final MissionPriority priority;
  
  /// Qualitative importance (1-10).
  final int importance;
  
  /// Qualitative urgency (1-10).
  final int urgency;

  final DateTime? dueDate;

  /// Completion progress (0.0 to 1.0).
  final double progress;

  /// Description of how this mission is verified.
  final String? verificationMethod;

  /// ID of the evidence node produced upon completion.
  final String? completionEvidenceId;

  final String? aiNotes;
  final String? userNotes;

  /// JSON metadata for explainability engine.
  final Map<String, dynamic> explainabilityMetadata;

  final double alignmentScore;
  final DateTime createdAt;
  final DateTime? completedAt;

  /// Additional domain-specific metadata.
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        owningDomain,
        status,
        relatedEvidenceIds,
        relatedTimelineEventIds,
        relatedNorthStarGoalId,
        parentMissionId,
        childMissionIds,
        dependencies,
        estimatedDurationMinutes,
        estimatedEnergyRequirement,
        successProbability,
        priority,
        importance,
        urgency,
        dueDate,
        progress,
        verificationMethod,
        completionEvidenceId,
        aiNotes,
        userNotes,
        explainabilityMetadata,
        alignmentScore,
        createdAt,
        completedAt,
        metadata,
      ];

  Mission copyWith({
    MissionStatus? status,
    double? progress,
    int? estimatedDurationMinutes,
    int? estimatedEnergyRequirement,
    double? successProbability,
    MissionPriority? priority,
    int? importance,
    int? urgency,
    DateTime? dueDate,
    DateTime? completedAt,
    String? completionEvidenceId,
    String? aiNotes,
    String? userNotes,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? explainabilityMetadata,
  }) {
    return Mission(
      id: id,
      title: title,
      description: description,
      type: type,
      owningDomain: owningDomain,
      status: status ?? this.status,
      relatedEvidenceIds: relatedEvidenceIds,
      relatedTimelineEventIds: relatedTimelineEventIds,
      relatedNorthStarGoalId: relatedNorthStarGoalId,
      parentMissionId: parentMissionId,
      childMissionIds: childMissionIds,
      dependencies: dependencies,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      estimatedEnergyRequirement: estimatedEnergyRequirement ?? this.estimatedEnergyRequirement,
      successProbability: successProbability ?? this.successProbability,
      priority: priority ?? this.priority,
      importance: importance ?? this.importance,
      urgency: urgency ?? this.urgency,
      dueDate: dueDate ?? this.dueDate,
      progress: progress ?? this.progress,
      verificationMethod: verificationMethod,
      completionEvidenceId: completionEvidenceId ?? this.completionEvidenceId,
      aiNotes: aiNotes ?? this.aiNotes,
      userNotes: userNotes ?? this.userNotes,
      explainabilityMetadata: explainabilityMetadata ?? this.explainabilityMetadata,
      alignmentScore: alignmentScore,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool? get stringify => true;
}
