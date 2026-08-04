import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FinanceBudgetData')
class FinanceBudgetTable extends KnightTable {
  @override
  String get tableName => 'finance_budgets';

  TextColumn get name => text()();
  
  /// category, merchant, overall, etc.
  TextColumn get type => text()();
  
  TextColumn get targetId => text().nullable()(); // category name or merchant name
  
  RealColumn get allocatedAmount => real()();
  
  /// monthly, weekly, yearly
  TextColumn get period => text().withDefault(const Constant('monthly'))();
  
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
