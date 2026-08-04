import '../domain/entities/mission.dart';

/// Interface for pluggable prioritization engines.
abstract class IMissionPrioritizer {
  /// Ranks a list of missions based on internal intelligence rules.
  Future<List<Mission>> rank(List<Mission> missions);
}
