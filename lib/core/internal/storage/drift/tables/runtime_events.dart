import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Persisted logs for the "Black Box" Runtime Recorder.
@DataClassName('RuntimeEvent')
class RuntimeEventsTable extends KnightTable {
  @override
  String get tableName => 'runtime_events';

  /// sync, auth, database, worker, security, lifecycle.
  TextColumn get category => text()();

  /// info, warning, error, critical.
  TextColumn get severity => text().withDefault(const Constant('info'))();

  TextColumn get message => text()();

  /// Optional JSON data for structured debugging.
  TextColumn get metadata => text().nullable()();

  /// User session ID or Sync Batch ID.
  TextColumn get sessionId => text().nullable()();

  @override
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
