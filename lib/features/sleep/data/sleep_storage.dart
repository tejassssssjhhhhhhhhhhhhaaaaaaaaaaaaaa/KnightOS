import '../../../core/repositories/sleep_repository.dart';
import '../domain/sleep_session.dart';

class SleepStorage {
  SleepStorage({SleepRepository? repository}) : _repository = repository ?? SleepRepository();

  final SleepRepository _repository;

  Future<List<SleepSession>> loadSessions() async => _repository.loadSessions();

  Future<void> saveSessions(List<SleepSession> sessions) async => _repository.saveSessions(sessions);

  Future<void> saveSession(SleepSession session) async => _repository.saveSession(session);

  Future<void> deleteSession(String id) async => _repository.deleteSession(id);
}
