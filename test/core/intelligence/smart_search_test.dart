import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/unified_search_layer.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/engines/intent_engine.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';

class MockMemoryEngine extends Fake implements MemoryEngine {
  List<KnightMemory> memories = [];
  @override
  Future<List<KnightMemory>> search(String query, {int? limit}) async => memories;
}

void main() {
  late UnifiedSearchLayer layer;
  late MockMemoryEngine memoryEngine;

  setUp(() {
    memoryEngine = MockMemoryEngine();
    layer = UnifiedSearchLayer(
      memoryEngine: memoryEngine,
      intentEngine: const IntentEngine(),
    );
  });

  group('Smart Search & Universal Retrieval (Sprint 1.9)', () {
    test('search finds memories and calculates relevance', () async {
      final m1 = KnightMemory.create(
        memoryId: 'm1',
        category: BookCategory.finance,
        domain: MemoryDomain.finance,
        source: MemorySource.imported,
        content: {},
        summary: 'Flight to NYC',
      );

      memoryEngine.memories = [m1];

      final collection = await layer.search('Flight');

      expect(collection.results, isNotEmpty);
      expect(collection.results.first.relevance, 1.0);
      expect(collection.results.first.title, contains('Flight'));
    });

    test('search detects suggested intent from query', () async {
      final collection = await layer.search('How much is my balance?');

      // IntentEngine should likely classify this as analysis or finance
      expect(collection.suggestedIntent, isNotEmpty);
    });
  });
}

