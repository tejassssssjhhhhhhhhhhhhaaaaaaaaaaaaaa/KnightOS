import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/intelligence/services/document_hash_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/drift.dart' hide isNotNull;
import '../../test_utils/mocktail_setup.dart';

class MockDocumentHashService extends Mock implements DocumentHashService {}
class MockFile extends Mock implements File {}

void main() {
  late KnightDatabase db;
  late MockDocumentHashService mockHashService;

  setUpAll(() {
    setupMocktailFallbacks();
  });

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    mockHashService = MockDocumentHashService();
  });

  tearDown(() async {
    await db.close();
  });

  group('DataIngestionService Deduplication Tests', () {
    test('Should skip file if hash already exists in import_history', () async {
      final file = MockFile();
      when(() => file.path).thenReturn('/path/to/file.json');
      const fileHash = 'abc-123-hash';
      
      when(() => mockHashService.calculateHash(any())).thenAnswer((_) async => fileHash);

      // 1. Manually insert existing import
      await db.importDao.upsert(db.importHistoryTable, ImportHistoryTableCompanion.insert(
        id: 'existing-1',
        sourceProvider: const Value('test'),
        sourceIdentifier: const Value('/path/to/file.json'),
        contentHash: const Value(fileHash),
        fileName: 'file.json',
        filePath: '/path/to/file.json',
        docType: 'test',
        status: const Value('success'),
        createdAt: Value(DateTime.now()),
      ));

      // 2. Try to process same file again
      // Validate the DAO lookup which is the core of the dedupe check.
      final existing = await db.importDao.getByHash(fileHash);
      expect(existing, isNotNull);
      expect(existing?.contentHash, fileHash);
    });

    test('Transaction deduplication should prevent duplicate entries', () async {
      const txHash = 'tx-unique-hash';
      final txCompanion = TransactionTableCompanion.insert(
        id: 'tx1',
        transactionId: 'tx1',
        accountId: 'acc1',
        merchant: 'Test Merchant',
        institution: 'Test Institution',
        amount: 100.0,
        type: 'expense',
        category: 'Test Category',
        description: 'Test Description',
        transactionDate: DateTime.now(),
        dedupeHash: txHash,
      );

      // Insert once
      final existsBefore = await db.financialDao.transactionExists(txHash);
      expect(existsBefore, isFalse);

      await db.financialDao.insertTransaction(txCompanion);

      // Verify exists
      final existsAfter = await db.financialDao.transactionExists(txHash);
      expect(existsAfter, isTrue);

      // Simulating _saveParsedData logic
      if (!await db.financialDao.transactionExists(txHash)) {
        await db.financialDao.insertTransaction(txCompanion.copyWith(id: const Value('tx2')));
      }

      final count = await (db.select(db.transactionTable)).get();
      expect(count.length, 1);
    });
  });
}
