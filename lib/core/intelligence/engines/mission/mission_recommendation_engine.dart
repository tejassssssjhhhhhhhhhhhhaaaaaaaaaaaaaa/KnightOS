import '../../domain/intelligence_models.dart';
import '../../domain/cognitive_models.dart';
import 'mission_planning_engine.dart';

class MissionRecommendationEngine {
  const MissionRecommendationEngine();

  Future<List<IntelligenceResult>> generateRecommendations(
    List<MissionRecommendation> adaptiveRecs,
  ) async {
    return adaptiveRecs
        .map(
          (r) => IntelligenceResult(
            id: 'mission-rec-${DateTime.now().millisecondsSinceEpoch}',
            data: r.title,
            trace: ReasoningTrace(
              intent: KnightIntent.planning,
              memoriesUsed: r.evidenceIds,
              rulesApplied: [],
              goalsConsidered: [],
              thoughtChain: [r.description],
              confidence: r.confidence,
            ),
            generatedAt: DateTime.now(),
            version: 1,
            evidenceHash: 'mission-hash',
          ),
        )
        .toList();
  }
}
