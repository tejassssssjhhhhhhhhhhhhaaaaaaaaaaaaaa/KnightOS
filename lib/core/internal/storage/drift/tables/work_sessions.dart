import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('WorkSessionTableData')
class WorkSessionTable extends KnightTable {
  TextColumn get workDate => text()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get shiftType => text()();
  IntColumn get questionsCompleted => integer()();
  IntColumn get callsHandled => integer()();
  IntColumn get chatsHandled => integer()();
  IntColumn get breakDuration => integer()();
  IntColumn get focusRating => integer()();
  IntColumn get stressRating => integer()();
  IntColumn get energyRating => integer()();
  TextColumn get notes => text()();
  RealColumn get totalHours => real()();
  RealColumn get productiveHours => real()();
  RealColumn get callsPercentage => real()();
  RealColumn get chatsPercentage => real()();
  RealColumn get questionsPerHour => real()();
  RealColumn get weeklyAverage => real()();
  RealColumn get monthlyAverage => real()();
}
