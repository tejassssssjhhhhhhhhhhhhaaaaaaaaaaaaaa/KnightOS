import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('WorkoutSessionData')
class WorkoutSessionTable extends KnightTable {
  @override
  String get tableName => 'workout_sessions';

  TextColumn get workoutType => text()(); // e.g. "Morning Push", "Cardio"
  RealColumn get durationMinutes => real().withDefault(const Constant(0))();
  RealColumn get caloriesBurned => real().nullable()();
  TextColumn get intensity => text().withDefault(const Constant('medium'))();
  TextColumn get notes => text().nullable()();
  
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();
  BoolColumn get mobilityCompleted => boolean().withDefault(const Constant(false))();

  /// Links to the specific date in health_metrics for aggregation.
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
}

@DataClassName('WorkoutSetData')
class WorkoutSetTable extends KnightTable {
  @override
  String get tableName => 'workout_sets';

  TextColumn get id => text()();
  TextColumn get sessionId => text().references(WorkoutSessionTable, #id)();
  TextColumn get exerciseName => text()();
  
  RealColumn get weight => real().withDefault(const Constant(0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer().nullable()();
  
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  IntColumn get setOrder => integer()();
  
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
