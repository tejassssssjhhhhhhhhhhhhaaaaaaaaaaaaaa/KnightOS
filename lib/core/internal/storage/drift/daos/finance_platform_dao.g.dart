// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_platform_dao.dart';

// ignore_for_file: type=lint
mixin _$FinancePlatformDaoMixin on DatabaseAccessor<KnightDatabase> {
  $FinanceSyncJournalTableTable get financeSyncJournalTable =>
      attachedDatabase.financeSyncJournalTable;
  $FinanceInstitutionMetadataTableTable get financeInstitutionMetadataTable =>
      attachedDatabase.financeInstitutionMetadataTable;
  $FinanceInboxTaskTableTable get financeInboxTaskTable =>
      attachedDatabase.financeInboxTaskTable;
  $GmailMessageTableTable get gmailMessageTable =>
      attachedDatabase.gmailMessageTable;
  $FinanceExtractionTableTable get financeExtractionTable =>
      attachedDatabase.financeExtractionTable;
  $ImportHistoryTableTable get importHistoryTable =>
      attachedDatabase.importHistoryTable;
  $FinancialAccountTableTable get financialAccountTable =>
      attachedDatabase.financialAccountTable;
  $TransactionTableTable get transactionTable =>
      attachedDatabase.transactionTable;
  $FinanceSyncHistoryTableTable get financeSyncHistoryTable =>
      attachedDatabase.financeSyncHistoryTable;
  $FinanceBudgetTableTable get financeBudgetTable =>
      attachedDatabase.financeBudgetTable;
  $FinanceGoalTableTable get financeGoalTable =>
      attachedDatabase.financeGoalTable;
  $FinanceReportTableTable get financeReportTable =>
      attachedDatabase.financeReportTable;
  FinancePlatformDaoManager get managers => FinancePlatformDaoManager(this);
}

class FinancePlatformDaoManager {
  final _$FinancePlatformDaoMixin _db;
  FinancePlatformDaoManager(this._db);
  $$FinanceSyncJournalTableTableTableManager get financeSyncJournalTable =>
      $$FinanceSyncJournalTableTableTableManager(
        _db.attachedDatabase,
        _db.financeSyncJournalTable,
      );
  $$FinanceInstitutionMetadataTableTableTableManager
  get financeInstitutionMetadataTable =>
      $$FinanceInstitutionMetadataTableTableTableManager(
        _db.attachedDatabase,
        _db.financeInstitutionMetadataTable,
      );
  $$FinanceInboxTaskTableTableTableManager get financeInboxTaskTable =>
      $$FinanceInboxTaskTableTableTableManager(
        _db.attachedDatabase,
        _db.financeInboxTaskTable,
      );
  $$GmailMessageTableTableTableManager get gmailMessageTable =>
      $$GmailMessageTableTableTableManager(
        _db.attachedDatabase,
        _db.gmailMessageTable,
      );
  $$FinanceExtractionTableTableTableManager get financeExtractionTable =>
      $$FinanceExtractionTableTableTableManager(
        _db.attachedDatabase,
        _db.financeExtractionTable,
      );
  $$ImportHistoryTableTableTableManager get importHistoryTable =>
      $$ImportHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.importHistoryTable,
      );
  $$FinancialAccountTableTableTableManager get financialAccountTable =>
      $$FinancialAccountTableTableTableManager(
        _db.attachedDatabase,
        _db.financialAccountTable,
      );
  $$TransactionTableTableTableManager get transactionTable =>
      $$TransactionTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionTable,
      );
  $$FinanceSyncHistoryTableTableTableManager get financeSyncHistoryTable =>
      $$FinanceSyncHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.financeSyncHistoryTable,
      );
  $$FinanceBudgetTableTableTableManager get financeBudgetTable =>
      $$FinanceBudgetTableTableTableManager(
        _db.attachedDatabase,
        _db.financeBudgetTable,
      );
  $$FinanceGoalTableTableTableManager get financeGoalTable =>
      $$FinanceGoalTableTableTableManager(
        _db.attachedDatabase,
        _db.financeGoalTable,
      );
  $$FinanceReportTableTableTableManager get financeReportTable =>
      $$FinanceReportTableTableTableManager(
        _db.attachedDatabase,
        _db.financeReportTable,
      );
}
