import '../entities/mission.dart';

/// Interface for domains to register their mission sources with the central MissionService.
abstract class IMissionProvider {
  /// The domain this provider serves (e.g., 'career').
  String get domain;

  /// Returns missions specific to this domain.
  Future<List<Mission>> getMissions();

  /// Called when a mission status changes in the central service.
  Future<void> onMissionUpdated(Mission mission);
}
