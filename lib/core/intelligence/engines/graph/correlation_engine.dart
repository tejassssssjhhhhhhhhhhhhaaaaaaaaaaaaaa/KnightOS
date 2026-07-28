import 'dart:math';
import '../../domain/knight_memory.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

/// Calculates correlations between different domain metrics.
class CorrelationEngine {
  const CorrelationEngine({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  /// Calculates the Pearson Correlation Coefficient between two sets of memory metrics.
  Future<CorrelationResult> correlate({
    required BookCategory categoryA,
    required String fieldA,
    required BookCategory categoryB,
    required String fieldB,
  }) async {
    final memoriesA = await retrieval.getByCategory(categoryA);
    final memoriesB = await retrieval.getByCategory(categoryB);

    // 1. Align data points by date (Daily buckets)
    final Map<String, double> valuesA = _bucketByDay(memoriesA, fieldA);
    final Map<String, double> valuesB = _bucketByDay(memoriesB, fieldB);

    final List<double> listA = [];
    final List<double> listB = [];

    for (final day in valuesA.keys) {
      if (valuesB.containsKey(day)) {
        listA.add(valuesA[day]!);
        listB.add(valuesB[day]!);
      }
    }

    if (listA.length < 5) {
      return const CorrelationResult(
        score: 0.0,
        confidence: 0.0,
        evidenceCount: 0,
      );
    }

    // 2. Calculate Pearson Correlation
    final score = _calculatePearson(listA, listB);

    return CorrelationResult(
      score: score,
      confidence: (listA.length / 30).clamp(
        0.0,
        1.0,
      ), // Higher confidence with more data
      evidenceCount: listA.length,
    );
  }

  Map<String, double> _bucketByDay(List<KnightMemory> memories, String field) {
    final Map<String, double> buckets = {};
    for (final m in memories) {
      final val = double.tryParse(m.content[field]?.toString() ?? '');
      if (val != null) {
        final day =
            '${m.effectiveAt.year}-${m.effectiveAt.month}-${m.effectiveAt.day}';
        buckets[day] = val; // Overwrites if multiple on same day (Simplified)
      }
    }
    return buckets;
  }

  double _calculatePearson(List<double> x, List<double> y) {
    final n = x.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;

    for (int i = 0; i < n; i++) {
      sumX += x[i];
      sumY += y[i];
      sumXY += x[i] * y[i];
      sumX2 += x[i] * x[i];
      sumY2 += y[i] * y[i];
    }

    final numerator = n * sumXY - sumX * sumY;
    final denominator = sqrt(
      (n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY),
    );

    if (denominator == 0) return 0.0;
    return numerator / denominator;
  }
}

class CorrelationResult {
  const CorrelationResult({
    required this.score,
    required this.confidence,
    required this.evidenceCount,
  });

  final double score; // -1.0 to 1.0
  final double confidence;
  final int evidenceCount;

  String get interpretation {
    if (score > 0.7) return 'Strong Positive';
    if (score > 0.3) return 'Weak Positive';
    if (score < -0.7) return 'Strong Negative';
    if (score < -0.3) return 'Weak Negative';
    return 'No Correlation';
  }
}
