// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_dao.dart';

// ignore_for_file: type=lint
mixin _$FinancialDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ImportHistoryTableTable get importHistoryTable =>
      attachedDatabase.importHistoryTable;
  $FinancialAccountTableTable get financialAccountTable =>
      attachedDatabase.financialAccountTable;
  $TransactionTableTable get transactionTable =>
      attachedDatabase.transactionTable;
  FinancialDaoManager get managers => FinancialDaoManager(this);
}

class FinancialDaoManager {
  final _$FinancialDaoMixin _db;
  FinancialDaoManager(this._db);
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
}
