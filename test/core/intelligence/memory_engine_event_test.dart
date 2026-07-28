import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_events.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';

class FakeMemoryRepository implements MemoryRepository {
  @override
  Future<void> save(KnightMemory memory) async {}
  @override
  Future<void> saveAll(List<KnightMemory> memories) async {}
  @override
  Future<void> delete(String memoryId) async {}
  @override
  Future<KnightMemory?> getLatest(String memoryId) async => null;
  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async => [];
  @override
  Future<List<KnightMemory>> getByDomain(dynamic domain) async => [];
  @override
  Future<List<KnightMemory>> getHistory(String memoryId) async => [];
  @override
  Future<List<KnightMemory>> search(String query) async => [];
  @override
  Future<void> link(
    String s,
    String t,
    String ty, {
    double strength = 1.0,
  }) async {}
  @override
  Future<List<KnightMemory>> getRelated(String memoryId) async => [];
  @override
  Stream<KnightMemory?> watchLatest(String memoryId) => Stream.value(null);
  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory category) =>
      Stream.value([]);
  @override
  Stream<List<KnightMemory>> watchByDomain(dynamic domain) => Stream.value([]);
}

class FakeValidationService implements JsonValidationService {
  @override
  String get schemaDirectory => '';
  @override
  Future<void> validate(dynamic domain, Map<String, dynamic> content) async {}
}

void main() {
  late MemoryEngine memoryEngine;
  late IntelligenceBus bus;

  setUp(() {
    bus = IntelligenceBus();
    memoryEngine = MemoryEngine(
      repository: FakeMemoryRepository(),
      validationService: FakeValidationService(),
      bus: bus,
    );
  });

  tearDown(() {
    bus.dispose();
  });

  test('MemoryEngine should emit DataChangedEvent on save', () async {
    final memory = KnightMemory.create(
      memoryId: 'test-memory',
      category: BookCategory.identity,
      domain: MemoryDomain.identity,
      source: MemorySource.manual,
      content: {'key': 'value'},
      summary: 'Test summary',
      effectiveAt: DateTime.now(),
    );

    final expectation = expectLater(
      bus.events,
      emits(
        isA<DataChangedEvent>().having(
          (e) => e.memories.first.memoryId,
          'memoryId',
          'test-memory',
        ),
      ),
    );

    await memoryEngine.save(memory);

    await expectation;
  });
}
