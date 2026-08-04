import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('ContextHistoryData')
class ContextHistoryTable extends KnightTable {
  @override
  String get tableName => 'context_history';

  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  
  TextColumn get contextJson => text()();
  
  TextColumn get fusionLogJson => text().nullable()();
  
  RealColumn get healthScore => real()();
  
  TextColumn get platformVersion => text()();
}

@DataClassName('ContextSnapshotData')
class ContextSnapshotsTable extends KnightTable {
  @override
  String get tableName => 'context_snapshots';

  TextColumn get name => text()();
  
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  
  TextColumn get contextJson => text()();
  
  TextColumn get metadata => text().nullable()();
}
