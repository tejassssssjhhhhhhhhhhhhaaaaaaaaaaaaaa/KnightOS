import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/graph/relationship_discovery_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_retrieval_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';

class FakeRetrieval extends Fake implements MemoryRetrievalEngine {
  List<KnightMemory> memories = [];
  @override
  Future<List<KnightMemory>> search(String query) async => memories;
}

class MockMemoryEngine extends Fake implements MemoryEngine {}

void main() {
  late RelationshipDiscoveryEngine engine;
  late FakeRetrieval retrieval;

  setUp(() {
    retrieval = FakeRetrieval();
    engine = RelationshipDiscoveryEngine(
      memoryEngine: MockMemoryEngine(),
      retrieval: retrieval,
    );
  });

  group('Advanced Memory Graph (Sprint 1.5)', () {
    test('discoverImplicitLinks identifies relations based on shared tags', () async {
      final m1 = KnightMemory.create(
        memoryId: 'm1',
        category: BookCategory.identity,
        domain: MemoryDomain.identity,
        source: MemorySource.manual,
        content: {},
        tags: ['flutter', 'ai'],
      );

      final m2 = KnightMemory.create(
        memoryId: 'm2',
        category: BookCategory.career,
        domain: MemoryDomain.career,
        source: MemorySource.manual,
        content: {},
        tags: ['flutter', 'ai', 'project'],
      );

      retrieval.memories = [m1, m2];

      final links = await engine.discoverImplicitLinks();

      expect(links.any((l) => l.type == MemoryRelationType.relatesTo), isTrue);
    });

    test('discoverImplicitLinks correlates finance and travel', () async {
      final expense = KnightMemory.create(
        memoryId: 'e1',
        category: BookCategory.finance,
        domain: MemoryDomain.finance,
        source: MemorySource.imported,
        content: {},
        summary: 'Flight to Tokyo',
      );

      final trip = KnightMemory.create(
        memoryId: 't1',
        category: BookCategory.history,
        domain: MemoryDomain.travel,
        source: MemorySource.manual,
        content: {},
        summary: 'Japan Trip',
      );

      retrieval.memories = [expense, trip];

      final links = await engine.discoverImplicitLinks();

      expect(links.any((l) => l.type == MemoryRelationType.influences), isTrue);
    });
  });
}
