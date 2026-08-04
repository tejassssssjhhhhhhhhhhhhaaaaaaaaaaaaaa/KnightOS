import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Universal audit log for Knowledge Graph changes (Nodes & Edges).
@DataClassName('GraphHistoryData')
class GraphHistoryTable extends KnightTable {
  @override
  String get tableName => 'graph_history';

  TextColumn get entityId => text()();
  
  /// node, edge
  TextColumn get entityType => text()();

  /// JSON snapshot of the state before the change
  TextColumn get previousState => text().nullable()();

  /// JSON snapshot of the state after the change
  TextColumn get newState => text().nullable()();

  TextColumn get changeType => text()(); // create, update, delete, merge

  TextColumn get changeReason => text().nullable()();
  
  TextColumn get agentId => text().nullable()();
}
