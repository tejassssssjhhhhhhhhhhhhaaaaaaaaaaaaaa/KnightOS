import 'dart:convert';
import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';

class KnowledgeGraphService {
  KnowledgeGraphService({required this.db});
  final KnightDatabase db;

  /// Ensures an entity exists as a node in the graph and returns its ID.
  Future<String> ensureNode({
    required String type,
    required String label,
    String? externalTable,
    String? externalId,
    Map<String, dynamic> metadata = const {},
  }) async {
    return await db.transaction(() async {
      // 1. Check if external record already mapped
      if (externalTable != null && externalId != null) {
        final existing = await (db.select(db.graphNodeTable)
              ..where((t) => t.externalTable.equals(externalTable))
              ..where((t) => t.externalId.equals(externalId)))
            .get().then((l) => l.firstOrNull);
        if (existing != null) return existing.id;
      }

      // 2. Check by type and label if no external mapping
      final existingByLabel = await (db.select(db.graphNodeTable)
            ..where((t) => t.type.equals(type))
            ..where((t) => t.label.equals(label)))
          .get().then((l) => l.firstOrNull);
      if (existingByLabel != null) return existingByLabel.id;

      // 3. Create new node
      final id = 'node-${DateTime.now().microsecondsSinceEpoch}';
      try {
        await db.into(db.graphNodeTable).insert(GraphNodeTableCompanion.insert(
          id: id,
          type: type,
          label: label,
          externalTable: Value(externalTable),
          externalId: Value(externalId),
          metadata: Value(jsonEncode(metadata)),
        ));
        return id;
      } catch (e) {
        // Double check in case of race condition
        final fallback = await (db.select(db.graphNodeTable)
            ..where((t) => (t.type.equals(type) & t.label.equals(label)) | 
                           (t.externalTable.equals(externalTable ?? '') & t.externalId.equals(externalId ?? ''))))
            .getSingleOrNull();
        if (fallback != null) return fallback.id;
        rethrow;
      }
    });
  }

  /// Establishes a directional relationship between two nodes.
  Future<void> link({
    required String fromId,
    required String toId,
    required String relationship,
    double weight = 1.0,
    Map<String, dynamic> metadata = const {},
  }) async {
    final id = 'edge-$fromId-$toId-$relationship';
    await db.into(db.graphEdgeTable).insertOnConflictUpdate(GraphEdgeTableCompanion.insert(
      id: id,
      fromNodeId: fromId,
      toNodeId: toId,
      relationship: relationship,
      weight: Value(weight),
      metadata: Value(jsonEncode(metadata)),
    ));
  }
}
