import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';
import '../services/data_ingestion_service.dart';
import '../engines/email_extraction_engine.dart';
import '../services/document_hash_service.dart';
import '../services/knowledge_graph_service.dart';
import '../services/knowledge_graph_weaver.dart';
import '../services/identity_resolution_service.dart';
import '../services/entity_extraction_service.dart';
import '../services/runtime_recorder_service.dart';
import '../services/snapshot_service.dart';
import '../services/health_intelligence_service.dart';
import '../services/nutrition_sync_service.dart';
import '../services/workout_orchestrator.dart';
import '../services/health_tracker_service.dart';
import '../services/ocr_knowledge_service.dart';
import '../../internal/storage/backup_service.dart';
import '../../internal/storage/restore_service.dart';
import '../providers/intelligence_providers.dart';
import '../../providers/storage_providers.dart';

final dataIngestionServiceProvider = Provider<DataIngestionService>((ref) {
  return DataIngestionService(
    db: ref.watch(knightDatabaseProvider),
    hashService: ref.watch(documentHashServiceProvider),
    prefsService: ref.watch(importPreferenceServiceProvider),
    graphService: ref.watch(knowledgeGraphServiceProvider),
    graphWeaver: ref.watch(knowledgeGraphWeaverProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );
});

final emailExtractionEngineProvider = Provider<EmailExtractionEngine>((ref) {
  return EmailExtractionEngine(
    ingestionService: ref.watch(dataIngestionServiceProvider),
  );
});

final entityExtractionServiceProvider = Provider<EntityExtractionService>((ref) {
  return EntityExtractionService(
    db: ref.watch(knightDatabaseProvider),
    identityService: ref.watch(identityResolutionServiceProvider),
    workspaceEngine: ref.watch(workspaceExtractionEngineProvider),
    ingestionService: ref.watch(dataIngestionServiceProvider),
  );
});

final runtimeRecorderServiceProvider = Provider<RuntimeRecorderService>((ref) {
  return RuntimeRecorderService(db: ref.watch(knightDatabaseProvider));
});

final snapshotServiceProvider = Provider<SnapshotService>((ref) {
  return SnapshotService(db: ref.watch(knightDatabaseProvider));
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(db: ref.watch(knightDatabaseProvider));
});

final restoreServiceProvider = Provider<RestoreService>((ref) {
  return RestoreService();
});

final healthIntelligenceServiceProvider = Provider<HealthIntelligenceService>((ref) {
  return HealthIntelligenceService(db: ref.watch(knightDatabaseProvider));
});

final nutritionSyncServiceProvider = Provider<NutritionSyncService>((ref) {
  return NutritionSyncService(db: ref.watch(knightDatabaseProvider));
});

final workoutOrchestratorProvider = Provider<WorkoutOrchestrator>((ref) {
  return WorkoutOrchestrator(db: ref.watch(knightDatabaseProvider));
});

final healthTrackerServiceProvider = Provider<HealthTrackerService>((ref) {
  return HealthTrackerService(db: ref.watch(knightDatabaseProvider));
});

final ocrKnowledgeServiceProvider = Provider<OcrKnowledgeService>((ref) {
  return OcrKnowledgeService(
    bus: ref.watch(intelligenceBusProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );
});

final documentHashServiceProvider = Provider<DocumentHashService>((ref) {
  return const DocumentHashService();
});

final knowledgeGraphServiceProvider = Provider<KnowledgeGraphService>((ref) {
  return KnowledgeGraphService(db: ref.watch(knightDatabaseProvider));
});

final knowledgeGraphWeaverProvider = Provider<KnowledgeGraphWeaver>((ref) {
  return KnowledgeGraphWeaver(graphService: ref.watch(knowledgeGraphServiceProvider));
});

final identityResolutionServiceProvider = Provider<IdentityResolutionService>((ref) {
  return IdentityResolutionService(db: ref.watch(knightDatabaseProvider));
});
