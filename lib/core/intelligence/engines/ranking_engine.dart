import '../domain/intelligence_models.dart';

/// Prioritizes intelligence results based on multiple dimensions.
class RankingEngine {
  const RankingEngine();

  /// Ranks a list of intelligence results.
  List<IntelligenceResult> rank(List<IntelligenceResult> results) {
    final sorted = List<IntelligenceResult>.from(results);

    sorted.sort((a, b) {
      // 1. Calculate base score from confidence
      double scoreA = a.trace.confidence;
      double scoreB = b.trace.confidence;

      // 2. Adjust based on feedback
      if (a.feedback == IntelligenceFeedback.notHelpful ||
          a.feedback == IntelligenceFeedback.incorrect) {
        scoreA *= 0.5;
      }
      if (b.feedback == IntelligenceFeedback.notHelpful ||
          b.feedback == IntelligenceFeedback.incorrect) {
        scoreB *= 0.5;
      }

      // 3. Adjust based on recency (bonus for newer results)
      final ageA = DateTime.now().difference(a.generatedAt).inMinutes;
      final ageB = DateTime.now().difference(b.generatedAt).inMinutes;

      // Bonus: +0.1 if under 1 hour old
      if (ageA < 60) scoreA += 0.1;
      if (ageB < 60) scoreB += 0.1;

      return scoreB.compareTo(scoreA);
    });

    return sorted;
  }
}
