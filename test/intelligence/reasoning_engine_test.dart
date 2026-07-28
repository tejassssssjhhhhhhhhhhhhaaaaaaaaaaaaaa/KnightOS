import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';

void main() {
  const engine = ReasoningEngine();

  group('ReasoningEngine', () {
    test('identifies rule conflicts in decision intent', () {
      final budgetRule = KnightMemory.create(
        memoryId: 'rule-budget',
        category: BookCategory.philosophy,
        domain: MemoryDomain.lifeValues,
        content: {
          'name': 'Monthly Budget',
          'constraints': {'max': 500},
        },
        summary: 'Monthly budget limit',
        source: MemorySource.manual,
      );

      final highExpense = KnightMemory.create(
        memoryId: 'expense-1',
        category: BookCategory.finance,
        domain: MemoryDomain.finance,
        content: {'amount': 600, 'item': 'Gadget'},
        source: MemorySource.manual,
      );

      final trace = engine.reason(
        intent: KnightIntent.decision,
        context: [budgetRule, highExpense],
      );

      expect(trace.potentialRisks, isNotEmpty);
      expect(trace.potentialRisks.first, contains('Monthly Budget'));
      expect(trace.thoughtChain, anyElement(contains('Conflict detected')));
    });

    test('calculates confidence from context', () {
      final lowConf = KnightMemory.create(
        memoryId: 'm1',
        category: BookCategory.history,
        domain: MemoryDomain.memories,
        content: {},
        source: MemorySource.aiGenerated,
        confidence: 0.2,
      );

      final trace = engine.reason(
        intent: KnightIntent.question,
        context: [lowConf],
      );

      expect(trace.confidence, 0.2);
    });

    group('Intent Detection (additional)', () {
      test('trace includes detected intent', () {
        final trace = engine.reason(intent: KnightIntent.planning, context: []);
        expect(trace.intent, KnightIntent.planning);
      });
    });
  });
}
