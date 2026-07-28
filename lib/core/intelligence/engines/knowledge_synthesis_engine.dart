import '../domain/knight_memory.dart';
import '../domain/intelligence_models.dart';
import '../domain/cognitive_models.dart';
import 'memory_retrieval_engine.dart';

/// Generates evidence-backed summaries and cross-domain syntheses.
class KnowledgeSynthesisEngine {
  const KnowledgeSynthesisEngine({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  /// Summarizes a set of memories into a single intelligence result.
  Future<IntelligenceResult<String>> summarize(
    List<KnightMemory> memories, {
    required String title,
    required KnightIntent intent,
  }) async {
    if (memories.isEmpty) {
      return _emptyResult(title, intent);
    }

    final buffer = StringBuffer();
    buffer.writeln('Summary of $title:');

    // Group by category
    final Map<String, List<KnightMemory>> grouped = {};
    for (final m in memories) {
      grouped.putIfAbsent(m.category.label, () => []).add(m);
    }

    for (final entry in grouped.entries) {
      buffer.writeln('\n[${entry.key}]');
      for (final m in entry.value) {
        buffer.writeln('- ${m.summary ?? m.id}');
      }
    }

    return IntelligenceResult(
      id: 'summary-${DateTime.now().millisecondsSinceEpoch}',
      data: buffer.toString(),
      trace: ReasoningTrace(
        intent: intent,
        memoriesUsed: memories.map((m) => m.id).toList(),
        rulesApplied: [],
        goalsConsidered: [],
        thoughtChain: [
          'Aggregated ${memories.length} memories across ${grouped.length} categories.',
          'Synthesized chronological events into thematic blocks.',
        ],
        confidence: 0.9,
      ),
      generatedAt: DateTime.now(),
      version: 1,
      evidenceHash: 'evidence-${memories.length}',
    );
  }

  IntelligenceResult<String> _emptyResult(String title, KnightIntent intent) {
    return IntelligenceResult(
      id: 'empty-summary',
      data: 'No evidence found to summarize $title.',
      trace: ReasoningTrace(
        intent: intent,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: [],
        thoughtChain: ['Zero records matching criteria.'],
        confidence: 1.0,
      ),
      generatedAt: DateTime.now(),
      version: 1,
      evidenceHash: 'none',
    );
  }
}
