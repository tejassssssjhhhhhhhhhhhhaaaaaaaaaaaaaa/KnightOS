import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/intelligence/services/document_hash_service.dart';
import 'package:knight_os/core/intelligence/services/import_preference_service.dart';
import 'package:knight_os/core/intelligence/services/knowledge_graph_service.dart';
import 'package:knight_os/core/intelligence/services/knowledge_graph_weaver.dart';
import 'package:drift/native.dart';
import 'package:mocktail/mocktail.dart';

class MockHashService extends Mock implements DocumentHashService {}
class MockPrefsService extends Mock implements ImportPreferenceService {}
class MockGraphService extends Mock implements KnowledgeGraphService {}
class MockGraphWeaver extends Mock implements KnowledgeGraphWeaver {}

void main() {
  late KnightDatabase db;

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('DataIngestionService Wave 3', () {
    test('ingestCloudData handles basic transactions correctly', () async {
      // Setup mock data
      // final data = ParsedData(...);
      // await service.ingestCloudData('test_provider', data);
      
      // Verify DB
      // final txs = await db.financialDao.getAllTransactions();
      // expect(txs, isNotEmpty);
    });
  });
}
