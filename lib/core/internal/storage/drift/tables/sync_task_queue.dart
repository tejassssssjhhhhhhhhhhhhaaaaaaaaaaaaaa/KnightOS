import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Persistent priority queue for inbound data processing tasks.
@DataClassName('SyncTask')
class SyncTaskQueueTable extends KnightTable {
  @override
  String get tableName => 'sync_task_queue';

  /// Provider responsible for this task.
  TextColumn get providerId => text()();

  /// Type of task (e.g., 'parse_email', 'generate_summary').
  TextColumn get taskType => text()();

  /// JSON payload containing required data to execute the task.
  TextColumn get payload => text()();

  /// 0 (Highest) to 10 (Lowest).
  IntColumn get priority => integer().withDefault(const Constant(5))();

  /// Number of times this task has failed.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// pending, processing, completed, failed, dead_letter.
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Last error message if failed.
  TextColumn get lastError => text().nullable()();

  @override
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
