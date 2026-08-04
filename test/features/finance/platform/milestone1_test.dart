import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNotNull;

void main() {
  late KnightDatabase db;
  late FinancePlatformDao dao;

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    dao = FinancePlatformDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Database v26 includes finance tables', () async {
    expect(db.schemaVersion, 26);
    
    // Test Journal Entry
    final entry = FinanceSyncJournalTableCompanion.insert(
      id: 'msg-1',
      messageId: 'gmail-1',
      parserVersion: '1.0.0',
      processingResult: 'Parsed',
      processedAt: DateTime.now(),
    );
    await dao.insertJournalEntry(entry);
    
    final fetched = await dao.getJournalEntry('gmail-1');
    expect(fetched, isNotNull);
    expect(fetched!.processingResult, 'Parsed');
  });

  test('TransactionTable has Evidence Vault fields', () async {
    // Ensure account exists for foreign key
    await db.into(db.financialAccountTable).insert(
      FinancialAccountTableCompanion.insert(
        id: 'acc-1',
        name: 'Test Account',
        institution: 'Test Bank',
        type: 'Savings',
      ),
    );

    final transaction = TransactionTableCompanion.insert(
      id: 'tx-1-v1',
      transactionId: 'tx-1',
      accountId: 'acc-1',
      transactionDate: DateTime.now(),
      amount: 100.0,
      type: 'expense',
      category: 'Food',
      merchant: 'Lunch',
      institution: 'Bank',
      description: 'Lunch',
      dedupeHash: 'hash-1',
      originalEmailLink: const Value('https://mail.google.com/mail/u/0/#inbox/1'),
      parserVersion: const Value('1.0.0'),
    );
    
    await db.into(db.transactionTable).insert(transaction);
    
    final fetched = await (db.select(db.transactionTable)..where((t) => t.id.equals('tx-1-v1'))).getSingle();
    expect(fetched.originalEmailLink, 'https://mail.google.com/mail/u/0/#inbox/1');
    expect(fetched.parserVersion, '1.0.0');
    expect(fetched.transactionId, 'tx-1');
  });
}
