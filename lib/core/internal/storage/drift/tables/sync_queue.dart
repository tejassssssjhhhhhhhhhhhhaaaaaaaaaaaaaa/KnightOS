import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Buffer for preparing cloud synchronization or multi-device propagation.
@DataClassName('SyncQueueData')
class SyncQueueTable extends KnightTable {
  @override
  String get tableName => 'sync_queue';

  /// Primary key of the record needing sync.
  TextColumn get recordId => text()();

  /// The table name.
  TextColumn get targetTable => text()();

  /// UPSERT, DELETE.
  TextColumn get action => text()();

  /// pending, processing, completed, failed.
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// When the record entered the queue.
  @override
  DateTimeColumn get createdAt => dateTime()();
}
