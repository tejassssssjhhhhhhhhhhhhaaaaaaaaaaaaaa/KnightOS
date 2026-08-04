import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FinanceGoalData')
class FinanceGoalTable extends KnightTable {
  @override
  String get tableName => 'finance_goals';

  TextColumn get name => text()();
  
  /// emergency_fund, vehicle, home, travel, education, investment, custom
  TextColumn get type => text()();
  
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0.0))();
  
  DateTimeColumn get targetDate => dateTime().nullable()();
  
  /// low, medium, high, critical
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  
  /// active, completed, paused, cancelled
  TextColumn get status => text().withDefault(const Constant('active'))();
  
  /// JSON encoded metadata for auto-tracking (e.g., linked accounts or categories)
  TextColumn get trackingRules => text().nullable()();
}
