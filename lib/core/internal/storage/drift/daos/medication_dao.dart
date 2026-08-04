import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/medications.dart';

part 'medication_dao.g.dart';

@DriftAccessor(tables: [MedicationTable, MedicationLogTable])
class MedicationDao extends DatabaseAccessor<KnightDatabase> with _$MedicationDaoMixin {
  MedicationDao(super.db);

  Future<List<MedicationData>> getActiveMedications() {
    return (select(medicationTable)..where((t) => t.isActive.equals(true))).get();
  }

  Future<void> logMedication(MedicationLogTableCompanion log) =>
      into(medicationLogTable).insert(log);

  Future<List<MedicationLogData>> getLogsForMedication(String medId) {
    return (select(medicationLogTable)..where((t) => t.medicationId.equals(medId))).get();
  }
}
