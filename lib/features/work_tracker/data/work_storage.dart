import '../../../core/repositories/work_repository.dart';
import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/work_profile.dart';
import '../domain/work_session.dart';
import 'work_module_state.dart';

class WorkStorage {
  WorkStorage({WorkRepository? repository, LocalDatabase? localDatabase})
      : _repository = repository ?? WorkRepository(),
        _database = localDatabase ?? const LocalDatabase();

  final WorkRepository _repository;
  final LocalDatabase _database;

  Future<List<WorkSession>> loadSessions() async {
    final moduleState = await loadWorkModuleState();
    return moduleState.sessions;
  }

  Future<WorkModuleState> loadWorkModuleState() async {
    final decoded = await _database.readJson(StorageKeys.workModuleState);
    if (decoded != null) {
      return WorkModuleState.fromJson(decoded);
    }

    final sessions = await _repository.loadSessions();
    return WorkModuleState(
      profile: WorkProfile.empty(),
      sessions: sessions,
      dailyTarget: 0,
      searchQuery: '',
    );
  }

  Future<void> saveWorkModuleState(WorkModuleState state) async {
    await _database.writeJson(StorageKeys.workModuleState, state.toJson());
  }

  Future<void> saveSessions(List<WorkSession> sessions) async {
    final state = await loadWorkModuleState();
    await saveWorkModuleState(state.copyWith(sessions: sessions));
  }

  Future<void> saveSession(WorkSession session) async {
    final state = await loadWorkModuleState();
    final sessions = List<WorkSession>.from(state.sessions);
    final index = sessions.indexWhere((entry) => entry.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
    await saveWorkModuleState(state.copyWith(sessions: sessions));
  }

  Future<void> deleteSession(String id) async {
    final state = await loadWorkModuleState();
    final sessions = state.sessions.where((entry) => entry.id != id).toList(growable: false);
    await saveWorkModuleState(state.copyWith(sessions: sessions));
  }
}
