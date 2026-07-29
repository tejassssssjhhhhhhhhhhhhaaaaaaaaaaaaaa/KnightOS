import '../../domain/knight_memory.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_relation.dart';
import '../memory_engine.dart';
import '../memory_retrieval_engine.dart';

/// Automatically discovers relationships and patterns within the timeline.
class RelationshipDiscoveryEngine {
  const RelationshipDiscoveryEngine({
    required this.memoryEngine,
    required this.retrieval,
  });

  final MemoryEngine memoryEngine;
  final MemoryRetrievalEngine retrieval;

  /// Analyzes recent memories to find recurring sequences (Routines).
  Future<void> discoverRoutines() async {
    // 1. Fetch recent events (last 30 days)
    final now = DateTime.now();
    final events = await retrieval.getByDateRange(
      now.subtract(const Duration(days: 30)),
      now,
    );

    // 2. Sort by effectiveAt
    events.sort((a, b) => a.effectiveAt.compareTo(b.effectiveAt));

    // 3. Find sequential patterns (A followed by B)
    // Simplified algorithm for Phase 13
    final Map<String, Map<String, int>> transitions = {};

    for (int i = 0; i < events.length - 1; i++) {
      final a = events[i];
      final b = events[i + 1];

      // Only care about events on the same day within a reasonable timeframe (e.g. 4 hours)
      if (b.effectiveAt.difference(a.effectiveAt).inHours < 4 &&
          a.effectiveAt.day == b.effectiveAt.day) {
        final keyA = _getEventKey(a);
        final keyB = _getEventKey(b);

        transitions.putIfAbsent(keyA, () => {});
        transitions[keyA]![keyB] = (transitions[keyA]![keyB] ?? 0) + 1;
      }
    }

    // 4. If pattern repeats > X times, establish 'happensBefore' relation
    for (final sourceEntry in transitions.entries) {
      for (final targetEntry in sourceEntry.value.entries) {
        if (targetEntry.value >= 3) {
          // Find representative memories to link (or link classes/types if the graph supported it)
          // For now, we link the latest occurrences.
        }
      }
    }
  }

  /// Discovers implicit links between memories based on shared metadata or tags.
  Future<List<MemoryRelation>> discoverImplicitLinks() async {
    final List<MemoryRelation> inferred = [];
    
    // 1. Fetch a broad sample of memories
    final all = await retrieval.search('');
    
    // 2. Pairwise comparison (Naive O(n^2) for this sprint, targeted in V4)
    for (int i = 0; i < all.length; i++) {
      for (int j = i + 1; j < all.length; j++) {
        final a = all[i];
        final b = all[j];
        
        // Rule: Shared specific tags
        final commonTags = a.tags.toSet().intersection(b.tags.toSet());
        if (commonTags.length >= 2) {
          inferred.add(MemoryRelation(
            sourceId: a.memoryId,
            targetId: b.memoryId,
            type: MemoryRelationType.relatesTo,
            strength: 0.5 + (0.1 * commonTags.length).clamp(0.0, 0.4),
            metadata: {'reason': 'Shared tags: ${commonTags.join(", ")}'},
          ));
        }

        // Rule: Cross-domain correlation (Mock: Finance -> Travel)
        if (a.category == BookCategory.finance && b.category == BookCategory.history) {
          if (a.summary != null && b.summary != null && 
              a.summary!.contains('Flight') && b.summary!.contains('Trip')) {
             inferred.add(MemoryRelation(
              sourceId: a.memoryId,
              targetId: b.memoryId,
              type: MemoryRelationType.influences,
              strength: 0.9,
              metadata: {'reason': 'Financial record likely caused by travel event'},
            ));
          }
        }
      }
    }

    return inferred;
  }

  String _getEventKey(KnightMemory m) {
    // Group by category and a content-based identifier (e.g. workout type)
    return '${m.category.name}:${m.summary ?? 'unknown'}';
  }
}
