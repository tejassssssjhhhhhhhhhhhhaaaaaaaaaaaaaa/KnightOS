import 'dart:async';
import '../../domain/entities/evidence.dart';
import '../../domain/events/integration_events.dart';
import '../../services/event_bus.dart';
import '../../services/evidence_service.dart';
import '../../services/evidence_review_service.dart';
import '../../internal/utils/knight_logger.dart';

/// Automated verification engine for Calendar-based evidence.
class CalendarVerificationEngine {
  CalendarVerificationEngine({
    required this.eventBus,
    required this.evidenceService,
    required this.reviewService,
  }) {
    _subscription = eventBus.on<EvidenceImported>().listen(_handleEvidenceImported);
    KnightLogger.info('[VERIFY] CalendarVerificationEngine initialized');
  }

  final EventBus eventBus;
  final EvidenceService evidenceService;
  final EvidenceReviewService reviewService;
  StreamSubscription? _subscription;

  Future<void> _handleEvidenceImported(EvidenceImported event) async {
    // Only process calendar events
    if (event.type != 'calendar#event') return;

    try {
      final evidence = await evidenceService.getEvidence(event.evidenceId);
      if (evidence == null) return;

      final decision = _evaluate(evidence);
      
      if (decision.shouldAutoVerify) {
        KnightLogger.info('[VERIFY] Auto-verifying calendar evidence: ${event.evidenceId} (Confidence: ${decision.confidence})');
        
        await reviewService.updateStatus(
          event.evidenceId, 
          EvidenceVerificationStatus.verified,
          notes: 'Auto-verified by CalendarVerificationEngine: ${decision.reason}',
        );
      } else {
        KnightLogger.info('[VERIFY] Evidence ${event.evidenceId} held for manual review: ${decision.reason}');
      }
    } catch (e) {
      KnightLogger.error('[VERIFY] Error evaluating evidence ${event.evidenceId}', error: e);
    }
  }

  _VerificationDecision _evaluate(Evidence evidence) {
    final data = evidence.extractionData;
    final calendarId = data['calendar_id'] as String?;
    final attendeesCount = data['attendees_count'] as int? ?? 0;
    final category = data['category'] as String?;
    final summary = (data['title'] ?? '').toString().toLowerCase();

    // 1. Primary Calendar events are high confidence
    if (calendarId != null && calendarId.contains('@gmail.com')) {
      return const _VerificationDecision(
        shouldAutoVerify: true,
        confidence: 0.9,
        reason: 'Event from primary calendar',
      );
    }

    // 2. Multi-attendee meetings are likely real
    if (attendeesCount > 1) {
      return const _VerificationDecision(
        shouldAutoVerify: true,
        confidence: 0.85,
        reason: 'Meeting with multiple attendees',
      );
    }

    // 3. Specific categories (e.g. Travel, Medical) might need manual verification if ambiguous
    if (category == 'travel' || category == 'medical') {
      return const _VerificationDecision(
        shouldAutoVerify: false,
        confidence: 0.6,
        reason: 'High-impact category requires manual review',
      );
    }

    // 4. Low confidence for generic titles
    if (summary == 'meeting' || summary == 'call') {
      return const _VerificationDecision(
        shouldAutoVerify: false,
        confidence: 0.4,
        reason: 'Generic event title',
      );
    }

    return const _VerificationDecision(
      shouldAutoVerify: true,
      confidence: 0.7,
      reason: 'Standard calendar event',
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}

class _VerificationDecision {
  const _VerificationDecision({
    required this.shouldAutoVerify,
    required this.confidence,
    required this.reason,
  });

  final bool shouldAutoVerify;
  final double confidence;
  final String reason;
}
