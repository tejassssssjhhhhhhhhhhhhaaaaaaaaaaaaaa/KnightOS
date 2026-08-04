import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'goals.dart';

@DataClassName('TaskData')
class TaskTable extends KnightTable {
  @override
  String get tableName => 'tasks';

  TextColumn get goalId => text().references(GoalTable, #id)();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  
  /// critical, high, medium, low
  TextColumn get priority => text().withDefault(const Constant('medium'))();
}
