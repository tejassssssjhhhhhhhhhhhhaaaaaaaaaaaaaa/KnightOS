import '../../../core/repositories/fitness_repository.dart';
import '../../../core/storage/local_database.dart';
import '../domain/gym_profile.dart';
import '../domain/workout_session.dart';
import 'fitness_module_state.dart';

class FitnessStorage {
  FitnessStorage({FitnessRepository? repository, LocalDatabase? localDatabase})
      : _repository = repository ?? FitnessRepository(),
        _database = localDatabase ?? const LocalDatabase();

  final FitnessRepository _repository;
  final LocalDatabase _database;
  static const String _fitnessStateFile = 'fitness_module_state.json';

  Future<List<WorkoutSession>> loadSessions() => _repository.loadSessions();

  Future<void> saveSessions(List<WorkoutSession> sessions) => _repository.saveSessions(sessions);

  Future<void> saveSession(WorkoutSession session) => _repository.saveSession(session);

  Future<void> deleteSession(String id) => _repository.deleteSession(id);

  Future<FitnessModuleState> loadFitnessModuleState() async {
    final decoded = await _database.readJson(_fitnessStateFile);
    if (decoded == null) {
      return FitnessModuleState.initial();
    }

    final rawGymProfile = decoded['gymProfile'];
    final gymProfile = rawGymProfile is Map<String, Object?>
        ? GymProfile.fromJson(rawGymProfile)
        : GymProfile.empty();

    final rawEquipmentIds = decoded['availableEquipmentIds'];
    final availableEquipmentIds = <String>[];
    if (rawEquipmentIds is List) {
      for (final item in rawEquipmentIds) {
        if (item is String) {
          availableEquipmentIds.add(item);
        }
      }
    }

    return FitnessModuleState(
      gymProfile: gymProfile,
      availableEquipmentIds: availableEquipmentIds,
      searchQuery: decoded['searchQuery'] is String ? decoded['searchQuery'] as String : '',
    );
  }

  Future<void> saveFitnessModuleState(FitnessModuleState state) async {
    final payload = <String, Object?>{
      'gymProfile': state.gymProfile.toJson(),
      'availableEquipmentIds': state.availableEquipmentIds,
      'searchQuery': state.searchQuery,
    };
    await _database.writeJson(_fitnessStateFile, payload);
  }
}
