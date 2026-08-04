import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('DeviceHealthData')
class DeviceHealthTable extends KnightTable {
  @override
  String get tableName => 'device_health';

  @override
  TextColumn get deviceId => text()();
  
  IntColumn get batteryLevel => integer()();
  
  BoolColumn get isCharging => boolean()();
  
  IntColumn get storageUsedBytes => integer().nullable()();
  
  TextColumn get networkType => text().nullable()(); // wifi, cellular, none
  
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
