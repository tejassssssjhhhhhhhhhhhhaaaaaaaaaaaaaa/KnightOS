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

  group('Memory Reactive Infrastructure (ADR-002)', () {
    test('watchLatest should emit when memory is updated', () async {
      final memoryId = 'test-memory-1';
      final m1 = KnightMemory.create(
        memoryId: memoryId,
        category: BookCategory.identity,
        domain: MemoryDomain.identity,
        source: MemorySource.manual,
        content: {'name': 'Initial'},
      );

      final stream = repository.watchLatest(memoryId);

      // We expect Initial and Updated states. Null might be emitted or skipped
      // depending on how fast the first save happens.
      final expectation = expectLater(
        stream,
        emitsThrough(
          predicate<KnightMemory>((m) => m.content['name'] == 'Updated'),
        ),
      );

      await repository.save(m1);

      final m2 = m1.copyWith(
        content: {'name': 'Updated'},
        version: const MemoryVersion(
          versionNumber: 2,
          changeType: ChangeType.evolution,
        ),
      );

      await repository.save(m2);
      await expectation;
    });

    test(
      'watchByCategory should emit when any memory in category is added',
      () async {
        final stream = repository.watchByCategory(BookCategory.finance);

        final expectation = expectLater(stream, emitsThrough(hasLength(2)));

        await repository.save(
          KnightMemory.create(
            memoryId: 'fin-1',
            category: BookCategory.finance,
            domain: MemoryDomain.finance,
            source: MemorySource.manual,
            content: {'amount': 10},
          ),
        );

        await repository.save(
          KnightMemory.create(
            memoryId: 'fin-2',
            category: BookCategory.finance,
            domain: MemoryDomain.finance,
            source: MemorySource.manual,
            content: {'amount': 20},
          ),
        );

        await expectation;
      },
    );
  });

  group('Knowledge Lifecycle & Confidence Framework', () {
    test('Should preserve updatedAt and KnowledgeState', () async {
      final memory = KnightMemory.create(
        memoryId: 'lifecycle-1',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        source: MemorySource.aiGenerated,
        content: {'inference': 'Home location'},
        knowledgeState: KnowledgeState.inferred,
        explanation: 'Observed staying here at night',
      );

      await repository.save(memory);

      final saved = await repository.getLatest(memory.memoryId);
      print('DEBUG: saved is null? ${saved == null}');
      if (saved != null) {
        print('DEBUG: saved.state: ${saved.state}');
        print('DEBUG: saved.updatedAt: ${saved.updatedAt}');
      }
      expect(saved?.state, KnowledgeState.inferred);
      expect(saved?.explanation, contains('night'));
      expect(saved?.updatedAt, isNotNull);

      // Update state to userConfirmed
      final confirmed = saved!.copyWith(
        metadata: saved.metadata.copyWith(
          knowledgeState: KnowledgeState.userConfirmed,
          verified: true,
          lastVerifiedAt: DateTime.now(),
        ),
      );

      await repository.save(confirmed);

      final finalMemory = await repository.getLatest(memory.memoryId);
      expect(finalMemory?.state, KnowledgeState.userConfirmed);
      expect(finalMemory?.verified, true);
      expect(finalMemory?.lastVerifiedAt, isNotNull);
    });
  });
}
