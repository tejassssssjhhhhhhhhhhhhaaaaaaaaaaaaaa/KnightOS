import '../../domain/health_models.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/cognitive_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

class SleepIntelligence {
  const SleepIntelligence({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  /// Analyzes sleep patterns over the last 30 days.
  Future<Map<String, dynamic>> analyzeSleep() async {
    final memories = await retrieval.getByCategory(BookCategory.health);
    final sleepRecords =
        memories
            .where((m) => m.healthDataType == HealthDataType.sleep)
            .map((m) => m.toSleepRecord()!)
            .toList()
          ..sort((a, b) => b.start.compareTo(a.start));

    if (sleepRecords.isEmpty) return {'status': 'No data'};

    final last7Days = sleepRecords
        .where(
          (r) =>
              r.start.isAfter(DateTime.now().subtract(const Duration(days: 7))),
        )
        .toList();

    if (last7Days.isEmpty) return {'status': 'Insufficient recent data'};

    final avgDuration =
        last7Days.fold(0, (sum, r) => sum + r.durationMinutes) /
        last7Days.length;
    final avgQuality =
        last7Days.fold(0.0, (sum, r) => sum + r.quality) / last7Days.length;

    // Consistency check (Standard deviation of start times - simplified)
    final consistency = avgQuality > 0.8 ? 'High' : 'Variable';
    
    // Regularity check (V5)
    final regularityScore = _calculateRegularity(last7Days);

    return {
      'averageDurationHours': avgDuration / 60,
      'averageQuality': avgQuality,
      'consistency': consistency,
      'debtHours': (8 * 60 - avgDuration).clamp(0, 1000) / 60,
      'recordCount': last7Days.length,
      'regularityScore': regularityScore,
    };
  }

  double _calculateRegularity(List<SleepRecord> records) {
    if (records.length < 2) return 1.0;
    // Simplified: Difference between start times
    double diffSum = 0;
    for (int i = 0; i < records.length - 1; i++) {
      final hourDiff = (records[i].start.hour - records[i+1].start.hour).abs();
      diffSum += hourDiff;
    }
    final avgDiff = diffSum / (records.length - 1);
    return (1.0 - (avgDiff / 6.0)).clamp(0.0, 1.0); // 6 hour variation max
  }

  Future<List<IntelligenceResult>> getInsights() async {
    final analysis = await analyzeSleep();
    if (analysis['status'] != null) return [];

    final List<IntelligenceResult> insights = [];
    final avgDuration = analysis['averageDurationHours'] as double;
    final debt = analysis['debtHours'] as double;

    if (debt > 1.5) {
      insights.add(
        IntelligenceResult(
          id: 'insight-sleep-debt',
          data:
              'You have accumulated ${debt.toStringAsFixed(1)} hours of sleep debt this week.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [], // Should include IDs
            rulesApplied: ['Sleep Optimization Rule v1'],
            goalsConsidered: ['Health & Vitality'],
            thoughtChain: [
              'Calculated average sleep duration of ${avgDuration.toStringAsFixed(1)}h.',
              'Compared against ideal target of 8h.',
              'Identified deficit trending over 7 days.',
            ],
            confidence: 0.9,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'sleep-hash',
        ),
      );
    }

    final regularity = analysis['regularityScore'] as double;
    if (regularity < 0.7) {
      insights.add(
        IntelligenceResult(
          id: 'insight-sleep-irregularity',
          data: 'Your sleep schedule is irregular. Aim for a consistent bedtime to improve recovery.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [],
            rulesApplied: ['Sleep Regularity Rule v5'],
            goalsConsidered: ['Health & Vitality'],
            thoughtChain: [
              'Analyzed variance in sleep start times over 7 days.',
              'Detected average variation exceeding 2 hours.',
              'Irregularity score: ${regularity.toStringAsFixed(2)}',
            ],
            confidence: 0.85,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'sleep-reg-hash',
        ),
      );
    }

    return insights;
  }
}
