import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('WorkoutSessionData')
class WorkoutSessionTable extends KnightTable {
  @override
  String get tableName => 'workout_sessions';

  TextColumn get workoutType => text()(); // Strength, Cardio, etc.
  RealColumn get durationMinutes => real()();
  RealColumn get caloriesBurned => real().nullable()();
  TextColumn get intensity => text().withDefault(const Constant('medium'))();
  TextColumn get notes => text().nullable()();
  
  /// Links to the specific date in health_metrics for aggregation.
  DateTimeColumn get startTime => dateTime()();
}
