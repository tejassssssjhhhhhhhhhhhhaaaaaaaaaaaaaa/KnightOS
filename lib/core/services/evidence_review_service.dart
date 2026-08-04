import '../domain/entities/evidence.dart';
import '../domain/repositories/i_evidence_repository.dart';
import '../domain/events/integration_events.dart';
import 'event_bus.dart';
import '../internal/utils/knight_logger.dart';

/// Business logic for reviewing and managing evidence artifacts.
class EvidenceReviewService {
  EvidenceReviewService(this._repository, {EventBus? eventBus})
      : _eventBus = eventBus ?? EventBus.instance;

  final IEvidenceRepository _repository;
  final EventBus _eventBus;

  /// Updates the verification status of an evidence item.
  Future<void> updateStatus(String caid, EvidenceVerificationStatus status, {String? notes}) async {
    final evidence = await _repository.getByCaid(caid);
    if (evidence == null) return;

    final updated = evidence.copyWith(
      verificationStatus: status,
      auditHistory: [
        ...evidence.auditHistory,
        EvidenceAuditEntry(
          action: 'STATUS_UPDATE: ${status.name.toUpperCase()}',
          timestamp: DateTime.now(),
          notes: notes,
        ),
      ],
    );

    await _repository.store(updated);
    KnightLogger.info('[REVIEW] Evidence $caid status updated to ${status.name}');

    if (status == EvidenceVerificationStatus.verified || status == EvidenceVerificationStatus.trusted) {
      final connectorId = updated.extractionData['source_connector'] ?? 'unknown';
      _eventBus.publish(EvidenceVerified(
        connectorId: connectorId,
        timestamp: DateTime.now(),
        evidenceId: caid,
      ));
    }
  }

  /// Identifies potential duplicate evidence based on heuristics.
  Future<List<String>> findPotentialDuplicates(Evidence target) async {
    final all = await _repository.getAll();
    return all
        .where((e) =>
            e.caid != target.caid &&
            (e.originalName == target.originalName ||
                (e.fileSize == target.fileSize && e.mimeType == target.mimeType)))
        .map((e) => e.caid)
        .toList();
  }

  /// Merges two evidence items.
  Future<void> merge(String primaryCaid, String secondaryCaid) async {
    final primary = await _repository.getByCaid(primaryCaid);
    final secondary = await _repository.getByCaid(secondaryCaid);
    
    if (primary == null || secondary == null) return;

    // Merge metadata
    final mergedData = {
      ...secondary.extractionData,
      ...primary.extractionData,
    };

    final updatedPrimary = primary.copyWith(
      extractionData: mergedData,
      auditHistory: [
        ...primary.auditHistory,
        EvidenceAuditEntry(
          action: 'MERGED_WITH: $secondaryCaid',
          timestamp: DateTime.now(),
        ),
      ],
    );

    await _repository.store(updatedPrimary);
    
    // Archive secondary
    await updateStatus(secondaryCaid, EvidenceVerificationStatus.archived, notes: 'Merged into $primaryCaid');
    
    KnightLogger.info('[REVIEW] Merged $secondaryCaid into $primaryCaid');
  }
}
