import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Tracks the origin and ingestion context for every piece of data in the graph.
@DataClassName('ProvenanceData')
class ProvenanceTable extends KnightTable {
  @override
  String get tableName => 'provenance_registry';

  /// email, device, web, manual, calendar, filesystem, health_connect
  TextColumn get sourceType => text()();

  /// Universal URI for the source (e.g., gmail://message_id, file:///path)
  TextColumn get sourceUri => text()();

  /// background_sync, user_import, live_capture
  TextColumn get ingestionMethod => text()();

  /// Agent or Parser ID that processed this data
  TextColumn get agentId => text().nullable()();

  /// Original timestamp from the source if available
  DateTimeColumn get sourceCreatedAt => dateTime().nullable()();

  /// Trust score assigned at time of ingestion
  RealColumn get initialTrustScore => real().withDefault(const Constant(1.0))();
}
