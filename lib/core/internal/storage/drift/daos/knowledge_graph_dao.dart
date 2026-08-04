import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/graph_nodes.dart';
import '../tables/graph_edges.dart';

part 'knowledge_graph_dao.g.dart';

@DriftAccessor(tables: [GraphNodeTable, GraphEdgeTable])
class KnowledgeGraphDao extends DatabaseAccessor<KnightDatabase> with _$KnowledgeGraphDaoMixin {
  KnowledgeGraphDao(super.db);

  Future<GraphNodeData?> getNodeById(String id) {
    return (select(graphNodeTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<GraphNodeData>> getRelatedNodes(String nodeId) async {
    final edges = await (select(graphEdgeTable)
          ..where((t) => t.fromNodeId.equals(nodeId) | t.toNodeId.equals(nodeId)))
        .get();
        
    final nodeIds = edges.map((e) => e.fromNodeId == nodeId ? e.toNodeId : e.fromNodeId).toSet();
    if (nodeIds.isEmpty) return [];
    
    return (select(graphNodeTable)..where((t) => t.id.isIn(nodeIds))).get();
  }

  Future<List<GraphNodeData>> getNodesByIds(List<String> ids) {
    return (select(graphNodeTable)..where((t) => t.id.isIn(ids))).get();
  }

  Future<List<GraphEdgeData>> getEdgesForNode(String nodeId) {
    return (select(graphEdgeTable)
          ..where((t) => t.fromNodeId.equals(nodeId) | t.toNodeId.equals(nodeId)))
        .get();
  }

  Future<List<GraphNodeData>> findNodesByType(String type) {
    return (select(graphNodeTable)..where((t) => t.type.equals(type))).get();
  }

  Future<void> upsertNode(GraphNodeTableCompanion entry) => 
    into(graphNodeTable).insertOnConflictUpdate(entry);

  Future<void> upsertEdge(GraphEdgeTableCompanion entry) => 
    into(graphEdgeTable).insertOnConflictUpdate(entry);
}
