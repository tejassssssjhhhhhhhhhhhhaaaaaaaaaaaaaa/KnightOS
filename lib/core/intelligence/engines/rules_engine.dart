import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import 'memory_engine.dart';

/// Enforces user-defined constraints and life rules.
class RulesEngine {
  const RulesEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Retrieves active rules for a specific category.
  Future<List<KnightMemory>> getRules(BookCategory category) async {
    final allRules = await memoryEngine.getByCategory(BookCategory.philosophy);
    return allRules
        .where((r) => r.content['targetCategory'] == category.name)
        .toList();
  }

  /// Sets a new rule.
  Future<void> defineRule({
    required String name,
    required BookCategory targetCategory,
    required Map<String, dynamic> constraints,
  }) async {
    final memory = KnightMemory.create(
      memoryId: 'rule-${name.toLowerCase().replaceAll(' ', '-')}',
      category: BookCategory.philosophy,
      domain: MemoryDomain.lifeValues,
      content: {
        'name': name,
        'targetCategory': targetCategory.name,
        'constraints': constraints,
      },
      source: MemorySource.manual,
      importance: 1.0,
      reasoning: 'User defined life rule',
    );
    await memoryEngine.save(memory);
  }
}
