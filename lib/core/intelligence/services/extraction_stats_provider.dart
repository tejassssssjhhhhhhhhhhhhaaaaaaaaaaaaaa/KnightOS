import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';

class ExtractionStats {
  final int entitiesExtracted;
  final int canonicalIdentities;
  final int evidenceRecords;
  final double averageConfidence;
  final int validationFailures;

  ExtractionStats({
    required this.entitiesExtracted,
    required this.canonicalIdentities,
    required this.evidenceRecords,
    required this.averageConfidence,
    required this.validationFailures,
  });
}

final extractionStatsProvider = StreamProvider<ExtractionStats>((ref) async* {
  final db = ref.watch(knightDatabaseProvider);
  
  final entityStream = db.select(db.extractedEntityTable).watch();

  yield* entityStream.asyncMap((_) async {
    final entCount = await db.customSelect("SELECT COUNT(*) as c FROM extracted_entities").getSingle();
    final canCount = await db.customSelect("SELECT COUNT(*) as c FROM canonical_identities").getSingle();
    final evCount = await db.customSelect("SELECT COUNT(*) as c FROM entity_evidence").getSingle();
    final confAvg = await db.customSelect("SELECT AVG(confidence_score) as a FROM extracted_entities").getSingle();
    final failCount = await db.customSelect("SELECT COUNT(*) as c FROM sync_task_queue WHERE status = 'failed' AND task_type = 'extract_entities'").getSingle();

    return ExtractionStats(
      entitiesExtracted: entCount.read<int>('c'),
      canonicalIdentities: canCount.read<int>('c'),
      evidenceRecords: evCount.read<int>('c'),
      averageConfidence: confAvg.read<double?>('a') ?? 0.0,
      validationFailures: failCount.read<int>('c'),
    );
  });
});
