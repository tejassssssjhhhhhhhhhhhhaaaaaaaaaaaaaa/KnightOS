import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Lightweight system state snapshots for the "Time Machine".
@DataClassName('SystemSnapshot')
class SystemSnapshotsTable extends KnightTable {
  @override
  String get tableName => 'system_snapshots';

  /// What triggered this snapshot (e.g., 'Sync Complete', 'Manual').
  TextColumn get trigger => text()();

  /// Comprehensive system metrics in JSON.
  /// {dbVersion, emailCount, entityCount, healthScore, queueSize, etc.}
  TextColumn get stateData => text()();

  @override
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
