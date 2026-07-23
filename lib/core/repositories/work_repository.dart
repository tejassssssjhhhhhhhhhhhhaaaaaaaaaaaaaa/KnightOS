import '../../features/work_tracker/domain/work_session.dart';
import '../storage/local_database.dart';
import '../storage/storage_keys.dart';

class WorkRepository {
  WorkRepository({LocalDatabase? localDatabase}) : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<WorkSession>> loadSessions() async {
    final decoded = await _database.readJsonList(StorageKeys.workSessions);
    if (decoded == null) {
      return <WorkSession>[];
    }

    return decoded
        .map((item) => WorkSession.fromJson(item as Map<String, Object?>))
        .toList(growable: false);
  }

  Future<void> saveSessions(List<WorkSession> sessions) async {
    await _database.writeJsonList(
      StorageKeys.workSessions,
      sessions.map((session) => session.toJson()).toList(growable: false),
    );
  }

  Future<void> saveSession(WorkSession session) async {
    final sessions = await loadSessions();
    final index = sessions.indexWhere((entry) => entry.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
    await saveSessions(sessions);
  }

  Future<void> deleteSession(String id) async {
    final sessions = await loadSessions();
    sessions.removeWhere((session) => session.id == id);
    await saveSessions(sessions);
  }
}
