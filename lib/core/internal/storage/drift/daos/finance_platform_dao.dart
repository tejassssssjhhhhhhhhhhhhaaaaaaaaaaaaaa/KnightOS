import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/finance_sync_journal.dart';
import '../tables/finance_institution_metadata.dart';
import '../tables/finance_inbox_tasks.dart';
import '../tables/finance_extractions.dart';
import '../tables/transactions.dart';
import '../tables/finance_sync_history.dart';
import '../tables/finance_budgets.dart';
import '../tables/finance_goals.dart';
import '../tables/finance_reports.dart';

part 'finance_platform_dao.g.dart';

@DriftAccessor(tables: [
  FinanceSyncJournalTable,
  FinanceInstitutionMetadataTable,
  FinanceInboxTaskTable,
  FinanceExtractionTable,
  TransactionTable,
  FinanceSyncHistoryTable,
  FinanceBudgetTable,
  FinanceGoalTable,
  FinanceReportTable,
])
class FinancePlatformDao extends DatabaseAccessor<KnightDatabase> with _$FinancePlatformDaoMixin {
  FinancePlatformDao(super.db);

  // Reports
  Future<int> insertReport(FinanceReportTableCompanion report) {
    return into(financeReportTable).insert(report);
  }

  Future<List<FinanceReportData>> getAllReports() {
    return select(financeReportTable).get();
  }

  Future<void> deleteReport(String id) {
    return (delete(financeReportTable)..where((t) => t.id.equals(id))).go();
  }

  // Budgets
  Future<int> insertBudget(FinanceBudgetTableCompanion budget) {
    return into(financeBudgetTable).insert(budget);
  }

  Future<List<FinanceBudgetData>> getActiveBudgets() {
    return (select(financeBudgetTable)..where((t) => t.isActive.equals(true))).get();
  }

  Future<void> updateBudget(FinanceBudgetTableCompanion budget) {
    return (update(financeBudgetTable)..where((t) => t.id.equals(budget.id.value))).write(budget);
  }

  // Goals
  Future<int> insertGoal(FinanceGoalTableCompanion goal) {
    return into(financeGoalTable).insert(goal);
  }

  Future<List<FinanceGoalData>> getActiveGoals() {
    return (select(financeGoalTable)..where((t) => t.status.equals('active'))).get();
  }

  Future<void> updateGoal(FinanceGoalTableCompanion goal) {
    return (update(financeGoalTable)..where((t) => t.id.equals(goal.id.value))).write(goal);
  }

  // Sync Journal
  Future<int> insertJournalEntry(FinanceSyncJournalTableCompanion entry) {
    return into(financeSyncJournalTable).insert(entry);
  }

  Future<FinanceSyncJournalData?> getJournalEntry(String messageId) {
    return (select(financeSyncJournalTable)..where((t) => t.messageId.equals(messageId))).getSingleOrNull();
  }

  Future<void> updateJournalEntry(FinanceSyncJournalTableCompanion entry) {
    return (update(financeSyncJournalTable)..where((t) => t.messageId.equals(entry.messageId.value))).write(entry);
  }

  Future<List<FinanceSyncJournalData>> getJournalEntriesByResult(String result) {
    return (select(financeSyncJournalTable)..where((t) => t.processingResult.equals(result))).get();
  }

  // Institutions
  Future<void> upsertInstitution(FinanceInstitutionMetadataTableCompanion institution) {
    return into(financeInstitutionMetadataTable).insertOnConflictUpdate(institution);
  }

  Future<List<FinanceInstitutionMetadataData>> getAllInstitutions() {
    return select(financeInstitutionMetadataTable).get();
  }

  // Tasks
  Future<int> insertTask(FinanceInboxTaskTableCompanion task) {
    return into(financeInboxTaskTable).insert(task);
  }

  Future<List<FinanceInboxTaskData>> getPendingTasks() {
    return (select(financeInboxTaskTable)..where((t) => t.status.equals('pending'))).get();
  }

  // Extractions (Evidence Vault)
  Future<int> insertExtraction(FinanceExtractionTableCompanion extraction) {
    return into(financeExtractionTable).insert(extraction);
  }

  Future<List<FinanceExtractionData>> getExtractionsForMessage(String messageId) {
    return (select(financeExtractionTable)..where((t) => t.messageId.equals(messageId))).get();
  }

  // Transactions (Canonical Records)
  Future<int> insertTransaction(TransactionTableCompanion transaction) {
    return into(transactionTable).insert(transaction);
  }

  Future<void> markTransactionAsOld(String transactionId) {
    return (update(transactionTable)..where((t) => t.transactionId.equals(transactionId))).write(
      const TransactionTableCompanion(isLatest: Value(false)),
    );
  }

  Future<TransactionData?> getLatestTransaction(String transactionId) {
    return (select(transactionTable)
          ..where((t) => t.transactionId.equals(transactionId))
          ..where((t) => t.isLatest.equals(true)))
        .getSingleOrNull();
  }

  Future<TransactionData?> findTransactionByFingerprint(String hash) {
    return (select(transactionTable)
          ..where((t) => t.dedupeHash.equals(hash))
          ..where((t) => t.isLatest.equals(true)))
        .getSingleOrNull();
  }

  // Sync History
  Future<int> insertSyncHistory(FinanceSyncHistoryTableCompanion history) {
    return into(financeSyncHistoryTable).insert(history);
  }

  Future<FinanceSyncHistoryData?> getLastSyncHistory() {
    return (select(financeSyncHistoryTable)..orderBy([(t) => OrderingTerm.desc(t.startTime)])..limit(1)).getSingleOrNull();
  }

  // Advanced Search & Filter
  Future<List<TransactionData>> searchTransactions({
    String query = '',
    List<String> categories = const [],
    List<String> types = const [],
    DateTime? start,
    DateTime? end,
    double? minConfidence,
    int limit = 100,
    int offset = 0,
  }) {
    final statement = select(transactionTable)..where((t) => t.isLatest.equals(true));

    if (query.isNotEmpty) {
      final q = '%$query%';
      statement.where((t) => 
        t.merchant.like(q) | 
        t.institution.like(q) | 
        t.description.like(q) | 
        t.category.like(q)
      );
    }

    if (categories.isNotEmpty) {
      statement.where((t) => t.category.isIn(categories));
    }

    if (types.isNotEmpty) {
      statement.where((t) => t.type.isIn(types));
    }

    if (start != null) {
      statement.where((t) => t.transactionDate.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      statement.where((t) => t.transactionDate.isSmallerOrEqualValue(end));
    }

    if (minConfidence != null) {
      statement.where((t) => t.confidenceScore.isBiggerOrEqualValue(minConfidence));
    }

    statement.orderBy([(t) => OrderingTerm.desc(t.transactionDate)]);
    statement.limit(limit, offset: offset);

    return statement.get();
  }
}
