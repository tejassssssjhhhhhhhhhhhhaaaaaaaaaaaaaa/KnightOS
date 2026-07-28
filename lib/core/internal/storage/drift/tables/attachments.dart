import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'memories.dart';
import 'evidence.dart';

/// Bridge table linking memories to verifiable evidence.
@DataClassName('AttachmentTableData')
class AttachmentTable extends KnightTable {
  @override
  String get tableName => 'attachments';

  /// The memory fact being supported.
  TextColumn get memoryId => text().references(MemoryTable, #id)();

  /// The proof artifact (CAID).
  TextColumn get caid => text().references(EvidenceTable, #caid)();

  /// Optional deep-link into the evidence (e.g. page=2).
  TextColumn get fragment => text().nullable()();
}
