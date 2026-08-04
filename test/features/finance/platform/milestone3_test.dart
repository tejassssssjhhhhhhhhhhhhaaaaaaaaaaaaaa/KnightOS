import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:knight_os/features/finance/platform/engine/finance_evidence_vault.dart';
import 'package:knight_os/features/finance/platform/engine/finance_parser_engine.dart';
import 'package:knight_os/features/finance/platform/engine/parsers/generic_upi_parser.dart';
import 'package:knight_os/features/finance/platform/engine/normalization_engine.dart';
import 'package:knight_os/features/finance/platform/engine/duplicate_detection_engine.dart';

void main() {
  late KnightDatabase db;
  late FinancePlatformDao dao;
  late FinanceParserEngine parserEngine;
  late FinanceEvidenceVault vault;

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    dao = FinancePlatformDao(db);
    parserEngine = FinanceParserEngine();
    parserEngine.registerParser(GenericUpiParser());
    vault = FinanceEvidenceVault(db: db, parserEngine: parserEngine, dao: dao);
  });

  tearDown(() async {
    await db.close();
  });

  test('Evidence Vault ingests message and creates transaction', () async {
    const msgId = 'msg1';
    await db.into(db.gmailMessageTable).insert(
      GmailMessageTableCompanion.insert(
        id: msgId,
        threadId: 't1',
        historyId: 'h1',
        subject: 'UPI Payment to AMZN',
        sender: 'alerts@upi.com',
        recipients: 'me@gmail.com',
        messageDate: DateTime(2026, 8, 1),
        labels: '',
        snippet: 'Paid Rs. 500 to AMZN ref 12345678',
        internalDate: BigInt.from(0),
        originAccount: 'me@gmail.com',
      ),
    );

    final msg = await (db.select(db.gmailMessageTable)..where((t) => t.id.equals(msgId))).getSingle();

    await dao.insertJournalEntry(FinanceSyncJournalTableCompanion.insert(
      id: msgId,
      messageId: msgId,
      parserVersion: '0.0.0',
      processingResult: 'Discovered',
      processedAt: DateTime.now(),
    ));

    await vault.ingestMessage(msg);

    final transactions = await db.select(db.transactionTable).get();
    expect(transactions.length, 1);
    expect(transactions.first.merchant, 'Amazon'); // Normalized
    expect(transactions.first.amount, 500.0);
    expect(transactions.first.parserVersion, '1.0.0');

    final extractions = await db.select(db.financeExtractionTable).get();
    expect(extractions.length, 1);
    expect(extractions.first.messageId, msgId);
  });

  test('Deduplication merges evidence for same transaction', () async {
    const msgId1 = 'msg1';
    const msgId2 = 'msg2';

    await db.into(db.gmailMessageTable).insert(
      GmailMessageTableCompanion.insert(
        id: msgId1,
        threadId: 't1',
        historyId: 'h1',
        subject: 'UPI Alert',
        sender: 'alerts@upi.com',
        recipients: 'me@gmail.com',
        messageDate: DateTime(2026, 8, 1),
        labels: '',
        snippet: 'Paid Rs. 100 to SWIGGY ref TXN123456',
        internalDate: BigInt.from(0),
        originAccount: 'me@gmail.com',
      ),
    );

    await db.into(db.gmailMessageTable).insert(
      GmailMessageTableCompanion.insert(
        id: msgId2,
        threadId: 't2',
        historyId: 'h2',
        subject: 'Bank Statement Update',
        sender: 'alerts@bank.com',
        recipients: 'me@gmail.com',
        messageDate: DateTime(2026, 8, 1),
        labels: '',
        snippet: 'Debit of INR 100.00 to SWIGGY ref TXN123456',
        internalDate: BigInt.from(0),
        originAccount: 'me@gmail.com',
      ),
    );

    await dao.insertJournalEntry(FinanceSyncJournalTableCompanion.insert(id: msgId1, messageId: msgId1, parserVersion: '0.0.0', processingResult: 'Discovered', processedAt: DateTime.now()));
    await dao.insertJournalEntry(FinanceSyncJournalTableCompanion.insert(id: msgId2, messageId: msgId2, parserVersion: '0.0.0', processingResult: 'Discovered', processedAt: DateTime.now()));

    final msg1 = await (db.select(db.gmailMessageTable)..where((t) => t.id.equals(msgId1))).getSingle();
    final msg2 = await (db.select(db.gmailMessageTable)..where((t) => t.id.equals(msgId2))).getSingle();

    await vault.ingestMessage(msg1);
    await vault.ingestMessage(msg2);

    final transactions = await db.select(db.transactionTable).get();
    final latestTransactions = transactions.where((t) => t.isLatest).toList();
    expect(latestTransactions.length, 1);
    
    final tx = latestTransactions.first;
    expect(tx.amount, 100.0);
    expect(tx.merchant, 'Swiggy');
    
    final evidenceIds = tx.supportingEvidenceIds;
    final List ids = jsonDecode(evidenceIds!);
    expect(ids.length, 2);
  });

  test('NormalizationEngine handles common patterns', () {
    expect(NormalizationEngine.normalizeMerchant('AMZN PAY'), 'Amazon');
    expect(NormalizationEngine.normalizeMerchant('SWIGGY LTD'), 'Swiggy');
    expect(NormalizationEngine.normalizeMerchant('UBER INDIA'), 'Uber');
  });

  test('DuplicateDetectionEngine generates consistent fingerprints', () {
    final date = DateTime(2026, 8, 1);
    final f1 = DuplicateDetectionEngine.generateFingerprint(amount: 100.0, date: date, referenceNumber: 'REF12345');
    final f2 = DuplicateDetectionEngine.generateFingerprint(amount: 100.0, date: date, referenceNumber: 'REF12345');
    final f3 = DuplicateDetectionEngine.generateFingerprint(amount: 100.0, date: date, referenceNumber: 'REF67890');

    expect(f1, f2);
    expect(f1, isNot(f3));
  });
}
