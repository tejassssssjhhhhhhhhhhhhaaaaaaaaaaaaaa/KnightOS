import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/integration_hub.dart';
import '../services/evidence_service.dart';
import '../services/timeline_service.dart';
import '../services/event_bus.dart';
import '../intelligence/normalization_pipeline.dart';
import '../connectors/manual_connector.dart';
import 'database_provider.dart';
import '../repositories/evidence_repository_impl.dart';
import '../repositories/timeline_repository_impl.dart';
import '../services/evidence_review_service.dart';
import '../services/timeline_projection_listener.dart';
import '../intelligence/verification/calendar_verification_engine.dart';
import '../connectors/implementations/google_calendar_connector.dart';

final eventBusProvider = Provider<EventBus>((ref) => EventBus.instance);

final evidenceRepositoryProvider = Provider((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return EvidenceRepositoryImpl(db.evidenceDao);
});

final timelineRepositoryProvider = Provider((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return TimelineRepositoryImpl(db.timelineDao);
});

final evidenceServiceProvider = Provider((ref) {
  return EvidenceService(ref.watch(evidenceRepositoryProvider));
});

final timelineServiceProvider = Provider((ref) {
  return TimelineService(ref.watch(timelineRepositoryProvider));
});

final evidenceReviewServiceProvider = Provider((ref) {
  return EvidenceReviewService(
    ref.watch(evidenceRepositoryProvider),
    eventBus: ref.watch(eventBusProvider),
  );
});

final normalizationPipelineProvider = Provider((ref) {
  return NormalizationPipeline(
    evidenceService: ref.watch(evidenceServiceProvider),
    timelineService: ref.watch(timelineServiceProvider),
    eventBus: ref.watch(eventBusProvider),
  );
});

final timelineProjectionListenerProvider = Provider((ref) {
  final listener = TimelineProjectionListener(
    eventBus: ref.watch(eventBusProvider),
    pipeline: ref.watch(normalizationPipelineProvider),
    evidenceService: ref.watch(evidenceServiceProvider),
  );
  return listener;
});

final manualConnectorProvider = Provider<ManualConnector>((ref) {
  final pipeline = ref.watch(normalizationPipelineProvider);
  final connector = ManualConnector(pipeline: pipeline);
  
  // Auto-register with Hub
  IntegrationHub.instance.register(connector);
  
  return connector;
});

final calendarVerificationEngineProvider = Provider((ref) {
  return CalendarVerificationEngine(
    eventBus: ref.watch(eventBusProvider),
    evidenceService: ref.watch(evidenceServiceProvider),
    reviewService: ref.watch(evidenceReviewServiceProvider),
  );
});

final googleCalendarConnectorProvider = Provider<GoogleCalendarConnector>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final pipeline = ref.watch(normalizationPipelineProvider);
  
  final connector = GoogleCalendarConnector(
    pipeline: pipeline,
    syncMetadataDao: db.syncMetadataDao,
  );
  
  IntegrationHub.instance.register(connector);
  
  return connector;
});

final integrationHubProvider = Provider<IntegrationHub>((ref) {
  final hub = IntegrationHub.instance;
  // Ensure connectors and listeners are active
  ref.watch(manualConnectorProvider);
  ref.watch(googleCalendarConnectorProvider);
  ref.watch(timelineProjectionListenerProvider);
  ref.watch(calendarVerificationEngineProvider);
  return hub;
});
