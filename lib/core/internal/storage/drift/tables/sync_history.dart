import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Execution records for provider synchronization cycles.
@DataClassName('SyncHistoryData')
class SyncHistoryTable extends KnightTable {
  @override
  String get tableName => 'sync_history';

  /// The provider identifier (e.g., 'gmail_api', 'google_calendar_api').
  TextColumn get providerId => text()();

  /// When the sync cycle started.
  DateTimeColumn get startTime => dateTime()();

  /// When the sync cycle ended.
  DateTimeColumn get endTime => dateTime().nullable()();

  /// 'success', 'failed', 'partial', 'in_progress'.
  TextColumn get status => text()();

  /// Number of records fetched from source.
  IntColumn get fetchedCount => integer().withDefault(const Constant(0))();

  /// Number of new records created in local database.
  IntColumn get createdCount => integer().withDefault(const Constant(0))();

  /// Number of existing records updated.
  IntColumn get updatedCount => integer().withDefault(const Constant(0))();

  /// Number of records skipped (e.g., already up to date).
  IntColumn get skippedCount => integer().withDefault(const Constant(0))();

  /// Number of records that failed to process.
  IntColumn get failedCount => integer().withDefault(const Constant(0))();

  /// Summary of errors encountered.
  TextColumn get errorSummary => text().nullable()();
}
