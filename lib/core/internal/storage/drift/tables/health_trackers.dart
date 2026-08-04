import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('HealthTrackerData')
class HealthTrackerTable extends KnightTable {
  @override
  String get tableName => 'health_trackers';

  /// constipation, pain, mood, recovery
  TextColumn get trackerType => text()();
  
  /// numeric value (e.g. pain level 1-10, mood 1-5, constipation Bristol scale)
  IntColumn get value => integer().nullable()();
  
  TextColumn get notes => text().nullable()();
  
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
