import 'package:equatable/equatable.dart';

/// Represents the intelligent assessment of a professional skill.
class SkillIntelligence extends Equatable {
  const SkillIntelligence({
    required this.name,
    required this.proficiency, // 0.0 to 1.0
    required this.confidence,  // 0.0 to 1.0
    required this.evidenceCount,
    required this.verificationLevel, // 'unverified', 'self-claimed', 'verified', 'expert-verified'
    required this.growthTrend, // 'improving', 'stable', 'declining', 'emerging'
    this.lastUsed,
    this.relatedProjectIds = const [],
    this.relatedCertIds = const [],
    this.relatedTimelineEventIds = const [],
    this.relatedMissionIds = const [],
    this.marketRelevance = 0.5,
    this.learningSuggestions = const [],
  });

  final String name;
  final double proficiency;
  final double confidence;
  final int evidenceCount;
  final String verificationLevel;
  final String growthTrend;
  final DateTime? lastUsed;
  final List<String> relatedProjectIds;
  final List<String> relatedCertIds;
  final List<String> relatedTimelineEventIds;
  final List<String> relatedMissionIds;
  final double marketRelevance;
  final List<String> learningSuggestions;

  @override
  List<Object?> get props => [
        name,
        proficiency,
        confidence,
        evidenceCount,
        verificationLevel,
        growthTrend,
        lastUsed,
        relatedProjectIds,
        relatedCertIds,
        relatedTimelineEventIds,
        relatedMissionIds,
        marketRelevance,
        learningSuggestions,
      ];
}

/// An immutable record of a verified professional success.
class Achievement extends Equatable {
  const Achievement({
    required this.id,
    required this.title,
    this.description,
    required this.category, // 'milestone', 'award', 'project_success', 'certification'
    required this.date,
    required this.evidenceCaid,
    this.timelineEventId,
    this.relatedSkillIds = const [],
    this.missionId,
    this.source = 'manual',
    this.tags = const [],
    this.isVerified = false,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String? description;
  final String category;
  final DateTime date;
  final String evidenceCaid;
  final String? timelineEventId;
  final List<String> relatedSkillIds;
  final String? missionId;
  final String source;
  final List<String> tags;
  final bool isVerified;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        date,
        evidenceCaid,
        timelineEventId,
        relatedSkillIds,
        missionId,
        source,
        tags,
        isVerified,
        metadata,
      ];
}
