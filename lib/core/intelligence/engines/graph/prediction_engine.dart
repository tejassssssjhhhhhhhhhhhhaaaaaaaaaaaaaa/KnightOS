import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

/// Uses historical patterns to estimate future outcomes.
class PredictionEngine {
  const PredictionEngine({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  /// Estimates future spending for the current month.
  Future<PredictionResult> predictMonthlySpending() async {
    final expenses = await retrieval.getByCategory(BookCategory.finance);
    if (expenses.isEmpty) {
      return const PredictionResult(estimatedValue: 0.0, confidence: 0.0);
    }

    // Simple moving average / linear projection
    final now = DateTime.now();
    final thisMonthExpenses = expenses
        .where(
          (m) =>
              m.effectiveAt.year == now.year &&
              m.effectiveAt.month == now.month,
        )
        .toList();

    double spentSoFar = 0.0;
    for (final e in thisMonthExpenses) {
      spentSoFar +=
          double.tryParse(e.content['amount']?.toString() ?? '0') ?? 0.0;
    }

    final dayOfMonth = now.day;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final projected = (spentSoFar / dayOfMonth) * daysInMonth;

    return PredictionResult(
      estimatedValue: projected,
      confidence: (dayOfMonth / daysInMonth).clamp(0.5, 0.95),
      evidenceIds: thisMonthExpenses.map((m) => m.id).toList(),
    );
  }

  /// Predicts goal completion date.
  Future<PredictionResult?> predictGoalCompletion(String goalId) async {
    // Future: Analyze progress history for the goal
    return null;
  }
}

class PredictionResult {
  const PredictionResult({
    required this.estimatedValue,
    required this.confidence,
    this.evidenceIds = const [],
    this.reasoning = '',
  });

  final double estimatedValue;
  final double confidence;
  final List<String> evidenceIds;
  final String reasoning;
}
