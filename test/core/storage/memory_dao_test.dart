import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';

void main() {
  late KnightDatabase db;
  late MemoryDao memoryDao;

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    memoryDao = MemoryDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('MemoryDao Regression Tests', () {
    test('saveWithVersioning should create new version and mark old as not latest', () async {
      const memoryId = 'test_fact_1';
      final companion1 = MemoryTableCompanion.insert(
        id: 'v1',
        memoryId: memoryId,
        categoryId: 1,
        domainId: 1,
        type: 'identity',
        content: '{"value": "initial"}',
        source: 'manual',
        provenance: 'test',
        changeType: 'creation',
        effectiveAt: DateTime.now(),
        recordedAt: DateTime.now(),
      );

      await memoryDao.saveWithVersioning(companion1);

      final latest1 = await memoryDao.getLatestByMemoryId(memoryId);
      expect(latest1?.content, '{"value": "initial"}');
      expect(latest1?.isLatest, true);
      expect(latest1?.version, 1);

      final companion2 = MemoryTableCompanion.insert(
        id: 'v2',
        memoryId: memoryId,
        categoryId: 1,
        domainId: 1,
        type: 'identity',
        content: '{"value": "updated"}',
        source: 'manual',
        provenance: 'test',
        changeType: 'evolution',
        version: const Value(2),
        effectiveAt: DateTime.now(),
        recordedAt: DateTime.now(),
      );

      await memoryDao.saveWithVersioning(companion2);

      final latest2 = await memoryDao.getLatestByMemoryId(memoryId);
      expect(latest2?.content, '{"value": "updated"}');
      expect(latest2?.isLatest, true);
      expect(latest2?.version, 2);

      final history = await memoryDao.getVersionHistory(memoryId);
      expect(history.length, 2);
      expect(history.first.isLatest, true);
      expect(history.last.isLatest, false);
    });

    test('watchLatestByMemoryId should emit new values on update', () async {
      const memoryId = 'reactive_fact';
      final stream = memoryDao.watchLatestByMemoryId(memoryId);

      expect(
        stream,
        emitsInOrder([
          null, // Initial state
          isA<MemoryTableData>().having((d) => d.content, 'content', '{"v": 1}'),
          isA<MemoryTableData>().having((d) => d.content, 'content', '{"v": 2}'),
        ]),
      );

      await memoryDao.saveWithVersioning(MemoryTableCompanion.insert(
        id: 'r1',
        memoryId: memoryId,
        categoryId: 1,
        domainId: 1,
        type: 'test',
        content: '{"v": 1}',
        source: 'test',
        provenance: 'test',
        changeType: 'creation',
        effectiveAt: DateTime.now(),
        recordedAt: DateTime.now(),
      ));

      await memoryDao.saveWithVersioning(MemoryTableCompanion.insert(
        id: 'r2',
        memoryId: memoryId,
        categoryId: 1,
        domainId: 1,
        type: 'test',
        content: '{"v": 2}',
        source: 'test',
        provenance: 'test',
        changeType: 'evolution',
        effectiveAt: DateTime.now(),
        recordedAt: DateTime.now(),
      ));
    });
  });
}
