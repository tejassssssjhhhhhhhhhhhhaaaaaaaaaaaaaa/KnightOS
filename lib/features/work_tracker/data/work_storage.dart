import '../../../core/repositories/work_repository.dart';
import '../../../core/platform/storage/storage_engine.dart';
import '../domain/work_session.dart';
import 'work_module_state.dart';

class WorkStorage {
  WorkStorage({required StorageEngine engine, WorkRepository? repository})
    : _repository = repository ?? WorkRepository(engine: engine);

  final WorkRepository _repository;

  Future<List<WorkSession>> loadSessions() async {
    final moduleState = await loadWorkModuleState();
    return moduleState.sessions;
  }

  Future<WorkModuleState> loadWorkModuleState() async {
    // Legacy mapping preserved for now.
    // This will move to real SQLite queries in Phase 2.2
    return WorkModuleState.initial();
  }

  Future<void> saveWorkModuleState(WorkModuleState state) async {
    // To be implemented in Phase 2.2
  }

  Future<void> saveSessions(List<WorkSession> sessions) async {
    await _repository.saveSessions(sessions);
  }

  Future<void> saveSession(WorkSession session) async {
    await _repository.saveSession(session);
  }

  Future<void> deleteSession(String id) async {
    await _repository.deleteSession(id);
  }
}
