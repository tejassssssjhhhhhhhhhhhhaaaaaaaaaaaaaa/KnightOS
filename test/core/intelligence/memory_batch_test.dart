import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_version.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/repositories/drift_memory_repository.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/internal/utils/knight_logger.dart';

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

  group('Memory Batch Operations', () {
    test('saveAll should commit multiple records in one transaction', () async {
      final memories = List.generate(
        5,
        (i) => KnightMemory.create(
          memoryId: 'batch-$i',
          category: BookCategory.finance,
          domain: MemoryDomain.finance,
          source: MemorySource.manual,
          content: {'index': i},
          summary: 'Batch Item $i',
        ),
      );

      final stopwatch = Stopwatch()..start();
      await repository.saveAll(memories);
      stopwatch.stop();

      KnightLogger.info(
        'Batch save took ${stopwatch.elapsedMilliseconds}ms',
        category: KnightLogCategory.database,
      );

      final saved = await repository.getByCategory(BookCategory.finance);
      expect(saved.length, 5);
      expect(saved.any((m) => m.content['index'] == 0), true);
      expect(saved.any((m) => m.content['index'] == 4), true);
    });

    test('saveAll should update existing records to isLatest=false', () async {
      final m1 = KnightMemory.create(
        memoryId: 'update-1',
        category: BookCategory.finance,
        domain: MemoryDomain.finance,
        source: MemorySource.manual,
        content: {'v': 1},
      );
      await repository.save(m1);

      final m2 = m1.copyWith(
        content: {'v': 2},
        version: const MemoryVersion(
          versionNumber: 2,
          changeType: ChangeType.evolution,
        ),
      );

      await repository.saveAll([m2]);

      final history = await repository.getHistory('update-1');
      expect(history.length, 2);
      expect(history[0].version.versionNumber, 2);
      expect(history[0].metadata.isLatest, true);
      expect(history[1].metadata.isLatest, false);
    });
  });
}
