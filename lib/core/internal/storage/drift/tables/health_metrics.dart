import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'import_history.dart';

/// Time-series storage for health and vitality data.
@DataClassName('HealthMetricData')
class HealthMetricTable extends KnightTable {
  @override
  String get tableName => 'health_metrics';

  /// steps, sleep_minutes, heart_rate, etc.
  TextColumn get metricType => text()();

  /// Primary numeric value.
  RealColumn get value => real()();

  /// Units (count, bpm, kcal).
  TextColumn get unit => text()();

  /// Start of the measurement period (or instant).
  DateTimeColumn get startTime => dateTime()();

  /// End of the measurement period (nullable for instants).
  DateTimeColumn get endTime => dateTime().nullable()();

  /// Source (manual, sensor, import).
  TextColumn get source => text()();

  /// Reference to the source import if applicable.
  TextColumn get sourceImportId => text().nullable().references(ImportHistoryTable, #id)();
}
