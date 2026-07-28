import '../../domain/mission_models.dart';

class MissionForecastingEngine {
  const MissionForecastingEngine();

  /// Estimates the completion date for a mission.
  Future<DateTime?> forecastCompletionDate(
    Mission mission,
    double progress,
    double momentum,
  ) async {
    if (momentum <= 0.0) return null;

    final remainingProgress = 1.0 - progress;
    final estimatedDays = (remainingProgress / (momentum * 0.1))
        .round(); // Highly simplified

    return DateTime.now().add(Duration(days: estimatedDays));
  }

  /// Estimates the probability of success.
  Future<double> forecastSuccessProbability(
    Mission mission,
    List<String> blockers,
  ) async {
    double base = 0.8;
    base -= blockers.length * 0.15;
    return base.clamp(0.0, 1.0);
  }
}
