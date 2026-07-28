import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/evidence.dart';
import '../base_dao.dart';

part 'evidence_dao.g.dart';

@DriftAccessor(tables: [EvidenceTable])
class EvidenceDao extends BaseDao<EvidenceTable, EvidenceTableData>
    with _$EvidenceDaoMixin {
  EvidenceDao(super.db);

  /// Retrieves evidence by its Content-Addressable Identifier (CAID).
  Future<EvidenceTableData?> getByCaid(String caid) {
    return (select(
      evidenceTable,
    )..where((t) => t.caid.equals(caid))).getSingleOrNull();
  }

  /// Inserts a new evidence record if it doesn't already exist (Deduplication).
  Future<void> upsertEvidence(EvidenceTableCompanion companion) async {
    await into(evidenceTable).insertOnConflictUpdate(companion);
  }

  /// Lists all evidence artifacts.
  Future<List<EvidenceTableData>> getAllEvidence() {
    return select(evidenceTable).get();
  }
}
