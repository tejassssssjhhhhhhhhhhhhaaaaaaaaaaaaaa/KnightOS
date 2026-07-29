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

  /// Performs a semantic traversal to find the root causes (causedBy/influences).
  Future<List<KnightMemory>> findCausalChain(String memoryId, {int maxDepth = 4}) async {
    final List<KnightMemory> chain = [];
    final Set<String> visited = {memoryId};
    String currentId = memoryId;

    for (var i = 0; i < maxDepth; i++) {
      final neighbors = await memoryEngine.getRelated(currentId);
      // Logic: Find first neighbor with a causal link type
      // Note: getRelated currently doesn't return the edge type.
      // In a real V4 impl, we'd query for links of type 'causedBy' or 'influences'.
      if (neighbors.isEmpty) break;

      final influencer = neighbors.first; // Simplified for now
      if (!visited.contains(influencer.memoryId)) {
        visited.add(influencer.memoryId);
        chain.add(influencer);
        currentId = influencer.memoryId;
      } else {
        break;
      }
    }
    return chain;
  }

  /// Retrieves memories within N hops, ranked by semantic strength.
  Future<List<KnightMemory>> getDeeplyRelated(String memoryId, {int hops = 2}) async {
    final path = await findPath(startId: memoryId, maxDepth: hops);
    // Future: Rank by path weight (strength)
    return path;
  }

  /// Performs a semantic traversal to find deep connections (BFS).
  Future<List<KnightMemory>> findPath({
    required String startId,
    int maxDepth = 3,
  }) async {
    final List<KnightMemory> results = [];
    final Set<String> visited = {startId};
    final List<String> queue = [startId];
    int currentDepth = 0;

    while (queue.isNotEmpty && currentDepth < maxDepth) {
      final layerSize = queue.length;
      for (var i = 0; i < layerSize; i++) {
        final currentId = queue.removeAt(0);
        final neighbors = await memoryEngine.getRelated(currentId);
        
        for (final neighbor in neighbors) {
          if (!visited.contains(neighbor.memoryId)) {
            visited.add(neighbor.memoryId);
            results.add(neighbor);
            queue.add(neighbor.memoryId);
          }
        }
      }
      currentDepth++;
    }
    return results;
  }
}
