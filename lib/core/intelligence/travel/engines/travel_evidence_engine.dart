import '../../../internal/storage/drift/knight_database.dart';

/// Normalizes raw data from connectors into TravelEvidence and preserves raw payloads.
class TravelEvidenceEngine {
  final TravelDao travelDao;

  TravelEvidenceEngine({required this.travelDao});

  /// Ingests raw evidence into the Travel Evidence Vault.
  Future<void> ingest({
    required String caid,
    required String sourceConnector,
    required String sourceIdentifier,
    required String rawPayload,
    required String parserVersion,
  }) async {
    final entry = TravelEvidenceVaultTableCompanion.insert(
      id: 'ev_${DateTime.now().microsecondsSinceEpoch}',
      caid: caid,
      sourceConnector: sourceConnector,
      sourceIdentifier: sourceIdentifier,
      rawPayload: rawPayload,
      detectedAt: DateTime.now(),
      parserVersion: parserVersion,
    );
    
    await travelDao.insertEvidence(entry);
  }

  /// Retrieves all evidence for a specific connector.
  Future<List<TravelEvidenceVaultData>> getEvidenceForConnector(String connectorId) async {
    final all = await travelDao.getAllEvidence();
    return all.where((e) => e.sourceConnector == connectorId).toList();
  }
}
