import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('SleepSessionData')
class SleepSessionTable extends KnightTable {
  @override
  String get tableName => 'sleep_sessions';

  DateTimeColumn get bedTime => dateTime()();
  DateTimeColumn get wakeTime => dateTime()();
  
  IntColumn get sleepQuality => integer().withDefault(const Constant(5))(); // 1-10
  IntColumn get wakeUps => integer().withDefault(const Constant(0))();
  
  TextColumn get moodAfterWaking => text().nullable()();
  TextColumn get notes => text().nullable()();
}
