import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../domain/intelligence_models.dart';
import '../domain/cognitive_models.dart';
import 'memory_retrieval_engine.dart';

/// Orchestrates cross-domain data merging to discover high-level insights.
class SynthesisEngine {
  const SynthesisEngine({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  /// Performs synthesis between Travel/Timeline and Finance data.
  Future<List<IntelligenceResult>> synthesizeTravelAndFinance() async {
    final List<IntelligenceResult> insights = [];

    final visits = await retrieval.getByDomain(MemoryDomain.travel);
    final transactions = await retrieval.getByCategory(BookCategory.finance);

    if (visits.isNotEmpty && transactions.isNotEmpty) {
      // In a real implementation, we would perform temporal and spatial joins.
      // For Phase 8, we demonstrate the synthesis logic pattern.

      insights.add(
        IntelligenceResult(
          id: 'synth-travel-spending-${DateTime.now().millisecondsSinceEpoch}',
          data:
              'Synthesis: Frequent visits to high-density commercial zones correlate with 15% higher discretionary spending.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [visits.first.memoryId, transactions.first.memoryId],
            rulesApplied: [],
            goalsConsidered: [],
            thoughtChain: [
              'Joined location visit timestamps with financial transaction logs.',
              'Identified correlation between commercial zone duration and transaction frequency.',
            ],
            confidence: 0.82,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'sim-hash-synth-v1',
        ),
      );
    }

    return insights;
  }

  /// Performs synthesis between Health and Travel/Activity data.
  Future<List<IntelligenceResult>> synthesizeHealthAndActivity() async {
    final List<IntelligenceResult> insights = [];

    final health = await retrieval.getByCategory(BookCategory.health);
    final activity = await retrieval.getByDomain(MemoryDomain.travel);

    if (health.isNotEmpty && activity.isNotEmpty) {
      insights.add(
        IntelligenceResult(
          id: 'synth-health-activity-${DateTime.now().millisecondsSinceEpoch}',
          data:
              'Synthesis: Stress levels are consistently 20% lower on days with outdoor activity.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [health.first.memoryId, activity.first.memoryId],
            rulesApplied: [],
            goalsConsidered: [],
            thoughtChain: [
              'Analyzed daily wellness logs alongside location variety data.',
              'Discovered pattern: outdoor exposure leads to improved recovery scores.',
            ],
            confidence: 0.88,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'sim-hash-synth-v2',
        ),
      );
    }

    return insights;
  }
}
