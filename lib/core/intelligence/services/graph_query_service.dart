import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';

/// Central gateway for Knowledge Graph traversals.
/// 
/// All feature modules MUST use this service instead of direct DAO access
/// to ensure Trust Scores and Data Governance policies are enforced.
class GraphQueryService {
  GraphQueryService({required this.db});
  final KnightDatabase db;

  /// Fetches a specific node by its ID.
  Future<GraphNodeData?> getNode(String id) async {
    final node = await db.knowledgeGraphDao.getNodeById(id);
    if (node == null || node.isDeleted) return null;
    return node;
  }

  /// Finds nodes by their type (e.g., 'person', 'transaction').
  Future<List<GraphNodeData>> findNodesByType(String type) async {
    final nodes = await db.knowledgeGraphDao.findNodesByType(type);
    return nodes.where((n) => !n.isDeleted).toList();
  }

  /// Retrieves all nodes related to [nodeId].
  /// [relationship] can be used to filter by relationship type (e.g., 'ownership').
  /// [minTrust] ensures only results with high enough confidence are returned.
  Future<List<GraphNodeData>> getRelatedNodes(
    String nodeId, {
    String? relationship,
    double minTrust = 0.0,
  }) async {
    // 1. Get edges
    final edges = await db.knowledgeGraphDao.getEdgesForNode(nodeId);
    
    // 2. Filter edges
    final filteredEdges = edges.where((e) {
      if (relationship != null && e.relationship != relationship) return false;
      if (e.trustScore < minTrust) return false;
      return true;
    });

    if (filteredEdges.isEmpty) return [];

    // 3. Get target node IDs
    final targetIds = filteredEdges.map((e) => e.fromNodeId == nodeId ? e.toNodeId : e.fromNodeId).toSet();
    
    // 4. Fetch and filter nodes
    final nodes = await db.knowledgeGraphDao.getNodesByIds(targetIds.toList());
    return nodes.where((n) => !n.isDeleted && n.trustScore >= minTrust).toList();
  }

  /// Performs a semantic search across the graph.
  Future<List<GraphNodeData>> semanticSearch(String query) async {
     // Placeholder for vector-based graph search
     return [];
  }
}

final graphQueryServiceProvider = Provider<GraphQueryService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return GraphQueryService(db: db);
});
