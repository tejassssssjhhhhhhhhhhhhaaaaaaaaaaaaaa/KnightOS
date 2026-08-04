import '../entities/mission.dart';

/// Interface for managing Mission persistence.
abstract class IMissionRepository {
  Future<void> storeMission(Mission mission);
  Future<Mission?> getById(String id);
  Future<List<Mission>> getActiveMissions();
  Future<List<Mission>> getAll();
  Future<void> deleteMission(String id);
}
