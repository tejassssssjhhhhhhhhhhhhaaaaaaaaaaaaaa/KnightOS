import '../../features/work_tracker/domain/work_session.dart';
import '../platform/repository/knight_repository.dart';

class WorkRepository extends KnightRepository<WorkSession> {
  WorkRepository({required super.engine});

  Future<List<WorkSession>> loadSessions() async {
    // This will be implemented with real DAO queries in Phase 2.2
    return <WorkSession>[];
  }

  Future<void> saveSessions(List<WorkSession> sessions) async {
    await runTransaction(() async {
      for (final session in sessions) {
        await upsert(session);
      }
    });
  }

  Future<void> saveSession(WorkSession session) => upsert(session);

  Future<void> deleteSession(String id) async {
    // Soft delete logic will move here in Phase 2.2
  }
}
