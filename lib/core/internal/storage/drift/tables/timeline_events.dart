import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'import_history.dart';

/// Aggregated life events from location history and other sources.
@DataClassName('TimelineEventData')
class TimelineEventTable extends KnightTable {
  @override
  String get tableName => 'timeline_events';

  /// visit, activity, milestone, meeting, task.
  TextColumn get type => text()();

  /// User-friendly label (e.g., "Visited Starbucks").
  TextColumn get title => text()();

  /// Start timestamp.
  DateTimeColumn get startTime => dateTime()();

  /// End timestamp.
  DateTimeColumn get endTime => dateTime()();

  /// Geographic location if applicable (JSON or lat/lng string).
  TextColumn get location => text().nullable()();

  /// Metadata (JSON) for specific type info.
  TextColumn get metadata => text().nullable()();

  /// Reference to the source import.
  TextColumn get sourceImportId => text().nullable().references(ImportHistoryTable, #id)();

  // Origin Tracking (M1 Requirement)
  TextColumn get originProviderId => text().nullable()();
  TextColumn get originResourceId => text().nullable()();
  TextColumn get originThreadId => text().nullable()();
  TextColumn get syncBatchId => text().nullable()();

  // Confidence Framework (M1 Requirement)
  RealColumn get confidenceScore => real().nullable()(); // 0.0-1.0
  TextColumn get confidenceReason => text().nullable()();
  TextColumn get verificationState => text().withDefault(const Constant('UNVERIFIED'))();
}
