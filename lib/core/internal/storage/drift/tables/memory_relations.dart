import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Edges in the Knowledge Graph.
@DataClassName('MemoryRelationData')
class MemoryRelationTable extends KnightTable {
  @override
  String get tableName => 'memory_relations';

  /// Source memory node (MemoryID).
  TextColumn get sourceId => text()();

  /// Target memory node (MemoryID).
  TextColumn get targetId => text()();

  /// parent, child, influences, caused_by, duplicate, derived_from, references.
  TextColumn get type => text()();

  /// 0.0 to 1.0 link strength.
  RealColumn get strength => real().withDefault(const Constant(1.0))();

  /// JSON metadata for the edge.
  TextColumn get metadata => text().withDefault(const Constant('{}'))();

  /// When the relationship was established.
  @override
  DateTimeColumn get createdAt => dateTime()();
}
