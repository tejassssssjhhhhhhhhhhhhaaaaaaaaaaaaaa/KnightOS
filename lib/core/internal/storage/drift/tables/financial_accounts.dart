import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'import_history.dart';

/// Represents a bank account or credit card.
@DataClassName('FinancialAccountData')
class FinancialAccountTable extends KnightTable {
  @override
  String get tableName => 'financial_accounts';

  /// Masked account number or friendly name.
  TextColumn get name => text()();

  /// HDFC, ICICI, etc.
  TextColumn get institution => text()();

  /// Savings, Credit, Investment.
  TextColumn get type => text()();

  /// Last known balance.
  RealColumn get balance => real().withDefault(const Constant(0.0))();

  /// Currency code (INR, USD).
  TextColumn get currency => text().withDefault(const Constant('INR'))();

  /// Reference to the last import that updated this account.
  TextColumn get sourceImportId => text().nullable().references(ImportHistoryTable, #id)();
}
