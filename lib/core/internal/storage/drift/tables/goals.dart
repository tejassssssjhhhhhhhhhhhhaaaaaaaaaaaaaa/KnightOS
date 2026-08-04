import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'missions.dart';

@DataClassName('GoalData')
class GoalTable extends KnightTable {
  @override
  String get tableName => 'goals';

  TextColumn get missionId => text().references(MissionTable, #id)();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
}
