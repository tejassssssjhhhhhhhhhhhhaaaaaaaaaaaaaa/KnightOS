import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'financial_accounts.dart';
import 'import_history.dart';

/// Structured financial ledger for high-performance dashboards.
@DataClassName('TransactionData')
class TransactionTable extends KnightTable {
  @override
  String get tableName => 'transactions';

  /// Logical ID for versioning. PK is inherited 'id'.
  TextColumn get transactionId => text()(); 
  BoolColumn get isLatest => boolean().withDefault(const Constant(true))();

  /// Foreign key to the account.
  TextColumn get accountId => text().references(FinancialAccountTable, #id)();

  /// Date of the transaction.
  DateTimeColumn get transactionDate => dateTime()();

  /// amount in currency subunits (if using int) or double. 
  RealColumn get amount => real()();

  /// income, expense, transfer.
  TextColumn get type => text()();

  /// Auto-categorized label (Food, Rent, etc.)
  TextColumn get category => text()();

  /// Normalized fields
  TextColumn get merchant => text()();
  TextColumn get institution => text()();

  /// Raw description from statement.
  TextColumn get description => text()();

  /// Payment method (UPI, Debit Card, etc.)
  TextColumn get paymentMethod => text().nullable()();

  /// Unique hash of (date, amount, description) for deduplication.
  TextColumn get dedupeHash => text()(); // No longer unique constraint to allow versioning

  /// Reference to the source import.
  TextColumn get sourceImportId => text().nullable().references(ImportHistoryTable, #id)();

  // Origin Tracking (M1 Requirement)
  TextColumn get originProviderId => text().nullable()();
  TextColumn get originResourceId => text().nullable()();
  TextColumn get originThreadId => text().nullable()();
  TextColumn get syncBatchId => text().nullable()();

  // Confidence Framework (M1 Requirement)
  RealColumn get confidenceScore => real().nullable()(); // 0.0-1.0
  TextColumn get confidenceReason => text().nullable()();
  TextColumn get verificationState => text().withDefault(const Constant('UNVERIFIED'))();

  // Financial Evidence Vault (Phase A Additions)
  TextColumn get originalEmailLink => text().nullable()();
  TextColumn get parserVersion => text().nullable()();
  DateTimeColumn get extractionTimestamp => dateTime().nullable()();
  
  /// JSON list of FinanceExtraction IDs.
  TextColumn get supportingEvidenceIds => text().nullable()();
  
  /// JSON audit trail of merges and corrections.
  TextColumn get history => text().nullable()(); 
}
