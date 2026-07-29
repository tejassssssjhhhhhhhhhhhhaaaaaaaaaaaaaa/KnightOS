import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/knowledge_retrieval_engine.dart';
import 'package:knight_os/core/intelligence/services/embedding_service.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_retrieval_engine.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';

class MockEmbeddingProvider implements EmbeddingProvider {
  @override
  String get id => 'mock';
  @override
  int get version => 1;
  @override
  int get dimensions => 2;

  @override
  Future<List<double>> generate(String text) async {
    if (text.contains('gym') || text.contains('exercise')) return [1.0, 0.0];
    if (text.contains('apple') || text.contains('grocery')) return [0.0, 1.0];
    return [0.5, 0.5];
  }
}

class FakeMemoryRepository implements MemoryRepository {
  List<KnightMemory> memories = [];

  @override
  Future<void> save(KnightMemory memory) async => memories.add(memory);
  @override
  Future<void> saveAll(List<KnightMemory> m) async => memories.addAll(m);
  @override
  Future<void> delete(String id) async {}
  @override
  Future<KnightMemory?> getLatest(String id) async => null;
  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async =>
      memories.where((m) => m.category == category).toList();
  @override
  Future<List<KnightMemory>> getByDomain(dynamic domain) async => [];
  @override
  Future<List<KnightMemory>> getHistory(String id) async => [];
  @override
  Future<List<KnightMemory>> search(String query) async {
    if (query.isEmpty) return memories;
    return memories.where((m) => m.summary?.contains(query) ?? false).toList();
  }

  @override
  Future<void> link(
    String s,
    String t,
    String ty, {
    double strength = 1.0,
  }) async {}
  @override
  Future<List<KnightMemory>> getRelated(String id) async => [];
  @override
  Future<List<MemoryRelation>> getAllRelations() async => [];
  @override
  Stream<KnightMemory?> watchLatest(String id) => Stream.value(null);
  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory c) =>
      Stream.value([]);
  @override
  Stream<List<KnightMemory>> watchByDomain(dynamic d) => Stream.value([]);
}

class FakeValidationService implements JsonValidationService {
  @override
  String get schemaDirectory => '';
  @override
  Future<void> validate(
    MemoryDomain domain,
    Map<String, dynamic> content,
  ) async {}
}

void main() {
  late KnowledgeRetrievalEngine engine;
  late MemoryEngine memoryEngine;
  late EmbeddingService embeddingService;

  setUp(() {
    final repository = FakeMemoryRepository();
    memoryEngine = MemoryEngine(
      repository: repository,
      validationService: FakeValidationService(),
    );
    embeddingService = EmbeddingService(provider: MockEmbeddingProvider());
    engine = KnowledgeRetrievalEngine(
      retrieval: MemoryRetrievalEngine(memoryEngine: memoryEngine),
      memoryEngine: memoryEngine,
      embeddingService: embeddingService,
    );
  });

  test('Hybrid Search should rank relevant memories higher', () async {
    // 1. Create memories with embeddings
    final m1 = await embeddingService.embed(
      KnightMemory.create(
        memoryId: 'm1',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        source: MemorySource.manual,
        content: {'text': 'I went to the gym today.'},
        summary: 'Gym session',
      ),
    );

    final m2 = await embeddingService.embed(
      KnightMemory.create(
        memoryId: 'm2',
        category: BookCategory.finance,
        domain: MemoryDomain.finance,
        source: MemorySource.manual,
        content: {'text': 'I bought some apples.'},
        summary: 'Grocery shopping',
      ),
    );

    await memoryEngine.save(m1);
    await memoryEngine.save(m2);

    // 2. Search for "exercise" (should match gym session semantically)
    final results = await engine.hybridSearch('exercise');

    expect(results.length, 2);
    expect(results.first.memory.memoryId, 'm1');
    expect(
      results.first.semanticSimilarity > results.last.semanticSimilarity,
      true,
    );
  });
}
