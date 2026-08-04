import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/work_sessions.dart';

part 'work_tracker_dao.g.dart';

@DriftAccessor(tables: [WorkSessionTable])
class WorkTrackerDao extends DatabaseAccessor<KnightDatabase> with _$WorkTrackerDaoMixin {
  WorkTrackerDao(super.db);

  Future<List<WorkSessionTableData>> getAllSessions() => 
    (select(workSessionTable)..orderBy([(t) => OrderingTerm.desc(t.workDate)])).get();

  Future<List<WorkSessionTableData>> getSessionsForDate(String date) =>
    (select(workSessionTable)..where((t) => t.workDate.equals(date))).get();

  Future<List<WorkSessionTableData>> getRecentSessions({int limit = 10}) =>
    (select(workSessionTable)..orderBy([(t) => OrderingTerm.desc(t.workDate)])..limit(limit)).get();

  Future<void> upsertSession(WorkSessionTableCompanion entry) => 
    into(workSessionTable).insertOnConflictUpdate(entry);

  Future<void> deleteSession(String id) => 
    (delete(workSessionTable)..where((t) => t.id.equals(id))).go();
}
