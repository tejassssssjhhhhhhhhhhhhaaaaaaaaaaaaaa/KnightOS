import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'provenance.dart';
import 'canonical_identities.dart';

@DataClassName('GraphNodeData')
class GraphNodeTable extends KnightTable {
  @override
  String get tableName => 'graph_nodes';

  @override
  List<Set<Column>> get uniqueKeys => [
    {type, label},
    {externalTable, externalId},
  ];

  /// person, place, organization, flight, hotel, transaction, task, goal, health_record, document, email, device, timeline_event
  TextColumn get type => text()();
  
  TextColumn get label => text()();
  
  /// Optional primary key mapping to another table if this node represents a structured record.
  TextColumn get externalTable => text().nullable()();
  TextColumn get externalId => text().nullable()();
  
  TextColumn get metadata => text().withDefault(const Constant('{}'))();

  /// Reference to the provenance registry
  TextColumn get provenanceId => text().nullable().references(ProvenanceTable, #id)();

  /// Current trust score (cached from TrustMetricsTable)
  RealColumn get trustScore => real().withDefault(const Constant(1.0))();

  /// Whether this is a system-verified canonical node
  BoolColumn get isCanonical => boolean().withDefault(const Constant(false))();

  /// Reference to the canonical identity if applicable
  TextColumn get canonicalId => text().nullable().references(CanonicalIdentityTable, #id)();

  /// Quick access to governance classification
  TextColumn get governanceLabel => text().withDefault(const Constant('private'))();
}
