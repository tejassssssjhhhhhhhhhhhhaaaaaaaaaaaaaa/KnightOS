import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/repositories/drift_memory_repository.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/memory_version.dart';
import 'package:drift/native.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';

void main() {
  late KnightDatabase db;
  late MemoryEngine engine;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('knight_schemas_test');
    final schemaFile = File('${tempDir.path}/08_health.schema.json');
    await schemaFile.writeAsString('{"type": "object"}');

    final validationService = JsonValidationService(
      schemaDirectory: tempDir.path,
    );
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    final repository = DriftMemoryRepository(memoryDao: db.memoryDao);
    engine = MemoryEngine(
      repository: repository,
      validationService: validationService,
    );
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  test(
    'Memory Engine creates a new version when updating a memoryId',
    () async {
      final weight1 = KnightMemory.create(
        memoryId: 'user-weight',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        content: {'value': 82.0, 'unit': 'kg'},
        source: MemorySource.manual,
      );

      await engine.save(weight1);

      final latest1 = await engine.getLatest('user-weight');
      expect(latest1?.versionNumber, 1);
      expect(latest1?.content['value'], 82.0);

      final weight2 = weight1.copyWith(
        content: {'value': 80.5, 'unit': 'kg'},
        version: weight1.version.copyWith(
          versionNumber: 2,
          previousVersionId: latest1?.id,
          changeType: ChangeType.evolution,
        ),
      );

      await engine.save(weight2);

      final latest2 = await engine.getLatest('user-weight');
      expect(latest2?.versionNumber, 2);
      expect(latest2?.content['value'], 80.5);
      expect(latest2?.prevVersionId, latest1?.id);

      final history = await engine.getHistory('user-weight');
      expect(history.length, 2);
      expect(history[0].versionNumber, 2);
      expect(history[1].versionNumber, 1);
    },
  );
}
