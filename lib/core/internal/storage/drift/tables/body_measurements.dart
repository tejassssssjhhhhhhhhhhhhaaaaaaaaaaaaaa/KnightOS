import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('BodyMeasurementData')
class BodyMeasurementTable extends KnightTable {
  @override
  String get tableName => 'body_measurements';

  /// weight, bmi, body_fat, waist_circumference, hip_circumference, neck_circumference
  TextColumn get measurementType => text()();
  
  RealColumn get value => real()();
  TextColumn get unit => text()();
  
  DateTimeColumn get measuredAt => dateTime().withDefault(currentDateAndTime)();
}
