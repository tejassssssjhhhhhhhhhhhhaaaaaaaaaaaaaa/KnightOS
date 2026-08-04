import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FinanceInstitutionMetadataData')
class FinanceInstitutionMetadataTable extends KnightTable {
  @override
  String get tableName => 'finance_institution_metadata';

  TextColumn get name => text()();
  TextColumn get type => text()(); // Bank, Credit Card, EPFO, Insurance, etc.
  TextColumn get rawMetadata => text().nullable()(); // JSON blob
}
