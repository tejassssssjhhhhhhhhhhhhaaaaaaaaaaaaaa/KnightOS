import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/domain/entities/insight.dart';
import 'package:knight_os/core/intelligence/explainability_engine.dart';

void main() {
  late ExplainabilityEngine engine;

  setUp(() {
    engine = ExplainabilityEngine();
  });

  group('ExplainabilityEngine Validation', () {
    test('validate() returns false for insight with no logic steps', () {
      final insight = Insight(
        id: '1',
        title: 'Test',
        recommendation: 'Do nothing',
        confidence: ConfidenceLevel.high,
        reasoningPath: const ReasoningPath(steps: []),
        createdAt: DateTime.now(),
      );

      expect(engine.validate(insight), isFalse);
    });

    test('validate() returns true for well-formed insight', () {
      final insight = Insight(
        id: '2',
        title: 'Career Move',
        recommendation: 'Apply for Role X',
        confidence: ConfidenceLevel.high,
        reasoningPath: const ReasoningPath(
          steps: [
            LogicStep(description: 'Skills match 90%', evidenceIds: ['skill_java']),
          ],
        ),
        createdAt: DateTime.now(),
      );

      expect(engine.validate(insight), isTrue);
    });
  });

  group('ExplainabilityEngine Formatting', () {
    test('formatReasoning() includes key sections', () {
      final insight = Insight(
        id: '3',
        title: 'Health Insight',
        recommendation: 'Sleep more',
        confidence: ConfidenceLevel.medium,
        reasoningPath: const ReasoningPath(
          steps: [LogicStep(description: 'Sleep duration < 6h', evidenceIds: ['sleep_log_001'])],
          assumptions: ['Device sensor is accurate'],
        ),
        createdAt: DateTime.now(),
      );

      final formatted = engine.formatReasoning(insight);
      
      expect(formatted, contains('### Reasoning for: Health Insight'));
      expect(formatted, contains('**Recommendation:** Sleep more'));
      expect(formatted, contains('**Logic Steps:**'));
      expect(formatted, contains('**Assumptions:**'));
      expect(formatted, contains('Supported by evidence: sleep_log_001'));
    });
  });
}
