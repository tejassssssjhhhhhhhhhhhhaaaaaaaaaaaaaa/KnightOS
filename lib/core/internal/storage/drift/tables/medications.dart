import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('MedicationData')
class MedicationTable extends KnightTable {
  @override
  String get tableName => 'medications';

  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get frequency => text()(); // e.g. "once daily", "twice daily"
  
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  
  TextColumn get notes => text().nullable()();
}

@DataClassName('MedicationLogData')
class MedicationLogTable extends KnightTable {
  @override
  String get tableName => 'medication_logs';

  TextColumn get medicationId => text().references(MedicationTable, #id)();
  
  DateTimeColumn get takenAt => dateTime().withDefault(currentDateAndTime)();
  
  BoolColumn get isAdhered => boolean().withDefault(const Constant(true))();
}
