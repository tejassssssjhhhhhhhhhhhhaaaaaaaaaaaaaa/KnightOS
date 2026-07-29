import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';

void main() {
  group('Context Hydration', () {
    final service = KnightContextService();

    test('buildContext hydrates currentGoals from ambitions memories', () {
      final goalMemory = KnightMemory.create(
        memoryId: 'goal-1',
        category: BookCategory.ambitions,
        domain: MemoryDomain.goals,
        source: MemorySource.manual,
        content: {},
        summary: 'Master Flutter Context',
      );

      final context = service.buildContext(
        featureModules: [],
        recentMemories: [goalMemory],
      );

      expect(context.currentGoals, contains('Master Flutter Context'));
    });

    test('buildContext hydrates healthSummary from health memories', () {
      final healthMemory = KnightMemory.create(
        memoryId: 'health-1',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        source: MemorySource.manual,
        content: {},
        summary: 'Heart rate normalized',
      );

      final context = service.buildContext(
        featureModules: [],
        recentMemories: [healthMemory],
      );

      expect(context.healthSummary, contains('synchronized'));
    });
  });
}
