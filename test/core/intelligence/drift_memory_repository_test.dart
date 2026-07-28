import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_metadata.dart';
import 'package:knight_os/core/intelligence/domain/memory_version.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/repositories/drift_memory_repository.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';

void main() {
  late KnightDatabase db;
  late DriftMemoryRepository repository;

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    repository = DriftMemoryRepository(memoryDao: db.memoryDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftMemoryRepository', () {
    test('save() and getLatest() should work with versioning', () async {
      final now = DateTime.now();
      final memory = KnightMemory(
        metadata: MemoryMetadata(
          effectiveAt: now,
          confidence: 1.0,
          source: MemorySource.manual,
          domain: MemoryDomain.health,
          category: BookCategory.health,
          tags: ['v1'],
        ),
        version: const MemoryVersion(
          versionNumber: 1,
          changeType: ChangeType.creation,
          reasoning: "Initial record",
        ),
        content: {'value': 80},
      );

      await repository.save(memory);

      final latestV1 = await repository.getLatest(memory.metadata.memoryId);
      expect(latestV1?.content['value'], 80);
      expect(latestV1?.metadata.versionId, isNotNull);
      expect(latestV1?.version.versionNumber, 1);

      // Create Version 2
      final updatedMemory = memory.copyWith(
        content: {'value': 82},
        version: MemoryVersion(
          versionNumber: 2,
          previousVersionId: latestV1?.metadata.versionId,
          changeType: ChangeType.evolution,
          reasoning: "Weight increased",
        ),
      );

      await repository.save(updatedMemory);

      final latestV2 = await repository.getLatest(memory.metadata.memoryId);
      expect(latestV2?.content['value'], 82);
      expect(latestV2?.version.versionNumber, 2);
      expect(latestV2?.version.previousVersionId, latestV1?.metadata.versionId);

      // Verify history
      final history = await repository.getHistory(memory.metadata.memoryId);
      expect(history.length, 2);
      expect(history[0].version.versionNumber, 2);
      expect(history[1].version.versionNumber, 1);
    });

    test('search() should filter correctly', () async {
      final m1 = KnightMemory(
        metadata: MemoryMetadata(
          effectiveAt: DateTime.now(),
          confidence: 1.0,
          source: MemorySource.manual,
          domain: MemoryDomain.career,
          category: BookCategory.career,
          tags: ['flutter', 'dart'],
        ),
        version: const MemoryVersion(
          versionNumber: 1,
          changeType: ChangeType.creation,
        ),
        content: {'title': 'Architect'},
        summary: 'Flutter Lead Role',
      );

      final m2 = KnightMemory(
        metadata: MemoryMetadata(
          effectiveAt: DateTime.now(),
          confidence: 1.0,
          source: MemorySource.manual,
          domain: MemoryDomain.finance,
          category: BookCategory.finance,
        ),
        version: const MemoryVersion(
          versionNumber: 1,
          changeType: ChangeType.creation,
        ),
        content: {'transaction': 'Starbucks'},
        summary: 'Coffee expense',
      );

      await repository.save(m1);
      await repository.save(m2);

      final flutterSearch = await repository.search('Flutter');
      expect(flutterSearch.length, 1);
      expect(flutterSearch.first.summary, contains('Flutter'));

      final coffeeSearch = await repository.search('Coffee');
      expect(coffeeSearch.length, 1);
    });
  });
}
