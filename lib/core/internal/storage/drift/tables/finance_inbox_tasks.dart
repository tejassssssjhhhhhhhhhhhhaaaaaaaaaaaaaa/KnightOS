import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FinanceInboxTaskData')
class FinanceInboxTaskTable extends KnightTable {
  @override
  String get tableName => 'finance_inbox_tasks';

  /// Task types: Needs Categorization, Missing Statement, Possible Duplicate, Unsupported Format, etc.
  TextColumn get taskType => text()();
  TextColumn get description => text().nullable()();
  TextColumn get priority => text().withDefault(const Constant('medium'))(); // low, medium, high, critical
  RealColumn get confidence => real().nullable()();
  TextColumn get institution => text().nullable()();
  TextColumn get engineSource => text().nullable()();
  
  TextColumn get messageId => text().nullable()();
  TextColumn get transactionId => text().nullable()();
  
  /// Status: pending, resolved, ignored, reminded
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  TextColumn get resolution => text().nullable()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  TextColumn get resolutionMetadata => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
}
