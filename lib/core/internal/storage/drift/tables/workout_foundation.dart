import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('ExerciseData')
class ExerciseLibraryTable extends KnightTable {
  @override
  String get tableName => 'exercise_library';

  TextColumn get name => text()();
  TextColumn get category => text()(); // Strength, Cardio, Flexibility, etc.
  TextColumn get targetMuscles => text().nullable()(); // comma-separated
  
  TextColumn get description => text().nullable()();
  TextColumn get animationUrl => text().nullable()();
  
  BoolColumn get requiresEquipment => boolean().withDefault(const Constant(false))();
}

@DataClassName('EquipmentData')
class EquipmentProfileTable extends KnightTable {
  @override
  String get tableName => 'equipment_profiles';

  TextColumn get name => text()();
  TextColumn get type => text()(); // Barbell, Dumbbell, Machine, etc.
  
  RealColumn get weightUnitIncrement => real().withDefault(const Constant(2.5))();
  
  BoolColumn get isOwned => boolean().withDefault(const Constant(false))();
}
