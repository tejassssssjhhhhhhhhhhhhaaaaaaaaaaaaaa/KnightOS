import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/connectors/infrastructure/connector_pipeline.dart';
import 'package:knight_os/core/connectors/domain/knight_connector.dart';
import 'package:knight_os/core/connectors/domain/connector_models.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:flutter/material.dart';

class MockConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'mock',
    name: 'Mock',
    version: '1.0',
    icon: Icons.abc,
    accentColor: Colors.red,
    capabilities: {ConnectorCapability.import},
    supportedFormats: ['txt'],
  );

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    final memory = KnightMemory.create(
      memoryId: 'm1',
      category: BookCategory.identity,
      domain: MemoryDomain.identity,
      source: MemorySource.imported,
      content: {'text': 'mock data'},
      summary: 'Mock summary',
    );
    return ConnectorResult(success: true, records: [memory]);
  }

  @override
  Future<bool> validate(File file) async => true;
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
  Future<List<KnightMemory>> getByCategory(BookCategory category) async => [];
  @override
  Future<List<KnightMemory>> getByDomain(dynamic domain) async => [];
  @override
  Future<List<KnightMemory>> getHistory(String id) async => [];
  @override
  Future<List<KnightMemory>> search(String query) async => [];
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
  late ConnectorPipeline pipeline;
  late MemoryEngine memoryEngine;
  late FakeMemoryRepository repository;

  setUp(() {
    repository = FakeMemoryRepository();
    memoryEngine = MemoryEngine(
      repository: repository,
      validationService: FakeValidationService(),
    );
    pipeline = ConnectorPipeline(memoryEngine: memoryEngine);
  });

  test(
    'ConnectorPipeline should execute and save memories with provenance',
    () async {
      // We can't easily test with real files in a unit test without more setup
      // But we can mock the hashing service if needed or just skip file level for now
      // Actually hashing service needs a file that exists.

      final file = File('pubspec.yaml'); // Exists
      final connector = MockConnector();

      final result = await pipeline.execute(file, connector);

      expect(result.success, true);
      expect(repository.memories.length, 1);
      expect(repository.memories.first.metadata.provenance, 'pubspec.yaml');
      expect(repository.memories.first.semanticMetadata['connector'], 'mock');
    },
  );
}
