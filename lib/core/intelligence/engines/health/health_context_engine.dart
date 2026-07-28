import '../../domain/health_models.dart';
import '../../domain/knight_memory.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

enum HealthState {
  sleeping,
  awake,
  working,
  recovering,
  exercising,
  traveling,
  restDay,
  sickDay,
  fasted,
  hydrated,
}

/// Determines the user's current health-related state by analyzing recent records.
class HealthContextEngine {
  const HealthContextEngine({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  /// Infers the current health states based on memory.
  Future<Set<HealthState>> determineCurrentStates() async {
    final Set<HealthState> states = {};
    final now = DateTime.now();

    // 1. Check Sleep State
    // In a real implementation, we'd check if a sleep session is 'open' or ended < 30 mins ago.

    // 2. Check Exercise State
    final recentExercise = await _getRecent(HealthDataType.exercise, 1);
    if (recentExercise.isNotEmpty) {
      final exercise = recentExercise.first.toExerciseRecord();
      if (exercise != null && now.difference(exercise.timestamp).inHours < 2) {
        states.add(HealthState.exercising);
      }
    }

    // 3. Check Sick State (Symptoms)
    final recentSymptoms = await _getRecent(HealthDataType.symptom, 24);
    if (recentSymptoms.isNotEmpty) {
      final latestSymptom = recentSymptoms.first.toSymptomRecord();
      if (latestSymptom != null && latestSymptom.severity > 5) {
        states.add(HealthState.sickDay);
      }
    }

    // 4. Check Hydration State
    final todayHydration = await _getRecent(HealthDataType.hydration, 12);
    if (todayHydration.isNotEmpty) {
      final hydration = todayHydration.first.toHydrationRecord();
      if (hydration != null && hydration.amountMl >= hydration.dailyGoalMl) {
        states.add(HealthState.hydrated);
      }
    }

    // Fallback
    if (states.isEmpty) states.add(HealthState.awake);

    return states;
  }

  Future<List<KnightMemory>> _getRecent(HealthDataType type, int hours) async {
    final memories = await retrieval.getByCategory(BookCategory.health);
    final cutoff = DateTime.now().subtract(Duration(hours: hours));

    return memories.where((m) {
      final mType = m.content['healthDataType'] as String?;
      return mType == type.name && m.effectiveAt.isAfter(cutoff);
    }).toList()..sort((a, b) => b.effectiveAt.compareTo(a.effectiveAt));
  }
}
