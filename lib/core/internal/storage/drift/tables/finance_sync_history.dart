import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FinanceSyncHistoryData')
class FinanceSyncHistoryTable extends KnightTable {
  @override
  String get tableName => 'finance_sync_history';

  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  
  IntColumn get emailsScanned => integer().withDefault(const Constant(0))();
  IntColumn get transactionsAdded => integer().withDefault(const Constant(0))();
  IntColumn get duplicatesMerged => integer().withDefault(const Constant(0))();
  IntColumn get parserFailures => integer().withDefault(const Constant(0))();
  IntColumn get repairsExecuted => integer().withDefault(const Constant(0))();
  
  RealColumn get coverageChange => real().nullable()();
  
  TextColumn get overallResult => text()(); // Success, Partial, Failed
  TextColumn get errorLog => text().nullable()();
  
  /// JSON encoded summary for reports
  TextColumn get syncReport => text().nullable()();
}
