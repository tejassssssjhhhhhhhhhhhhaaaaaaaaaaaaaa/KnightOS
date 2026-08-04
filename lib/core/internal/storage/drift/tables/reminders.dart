import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Foundation for the Reminder Engine.
@DataClassName('ReminderData')
class ReminderTable extends KnightTable {
  @override
  String get tableName => 'reminders';

  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  
  /// When the reminder should trigger.
  DateTimeColumn get dueDate => dateTime()();

  /// pending, completed, snoozed, dismissed.
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Priority level (1-5).
  IntColumn get priority => integer().withDefault(const Constant(3))();

  /// Linked entity in the Knowledge Graph.
  TextColumn get linkedNodeId => text().nullable()();

  // Origin Tracking (M1 Requirement)
  TextColumn get originProviderId => text().nullable()();
  TextColumn get originResourceId => text().nullable()();

  // Confidence Framework (M1 Requirement)
  IntColumn get confidenceScore => integer().nullable()(); // 0-100
  TextColumn get verificationState => text().withDefault(const Constant('UNVERIFIED'))();
}
