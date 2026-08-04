import '../domain/entities/insight.dart';
import '../intelligence/model_router.dart';
import '../intelligence/explainability_engine.dart';
import '../storage/privacy_vault.dart';
import '../internal/utils/knight_logger.dart';
import 'package:uuid/uuid.dart';

/// Central service for AI reasoning across KnightOS.
class IntelligenceService {
  IntelligenceService({
    ModelRouter? router,
    ExplainabilityEngine? explainability,
  })  : _router = router ?? ModelRouter(),
        _explainability = explainability ?? ExplainabilityEngine();

  final ModelRouter _router;
  final ExplainabilityEngine _explainability;
  final _uuid = const Uuid();

  /// Queries the intelligence system for an insight.
  Future<Insight> query({
    required String title,
    required String prompt,
    PrivacyClassification classification = PrivacyClassification.public,
  }) async {
    final model = _router.route(classification);
    KnightLogger.info('[INTEL] Routing query "$title" to $model (Class: ${classification.name})');

    // Simulate AI reasoning
    final insight = Insight(
      id: _uuid.v4(),
      title: title,
      recommendation: 'Simulated recommendation based on $model',
      confidence: ConfidenceLevel.high,
      reasoningPath: ReasoningPath(
        steps: [
          LogicStep(
            description: 'Analyzed prompt: $prompt',
          ),
          LogicStep(
            description: 'Model $model selected based on ${classification.name} classification',
          ),
        ],
        assumptions: ['Environment is stable'],
      ),
      createdAt: DateTime.now(),
    );

    // Validate using explainability engine
    if (!_explainability.validate(insight)) {
      throw Exception('AI insight failed explainability validation');
    }

    return insight;
  }
}
