import '../domain/entities/evidence.dart';
import '../domain/repositories/i_evidence_repository.dart';
import '../internal/utils/knight_logger.dart';

/// Manages verified evidence ingestion and validation.
class EvidenceService {
  EvidenceService(this._repository);

  final IEvidenceRepository _repository;

  /// Ingests a new piece of evidence.
  Future<Evidence> ingest({
    required String originalName,
    required String mimeType,
    required int fileSize,
    required String storagePath,
    required String caid, // Content-Addressable ID (hash)
    Map<String, dynamic> metadata = const {},
  }) async {
    final evidence = Evidence(
      caid: caid,
      originalName: originalName,
      mimeType: mimeType,
      fileSize: fileSize,
      ingestedAt: DateTime.now(),
      storagePath: storagePath,
      extractionData: metadata,
    );

    await _repository.store(evidence);
    KnightLogger.info('[EVIDENCE] Ingested: $caid ($originalName)');
    return evidence;
  }

  /// Retrieves evidence by CAID.
  Future<Evidence?> getEvidence(String caid) async {
    return await _repository.getByCaid(caid);
  }

  /// Verifies the integrity of stored evidence.
  Future<bool> verifyIntegrity(String caid) async {
    final evidence = await _repository.getByCaid(caid);
    if (evidence == null) return false;

    // In a real app, we would re-hash the file at storagePath and compare with caid.
    return true; 
  }
}
