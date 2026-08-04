import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FinanceReportData')
class FinanceReportTable extends KnightTable {
  @override
  String get tableName => 'finance_reports';

  TextColumn get name => text()();
  
  /// monthly, quarterly, yearly, custom
  TextColumn get type => text()();
  
  DateTimeColumn get generatedAt => dateTime()();
  
  /// JSON encoded filters used
  TextColumn get filters => text()();
  
  /// Path to the stored PDF/CSV file
  TextColumn get filePath => text().nullable()();
  
  RealColumn get confidenceScore => real().withDefault(const Constant(1.0))();
  
  TextColumn get dataCoverage => text().nullable()();
}
