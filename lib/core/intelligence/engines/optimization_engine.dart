import '../domain/intelligence_models.dart';
import '../domain/optimization_models.dart';
import '../intelligence_bus.dart';
import '../domain/intelligence_events.dart';

/// The self-learning core of KnightOS.
/// Optimizes priority weights based on user feedback (RLHF).
class OptimizationEngine {
  OptimizationEngine({required this.bus});

  final IntelligenceBus bus;
  final Map<String, double> _weights = {};
  final List<KnightLesson> _lessons = [];

  /// Processes feedback to generate a new lesson and adjust system weights.
  void processFeedback(String domain, IntelligenceFeedback feedback) {
    final factor = feedback == IntelligenceFeedback.helpful ? 0.05 : -0.2;
    
    final currentWeight = _weights[domain] ?? 1.0;
    _weights[domain] = (currentWeight + factor).clamp(0.1, 2.0);

    final lesson = KnightLesson(
      id: 'lesson-${DateTime.now().millisecondsSinceEpoch}',
      targetDomain: domain,
      feedbackType: feedback.name,
      adjustmentFactor: factor,
      reasoning: 'User feedback indicated recommendation was ${feedback.name}.',
      timestamp: DateTime.now(),
    );

    _lessons.add(lesson);
  }

  double getWeight(String domain) => _weights[domain] ?? 1.0;

  OptimizationState get state => OptimizationState(
        domainWeights: Map.unmodifiable(_weights),
        lessonsLearned: List.unmodifiable(_lessons),
      );
}
