import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/graph/correlation_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_retrieval_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';

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
  Future<List<KnightMemory>> search(String query) async => memories;
  @override
  Future<List<KnightMemory>> searchByDateRange(DateTime start, DateTime end) async => [];
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
  late MemoryEngine memoryEngine;
  late MemoryRetrievalEngine retrieval;
  late CorrelationEngine correlationEngine;

  setUp(() {
    final repository = FakeMemoryRepository();
    memoryEngine = MemoryEngine(
      repository: repository,
      validationService: FakeValidationService(),
    );
    retrieval = MemoryRetrievalEngine(memoryEngine: memoryEngine);
    correlationEngine = CorrelationEngine(retrieval: retrieval);
  });

  test('CorrelationEngine should detect positive correlation', () async {
    // 1. Create aligned data: 10 days of Sleep vs Productivity
    final now = DateTime.now();
    for (int i = 0; i < 10; i++) {
      final date = now.subtract(Duration(days: i));
      final sleepVal = 400.0 + (i * 20); // Increasing
      final prodVal = 50.0 + (i * 5); // Increasing

      await memoryEngine.save(
        KnightMemory.create(
          memoryId: 'sleep-$i',
          category: BookCategory.health,
          domain: MemoryDomain.health,
          source: MemorySource.manual,
          content: {'durationMinutes': sleepVal},
          effectiveAt: date,
        ),
      );

      await memoryEngine.save(
        KnightMemory.create(
          memoryId: 'prod-$i',
          category: BookCategory.career,
          domain: MemoryDomain.career,
          source: MemorySource.manual,
          content: {'productivityScore': prodVal},
          effectiveAt: date,
        ),
      );
    }

    final result = await correlationEngine.correlate(
      categoryA: BookCategory.health,
      fieldA: 'durationMinutes',
      categoryB: BookCategory.career,
      fieldB: 'productivityScore',
    );

    expect(result.score > 0.9, true);
    expect(result.interpretation, 'Strong Positive');
  });
}
