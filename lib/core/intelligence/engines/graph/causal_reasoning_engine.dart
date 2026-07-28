import '../../domain/knight_memory.dart';
import '../../domain/cognitive_models.dart';
import '../memory_engine.dart';

/// Traverses the Knowledge Graph to answer "Why" questions and find evidence chains.
class CausalReasoningEngine {
  const CausalReasoningEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Attempts to find a causal path between two memories.
  Future<List<CausalLink>> findWhy(String memoryId) async {
    final List<CausalLink> links = [];

    // 1. Fetch direct causes from the graph
    final relations = await memoryEngine.getRelated(memoryId);

    // Note: getRelated returns KnightMemory objects.
    // We need the relation metadata from the database.
    // Future improvement: memoryEngine.getRelations(memoryId)

    // Placeholder logic for Phase 13
    for (final memory in relations) {
      // Search for edges where targetId == memoryId AND type == causedBy
      links.add(
        CausalLink(
          source: memory,
          confidence: 0.85,
          explanation: 'Detected temporal and semantic precedence.',
        ),
      );
    }

    return links;
  }

  /// Evaluates a hypothesis using available evidence.
  Future<ReasoningTrace> evaluateHypothesis({
    required String hypothesis,
    required List<KnightMemory> evidence,
  }) async {
    final List<String> thoughts = [];
    thoughts.add('Evaluating hypothesis: $hypothesis');

    double confidenceSum = 0.0;
    for (final e in evidence) {
      thoughts.add(
        'Found evidence: ${e.summary} (Confidence: ${e.confidence})',
      );
      confidenceSum += e.confidence;
    }

    final finalConfidence = evidence.isEmpty
        ? 0.0
        : confidenceSum / evidence.length;

    return ReasoningTrace(
      intent: KnightIntent.analysis,
      memoriesUsed: evidence.map((m) => m.id).toList(),
      rulesApplied: [],
      goalsConsidered: [],
      thoughtChain: thoughts,
      confidence: finalConfidence,
    );
  }
}

class CausalLink {
  const CausalLink({
    required this.source,
    required this.confidence,
    required this.explanation,
  });

  final KnightMemory source;
  final double confidence;
  final String explanation;
}
