import '../../features/fitness/domain/workout_session.dart';
import '../storage/local_database.dart';
import '../storage/storage_keys.dart';

class FitnessRepository {
  FitnessRepository({LocalDatabase? localDatabase}) : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<WorkoutSession>> loadSessions() async {
    final decoded = await _database.readJsonList(StorageKeys.fitnessSessions);
    if (decoded == null) {
      return <WorkoutSession>[];
    }

    return decoded.map((item) => WorkoutSession.fromJson(item as Map<String, Object?>)).toList(growable: false);
  }

  Future<void> saveSessions(List<WorkoutSession> sessions) async {
    await _database.writeJsonList(
      StorageKeys.fitnessSessions,
      sessions.map((session) => session.toJson()).toList(growable: false),
    );
  }

  Future<void> saveSession(WorkoutSession session) async {
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
