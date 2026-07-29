import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/services/memory_service.dart';

class MockMemoryRepository implements MemoryRepository {
  final Map<String, List<KnightMemory>> _memories = {};

  @override
  Future<void> save(KnightMemory memory) async {
    _memories.putIfAbsent(memory.memoryId, () => []).add(memory);
  }

  @override
  Future<void> saveAll(List<KnightMemory> memories) async {
    for (var m in memories) {
      await save(m);
    }
  }

  @override
  Future<KnightMemory?> getLatest(String memoryId) async {
    return _memories[memoryId]?.last;
  }

  @override
  Future<List<KnightMemory>> getByDomain(MemoryDomain domain) async {
    return _memories.values.expand((l) => l).where((m) => m.metadata.domain == domain).toList();
  }

  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async {
    return _memories.values.expand((l) => l).where((m) => m.category == category).toList();
  }

  @override
  Future<List<KnightMemory>> getHistory(String memoryId) async {
    return _memories[memoryId] ?? [];
  }

  @override
  Future<List<KnightMemory>> search(String query) async {
    return _memories.values.expand((l) => l).where((m) => (m.summary ?? '').contains(query)).toList();
  }

  @override
  Future<void> delete(String memoryId) async {
    _memories.remove(memoryId);
  }

  @override
  Future<void> link(String sourceId, String targetId, String type, {double strength = 1.0}) async {}

  @override
  Future<List<KnightMemory>> getRelated(String memoryId) async => [];

  @override
  Future<List<MemoryRelation>> getAllRelations() async => [];

  @override
  Stream<KnightMemory?> watchLatest(String memoryId) => Stream.value(null);

  @override
  Stream<List<KnightMemory>> watchByDomain(MemoryDomain domain) => Stream.value([]);

  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory category) => Stream.value([]);
}

void main() {
  late MemoryService service;
  late MemoryEngine engine;
  late MockMemoryRepository repository;
  late JsonValidationService validationService;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('memory_service_test');
    validationService = JsonValidationService(schemaDirectory: tempDir.path);
    repository = MockMemoryRepository();
    engine = MemoryEngine(
      repository: repository,
      validationService: validationService,
    );
    service = MemoryService(memoryEngine: engine);

    // Schema for tests
    final healthSchema = File('${tempDir.path}/08_health.schema.json');
    await healthSchema.writeAsString('{"type": "object"}');

    final memorySchema = File('${tempDir.path}/27_memories.schema.json');
    await memorySchema.writeAsString('{"type": "object"}');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('MemoryService', () {
    test('saveMemory and retrieveMemory work', () async {
      final memory = KnightMemory.create(
        memoryId: 'test-1',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        source: MemorySource.manual,
        content: {'key': 'value'},
        summary: 'Test Memory',
      );

      await service.saveMemory(memory);
      final retrieved = await service.retrieveMemory('test-1');

      expect(retrieved, isNotNull);
      expect(retrieved?.summary, 'Test Memory');
      expect(retrieved?.content['key'], 'value');
    });

    test('saveQuickNote creates correct memory', () async {
      await service.saveQuickNote('Quick Title', 'Quick Body');
      
      final results = await service.searchMemories('Quick Title');
      expect(results, hasLength(1));
      expect(results.first.summary, 'Quick Title');
      expect(results.first.content['body'], 'Quick Body');
    });

    test('deleteMemory removes the memory', () async {
      final memory = KnightMemory.create(
        memoryId: 'to-delete',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        source: MemorySource.manual,
        content: {},
        summary: 'Delete Me',
      );

      await service.saveMemory(memory);
      expect(await service.retrieveMemory('to-delete'), isNotNull);

      await service.deleteMemory('to-delete');
      expect(await service.retrieveMemory('to-delete'), isNull);
    });

    test('searchMemories finds relevant memories', () async {
      await service.saveQuickNote('Apples', 'Red fruit');
      await service.saveQuickNote('Bananas', 'Yellow fruit');

      final results = await service.searchMemories('Apples');
      expect(results, hasLength(1));
      expect(results.first.summary, 'Apples');
    });
  });
}
