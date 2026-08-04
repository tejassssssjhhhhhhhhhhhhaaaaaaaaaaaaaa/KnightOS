// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_graph_dao.dart';

// ignore_for_file: type=lint
mixin _$KnowledgeGraphDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ProvenanceTableTable get provenanceTable => attachedDatabase.provenanceTable;
  $CanonicalIdentityTableTable get canonicalIdentityTable =>
      attachedDatabase.canonicalIdentityTable;
  $GraphNodeTableTable get graphNodeTable => attachedDatabase.graphNodeTable;
  $EvidenceTableTable get evidenceTable => attachedDatabase.evidenceTable;
  $GraphEdgeTableTable get graphEdgeTable => attachedDatabase.graphEdgeTable;
  KnowledgeGraphDaoManager get managers => KnowledgeGraphDaoManager(this);
}

class KnowledgeGraphDaoManager {
  final _$KnowledgeGraphDaoMixin _db;
  KnowledgeGraphDaoManager(this._db);
  $$ProvenanceTableTableTableManager get provenanceTable =>
      $$ProvenanceTableTableTableManager(
        _db.attachedDatabase,
        _db.provenanceTable,
      );
  $$CanonicalIdentityTableTableTableManager get canonicalIdentityTable =>
      $$CanonicalIdentityTableTableTableManager(
        _db.attachedDatabase,
        _db.canonicalIdentityTable,
      );
  $$GraphNodeTableTableTableManager get graphNodeTable =>
      $$GraphNodeTableTableTableManager(
        _db.attachedDatabase,
        _db.graphNodeTable,
      );
  $$EvidenceTableTableTableManager get evidenceTable =>
      $$EvidenceTableTableTableManager(_db.attachedDatabase, _db.evidenceTable);
  $$GraphEdgeTableTableTableManager get graphEdgeTable =>
      $$GraphEdgeTableTableTableManager(
        _db.attachedDatabase,
        _db.graphEdgeTable,
      );
}
