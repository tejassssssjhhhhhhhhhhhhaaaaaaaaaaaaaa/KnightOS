import 'dart:async';
import '../domain/events/integration_events.dart';
import 'event_bus.dart';
import '../intelligence/normalization_pipeline.dart';
import 'evidence_service.dart';
import '../internal/utils/knight_logger.dart';

/// Listens for verified evidence and projects it into the Universal Timeline.
class TimelineProjectionListener {
  TimelineProjectionListener({
    required this.eventBus,
    required this.pipeline,
    required this.evidenceService,
  }) {
    _subscription = eventBus.on<EvidenceVerified>().listen(_handleEvidenceVerified);
    KnightLogger.info('[PROJECTION] TimelineProjectionListener initialized');
  }

  final EventBus eventBus;
  final NormalizationPipeline pipeline;
  final EvidenceService evidenceService;
  StreamSubscription? _subscription;

  Future<void> _handleEvidenceVerified(EvidenceVerified event) async {
    KnightLogger.info('[PROJECTION] Evidence verified: ${event.evidenceId}. Triggering projection.');
    
    try {
      final evidence = await evidenceService.getEvidence(event.evidenceId);
      if (evidence == null) {
        KnightLogger.error('[PROJECTION] Evidence not found: ${event.evidenceId}');
        return;
      }

      // Projection stage
      await pipeline.projectEvidenceToTimeline(evidence, evidence.extractionData);
      
    } catch (e) {
      KnightLogger.error('[PROJECTION] Failed to project evidence ${event.evidenceId}: $e');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
