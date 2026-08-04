import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/reminders.dart';

part 'reminder_dao.g.dart';

@DriftAccessor(tables: [ReminderTable])
class ReminderDao extends BaseDao<ReminderTable, ReminderData>
    with _$ReminderDaoMixin {
  ReminderDao(super.db);

  Future<List<ReminderData>> getPendingReminders() {
    return (select(reminderTable)..where((t) => t.status.equals('pending'))).get();
  }
}
