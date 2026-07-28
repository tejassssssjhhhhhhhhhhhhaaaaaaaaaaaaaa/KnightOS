import 'package:flutter/foundation.dart';
import 'memory_metadata.dart';
import 'memory_category.dart';
import 'memory_domain.dart';
import 'memory_version.dart';
import 'memory_relation.dart';
import 'evidence.dart';

/// Represents a unified piece of intelligence within KnightOS,
/// aligned with the v1.0 Master Memory Specification.
@immutable
class KnightMemory {
  const KnightMemory({
    required this.metadata,
    required this.version,
    required this.content,
    this.summary,
    this.importance = 0.5,
    this.sourceLinks = const [],
    this.relationships = const [],
  });

  /// Common metadata substrate.
  final MemoryMetadata metadata;

  /// Temporal evolution data.
  final MemoryVersion version;

  /// The domain-specific JSON payload.
  final Map<String, dynamic> content;

  /// Short textual summary of the memory.
  final String? summary;

  /// Subjective importance (0.0 to 1.0).
  final double importance;

  /// List of pointers to verifiable evidence artifacts.
  final List<SourceLink> sourceLinks;

  /// Direct semantic links to other memories.
  final List<MemoryRelation> relationships;

  // --- Convenience Getters ---
  String get id => metadata.versionId;
  String get memoryId => metadata.memoryId;
  BookCategory get category => metadata.category;
  double get confidence => metadata.confidence;
  MemorySource get source => metadata.source;
  DateTime get effectiveAt => metadata.effectiveAt;
  DateTime get recordedAt => metadata.recordedAt;
  DateTime get updatedAt => metadata.updatedAt;
  List<String> get tags => metadata.tags;
  bool get isLatest => metadata.isLatest;
  String? get prevVersionId => version.previousVersionId;
  int get versionNumber => version.versionNumber;
  bool get verified => metadata.verified;
  DateTime? get lastVerifiedAt => metadata.lastVerifiedAt;
  List<Map<String, dynamic>> get verificationHistory =>
      metadata.verificationHistory;
  String? get questionId => metadata.questionId;
  KnowledgeState get state => metadata.knowledgeState;
  String? get explanation => metadata.explanation;
  List<double>? get embedding => metadata.embedding;
  Map<String, dynamic> get semanticMetadata => metadata.semanticMetadata;

  /// Factory for creating new memories with default versioning and metadata.
  static KnightMemory create({
    required String memoryId,
    required BookCategory category,
    required MemoryDomain domain,
    required MemorySource source,
    required Map<String, dynamic> content,
    String? summary,
    double importance = 0.5,
    double confidence = 1.0,
    DateTime? effectiveAt,
    String provenance = 'local',
    List<String> tags = const [],
    List<SourceLink> sourceLinks = const [],
    List<MemoryRelation> relationships = const [],
    String? reasoning,
    bool verified = false,
    String? questionId,
    KnowledgeState knowledgeState = KnowledgeState.observed,
    String? explanation,
    List<double>? embedding,
    Map<String, dynamic> semanticMetadata = const {},
  }) {
    return KnightMemory(
      metadata: MemoryMetadata(
        memoryId: memoryId,
        effectiveAt: effectiveAt ?? DateTime.now(),
        confidence: confidence,
        source: source,
        provenance: provenance,
        domain: domain,
        category: category,
        tags: tags,
        verified: verified,
        questionId: questionId,
        knowledgeState: knowledgeState,
        explanation: explanation,
        embedding: embedding,
        semanticMetadata: semanticMetadata,
      ),
      version: MemoryVersion(
        versionNumber: 1,
        changeType: ChangeType.creation,
        reasoning: reasoning ?? "Initial record",
      ),
      content: content,
      summary: summary,
      importance: importance,
      sourceLinks: sourceLinks,
      relationships: relationships,
    );
  }

  KnightMemory copyWith({
    MemoryMetadata? metadata,
    MemoryVersion? version,
    Map<String, dynamic>? content,
    String? summary,
    double? importance,
    List<SourceLink>? sourceLinks,
    List<MemoryRelation>? relationships,
  }) {
    return KnightMemory(
      metadata: metadata ?? this.metadata,
      version: version ?? this.version,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      importance: importance ?? this.importance,
      sourceLinks: sourceLinks ?? this.sourceLinks,
      relationships: relationships ?? this.relationships,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata.toJson(),
      'version': version.toJson(),
      'content': content,
      'summary': summary,
      'importance': importance,
      'sourceLinks': sourceLinks.map((s) => s.toJson()).toList(),
      'relationships': relationships.map((r) => r.toJson()).toList(),
    };
  }

  factory KnightMemory.fromJson(Map<String, dynamic> json) {
    return KnightMemory(
      metadata: MemoryMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      version: MemoryVersion.fromJson(json['version'] as Map<String, dynamic>),
      content: json['content'] as Map<String, dynamic>,
      summary: json['summary'] as String?,
      importance: (json['importance'] as num).toDouble(),
      sourceLinks: (json['sourceLinks'] as List<dynamic>)
          .map((s) => SourceLink.fromJson(s as Map<String, dynamic>))
          .toList(),
      relationships:
          (json['relationships'] as List<dynamic>?)
              ?.map((r) => MemoryRelation.fromJson(r as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
