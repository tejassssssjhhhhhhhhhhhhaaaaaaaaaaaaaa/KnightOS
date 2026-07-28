import '../../domain/health_models.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/cognitive_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

class MedicationIntelligence {
  const MedicationIntelligence({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  Future<Map<String, dynamic>> analyzeMedication() async {
    final memories = await retrieval.getByCategory(BookCategory.health);
    final medicationRecords =
        memories
            .where((m) => m.healthDataType == HealthDataType.medication)
            .map((m) => m.toMedicationRecord()!)
            .toList()
          ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    if (medicationRecords.isEmpty) return {'status': 'No data'};

    final last30Days = medicationRecords
        .where(
          (r) => r.scheduledAt.isAfter(
            DateTime.now().subtract(const Duration(days: 30)),
          ),
        )
        .toList();

    if (last30Days.isEmpty) return {'status': 'No recent data'};

    final adherenceCount = last30Days.where((r) => r.isAdhered).length;
    final adherenceRate = adherenceCount / last30Days.length;

    return {
      'adherenceRate': adherenceRate,
      'totalScheduled': last30Days.length,
      'missedCount': last30Days.length - adherenceCount,
      'latestMedication': last30Days.first.medicineName,
    };
  }

  Future<List<IntelligenceResult>> getInsights() async {
    final analysis = await analyzeMedication();
    if (analysis['status'] != null) return [];

    final List<IntelligenceResult> insights = [];
    final rate = analysis['adherenceRate'] as double;

    if (rate < 0.9) {
      insights.add(
        IntelligenceResult(
          id: 'insight-medication-adherence',
          data:
              'Medication adherence is at ${(rate * 100).toStringAsFixed(0)}% this month. Consistency is key for effectiveness.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [],
            rulesApplied: ['Adherence Monitoring'],
            goalsConsidered: ['Medical Management'],
            thoughtChain: [
              'Aggregated adherence flags across all scheduled doses for 30 days.',
            ],
            confidence: 1.0,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'medication-hash',
        ),
      );
    }

    return insights;
  }
}
