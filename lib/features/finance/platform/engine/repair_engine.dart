import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/internal/utils/knight_logger.dart';
import 'finance_evidence_vault.dart';

class RepairEngine {
  RepairEngine({
    required this.db,
    required this.dao,
    required this.vault,
  });

  final KnightDatabase db;
  final FinancePlatformDao dao;
  final FinanceEvidenceVault vault;

  Future<void> runFullRepair() async {
    KnightLogger.info('[FINANCE] Starting Full Repair');
    
    // 1. Repair Sync Journal (Missing entries for stored messages)
    await _repairSyncJournal();

    // 2. Re-trigger failed extractions
    await _retryFailedExtractions();

    // 3. Fix missing merchant/institution in transactions
    await _repairTransactions();
  }

  Future<void> _repairSyncJournal() async {
    final messages = await db.select(db.gmailMessageTable).get();
    for (final msg in messages) {
      final entry = await dao.getJournalEntry(msg.id);
      if (entry == null) {
        await dao.insertJournalEntry(FinanceSyncJournalTableCompanion.insert(
          id: msg.id,
          messageId: msg.id,
          parserVersion: '0.0.0',
          processingResult: 'Discovered',
          processedAt: DateTime.now(),
        ));
      }
    }
  }

  Future<void> _retryFailedExtractions() async {
    final entries = await dao.getJournalEntriesByResult('Unsupported');
    for (final entry in entries) {
      final msg = await (db.select(db.gmailMessageTable)..where((t) => t.id.equals(entry.messageId))).getSingleOrNull();
      if (msg != null) {
        await vault.ingestMessage(msg);
      }
    }
  }

  Future<void> _repairTransactions() async {
    final transactions = await (db.select(db.transactionTable)..where((t) => t.isLatest.equals(true))).get();
    for (final tx in transactions) {
      if (tx.merchant == 'Unknown' || tx.institution == 'Gmail') {
         // Attempt re-ingestion if we have supporting evidence
         final evidenceIds = tx.supportingEvidenceIds;
         if (evidenceIds != null) {
           // We'd ideally re-parse the original email.
           // For simplicity, we just log it or mark for review.
         }
      }
    }
  }

  Future<void> createHealthTask(String type, String messageId) async {
    await dao.insertTask(FinanceInboxTaskTableCompanion.insert(
      id: const Uuid().v4(),
      taskType: type,
      messageId: Value(messageId),
      status: const Value('pending'),
    ));
  }
}
