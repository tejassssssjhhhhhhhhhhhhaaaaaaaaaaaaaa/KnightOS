import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'graph_nodes.dart';
import 'provenance.dart';
import 'evidence.dart';

@DataClassName('GraphEdgeData')
class GraphEdgeTable extends KnightTable {
  @override
  String get tableName => 'graph_edges';

  TextColumn get fromNodeId => text().references(GraphNodeTable, #id)();
  TextColumn get toNodeId => text().references(GraphNodeTable, #id)();
  
  /// references, attachments, chronology, ownership, financial_link, travel_link, health_link
  TextColumn get relationship => text()();
  
  RealColumn get weight => real().withDefault(const Constant(1.0))();
  
  TextColumn get metadata => text().withDefault(const Constant('{}'))();

  /// Reference to the provenance registry
  TextColumn get provenanceId => text().nullable().references(ProvenanceTable, #id)();

  /// Current trust score (cached from TrustMetricsTable)
  RealColumn get trustScore => real().withDefault(const Constant(1.0))();

  /// Reference to the evidence artifact backing this relationship
  TextColumn get evidenceId => text().nullable().references(EvidenceTable, #id)();

  /// Temporal validity range
  DateTimeColumn get validFrom => dateTime().nullable()();
  DateTimeColumn get validUntil => dateTime().nullable()();
}
