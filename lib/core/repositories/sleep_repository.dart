import '../../features/sleep/domain/sleep_session.dart';
import '../storage/local_database.dart';
import '../storage/storage_keys.dart';

class SleepRepository {
  SleepRepository({LocalDatabase? localDatabase})
    : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<SleepSession>> loadSessions() async {
    final decoded = await _database.readJsonList(StorageKeys.sleepSessions);
    if (decoded == null) {
      return <SleepSession>[];
    }

    return decoded
        .map((item) => SleepSession.fromJson(item as Map<String, Object?>))
        .toList(growable: false);
  }

  Future<void> saveSessions(List<SleepSession> sessions) async {
    await _database.writeJsonList(
      StorageKeys.sleepSessions,
      sessions.map((session) => session.toJson()).toList(growable: false),
    );
  }

  Future<void> saveSession(SleepSession session) async {
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
