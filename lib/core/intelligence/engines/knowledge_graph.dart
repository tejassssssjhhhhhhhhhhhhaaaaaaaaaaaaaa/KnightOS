import '../domain/knight_memory.dart';
import '../domain/memory_relation.dart';
import 'memory_engine.dart';

/// Manages relationships and traversals within the KnightOS knowledge graph.
///
/// The Knowledge Graph connects memories (nodes) through typed relations (edges),
/// allowing the OS to understand impact, causality, and semantic connections.
class KnowledgeGraph {
  const KnowledgeGraph({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Establishes a typed relationship between two memories.
  Future<void> associate({
    required String sourceId,
    required String targetId,
    required MemoryRelationType type,
    double strength = 1.0,
  }) async {
    await memoryEngine.link(sourceId, targetId, type.name, strength: strength);
  }

  /// Retrieves memories directly connected to the given memory.
  Future<List<KnightMemory>> getRelated(String memoryId) {
    return memoryEngine.getRelated(memoryId);
  }

  /// Finds memories that influenced the given memory.
  Future<List<KnightMemory>> getInfluencers(String memoryId) async {
    final all = await memoryEngine.getRelated(memoryId);
    // Future: Filter by relationType == influences
    return all;
  }
}
