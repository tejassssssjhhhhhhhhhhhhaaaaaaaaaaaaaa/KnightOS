import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Permanent storage for evidence artifacts using Content-Addressable Storage.
@DataClassName('EvidenceTableData')
class EvidenceTable extends KnightTable {
  @override
  String get tableName => 'evidence';

  /// SHA-256 hash of the content (Primary Key).
  TextColumn get caid => text()();

  /// Original name of the file during ingestion.
  TextColumn get originalName => text()();

  /// MIME type (e.g. application/pdf, image/jpeg).
  TextColumn get mimeType => text()();

  /// Size in bytes.
  IntColumn get fileSize => integer()();

  /// When the artifact was first seen by Knight.
  DateTimeColumn get ingestedAt => dateTime()();

  /// Path within the internal Evidence Vault.
  TextColumn get storagePath => text()();

  /// Extracted JSON data (OCR, EXIF, etc.).
  TextColumn get extractionData => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {caid};
}
