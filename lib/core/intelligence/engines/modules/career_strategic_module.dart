import 'dart:async';
import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/knight_memory.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_domain.dart';
import '../../../domain/entities/strategic_models.dart';
import '../../../domain/entities/insight.dart';
import '../strategic/gap_analysis_engine.dart';
import '../memory_engine.dart';
import '../memory_retrieval_engine.dart';

/// Intelligence module specializing in Strategic Career growth.
class CareerStrategicModule extends IntelligenceModule {
  CareerStrategicModule({
    required this.retrieval,
    required this.memoryEngine,
    required this.gapEngine,
  });

  final MemoryRetrievalEngine retrieval;
  final MemoryEngine memoryEngine;
  final GapAnalysisEngine gapEngine;

  @override
  String get id => 'career_strategic';

  @override
  double get priority => 90.0; 

  @override
  List<BookCategory> get inputCategories => [BookCategory.career, BookCategory.skills];

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    if (event is DataChangedEvent) {
      final relevant = event.memories.any((m) => 
        m.metadata.category == BookCategory.career || 
        m.metadata.category == BookCategory.skills
      );
      if (relevant) {
        await _generateStrategicInsights();
      }
    }
  }

  Future<void> _generateStrategicInsights() async {
    final memories = await retrieval.getByCategory(BookCategory.career);
    final northStars = memories
        .where((m) => m.tags.contains('north_star'))
        .map(_mapToNorthStar)
        .toList();

    for (final ns in northStars) {
      final report = await gapEngine.analyze(ns);
      
      final insight = Insight(
        id: 'strat-gap-${ns.id}',
        title: 'Career Gap Analysis',
        recommendation: report.highestImpactAction,
        confidence: _mapConfidence(report.confidence),
        reasoningPath: ReasoningPath(
          steps: [
            LogicStep(description: 'Compared current Skill DNA against target: ${ns.targetState}'),
            LogicStep(description: 'Identified missing competencies: ${report.missingSkills.join(', ')}'),
          ],
          risks: ['Stagnation in current role without ${report.missingSkills.firstOrNull ?? 'growth'}'],
        ),
        createdAt: DateTime.now(),
      );

      // Cache or publish the insight
      await memoryEngine.save(KnightMemory.create(
        memoryId: insight.id,
        category: BookCategory.career,
        domain: MemoryDomain.career,
        source: MemorySource.aiGenerated,
        content: insight.metadata,
        summary: insight.title,
        tags: ['strategic_insight'],
        confidence: report.confidence,
      ));
    }
  }

  NorthStar _mapToNorthStar(KnightMemory memory) {
    return NorthStar(
      id: memory.memoryId,
      lifeVisionId: memory.content['lifeVisionId'] ?? 'primary',
      title: memory.content['title'] ?? 'Untitled North Star',
      domain: 'career',
      targetState: memory.content['targetState'],
      progress: (memory.content['progress'] as num?)?.toDouble() ?? 0.0,
      priority: (memory.content['priority'] as int?) ?? 5,
      createdAt: memory.effectiveAt,
    );
  }

  ConfidenceLevel _mapConfidence(double score) {
    if (score > 0.9) return ConfidenceLevel.veryHigh;
    if (score > 0.7) return ConfidenceLevel.high;
    if (score > 0.4) return ConfidenceLevel.medium;
    return ConfidenceLevel.low;
  }
  
  @override
  Future<List<IntelligenceResult>> getInsights() async {
    return [];
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async {
    return [];
  }

  @override
  Future<List<String>> getBriefingItems() async {
    return ['Review your North Star gap analysis for new opportunities.'];
  }
}
