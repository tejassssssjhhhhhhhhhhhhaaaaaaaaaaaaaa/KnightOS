import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_metadata.dart';
import 'package:knight_os/core/intelligence/domain/memory_version.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';

class LocalMemoryRepository implements MemoryRepository {
  final List<KnightMemory> _memories = [];

  @override
  Future<void> save(KnightMemory memory) async {
    _memories.add(memory);
  }

  @override
  Future<void> saveAll(List<KnightMemory> memories) async {
    _memories.addAll(memories);
  }

  @override
  Future<KnightMemory?> getLatest(String memoryId) async {
    return _memories.lastWhere((m) => m.metadata.memoryId == memoryId);
  }

  @override
  Future<List<KnightMemory>> getByDomain(MemoryDomain domain) async {
    return _memories.where((m) => m.metadata.domain == domain).toList();
  }

  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async => [];
  @override
  Future<List<KnightMemory>> getHistory(String memoryId) async => [];
  @override
  Future<List<KnightMemory>> search(String query, {int? limit}) async => [];
  @override
  Future<List<KnightMemory>> searchByDateRange(DateTime start, DateTime end) async => [];

  @override
  Future<void> delete(String memoryId) async {}

  @override
  Future<void> link(
    String sourceId,
    String targetId,
    String type, {
    double strength = 1.0,
  }) async {}

  @override
  Future<List<KnightMemory>> getRelated(String memoryId) async => [];

  @override
  Future<List<MemoryRelation>> getAllRelations() async => [];

  @override
  Stream<KnightMemory?> watchLatest(String memoryId) => Stream.value(null);

  @override
  Stream<List<KnightMemory>> watchByDomain(MemoryDomain domain) =>
      Stream.value([]);

  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory category) =>
      Stream.value([]);
}

void main() {
  late MemoryEngine engine;
  late JsonValidationService validationService;
  late LocalMemoryRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('knight_engine_test');
    validationService = JsonValidationService(schemaDirectory: tempDir.path);
    repository = LocalMemoryRepository();
    engine = MemoryEngine(
      repository: repository,
      validationService: validationService,
    );

    // Schema for health domain
    final schemaFile = File('${tempDir.path}/08_health.schema.json');
    await schemaFile.writeAsString('{"type": "object", "required": ["value"]}');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('MemoryEngine', () {
    test('save() validates and persists', () async {
      final memory = KnightMemory(
        metadata: MemoryMetadata(
          effectiveAt: DateTime.now(),
          confidence: 1.0,
          source: MemorySource.manual,
          domain: MemoryDomain.health,
          category: BookCategory.health,
        ),
        version: const MemoryVersion(
          versionNumber: 1,
          changeType: ChangeType.creation,
        ),
        content: {'value': 80},
      );

      await engine.save(memory);

      final latest = await engine.getLatest(memory.metadata.memoryId);
      expect(latest?.content['value'], 80);
    });

    test('save() throws on invalid content', () async {
      final memory = KnightMemory(
        metadata: MemoryMetadata(
          effectiveAt: DateTime.now(),
          confidence: 1.0,
          source: MemorySource.manual,
          domain: MemoryDomain.health,
          category: BookCategory.health,
        ),
        version: const MemoryVersion(
          versionNumber: 1,
          changeType: ChangeType.creation,
        ),
        content: {'wrong_key': 80}, // Missing 'value'
      );

      expect(() => engine.save(memory), throwsA(isA<ValidationException>()));
    });
  });
}

