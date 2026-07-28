import '../../domain/health_models.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/cognitive_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

class FitnessIntelligence {
  const FitnessIntelligence({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  Future<Map<String, dynamic>> analyzeFitness() async {
    final memories = await retrieval.getByCategory(BookCategory.health);
    final exerciseRecords =
        memories
            .where((m) => m.healthDataType == HealthDataType.exercise)
            .map((m) => m.toExerciseRecord()!)
            .toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (exerciseRecords.isEmpty) return {'status': 'No data'};

    // Streak calculation
    int streak = 0;
    DateTime checkDate = DateTime.now();
    for (final record in exerciseRecords) {
      final diff = checkDate.difference(record.timestamp).inDays;
      if (diff <= 1) {
        streak++;
        checkDate = record.timestamp;
      } else {
        break;
      }
    }

    final strengthWorkouts = exerciseRecords.where((r) => r.isStrength).length;
    final cardioWorkouts = exerciseRecords.where((r) => r.isCardio).length;

    return {
      'streak': streak,
      'totalWorkouts': exerciseRecords.length,
      'strengthCount': strengthWorkouts,
      'cardioCount': cardioWorkouts,
      'lastWorkoutAt': exerciseRecords.first.timestamp.toIso8601String(),
    };
  }

  Future<List<IntelligenceResult>> getInsights() async {
    final analysis = await analyzeFitness();
    if (analysis['status'] != null) return [];

    final List<IntelligenceResult> insights = [];
    final streak = analysis['streak'] as int;

    if (streak >= 3) {
      insights.add(
        IntelligenceResult(
          id: 'insight-fitness-streak',
          data:
              'You are on a $streak-day workout streak! Keep up the momentum.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [],
            rulesApplied: [],
            goalsConsidered: ['Fitness'],
            thoughtChain: [
              'Aggregated recent exercise logs.',
              'Detected consecutive daily activity.',
            ],
            confidence: 1.0,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'fitness-hash',
        ),
      );
    }

    return insights;
  }
}
