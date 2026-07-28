import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/repositories/drift_evidence_repository.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';
}

void main() {
  late KnightDatabase db;
  late DriftEvidenceRepository repository;

  setUp(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    repository = DriftEvidenceRepository(evidenceDao: db.evidenceDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftEvidenceRepository', () {
    test('store() should deduplicate by content hash', () async {
      final bytes = [1, 2, 3, 4, 5];
      final e1 = await repository.store(
        bytes,
        originalName: 'test.txt',
        mimeType: 'text/plain',
      );
      final e2 = await repository.store(
        bytes,
        originalName: 'test_copy.txt',
        mimeType: 'text/plain',
      );

      expect(e1.caid, e2.caid);

      final list = await repository.list();
      expect(list.length, 1);
    });

    test('verify() should return true for healthy artifacts', () async {
      final bytes = [6, 7, 8];
      final evidence = await repository.store(
        bytes,
        originalName: 'health.bin',
        mimeType: 'application/octet-stream',
      );

      final isValid = await repository.verify(evidence.caid);
      expect(isValid, isTrue);
    });
  });
}
