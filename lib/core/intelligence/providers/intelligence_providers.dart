import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';

// Engines
import '../engines/discovery_engine.dart';
import '../engines/intent_engine.dart';
import '../engines/context_engine.dart';
import '../engines/reasoning_engine.dart';
import '../engines/planning_engine.dart';
import '../engines/optimization_engine.dart';
import '../engines/ai_router.dart';
import '../engines/memory_engine.dart';
import '../engines/verification_engine.dart';
import '../engines/observation_engine.dart';
import '../engines/world_engine.dart';
import '../engines/memory_retrieval_engine.dart';
import '../engines/autonomous_engine.dart';
import '../engines/sensor_fusion_engine.dart';
import '../engines/perception_engine.dart';
import '../engines/local_llm_engine.dart';
import '../engines/wasm_reasoning_runtime.dart';
import '../engines/modules/health_module.dart';
import '../engines/modules/mission_module.dart';
import '../engines/modules/work_module.dart';
import '../engines/modules/finance_module.dart';
import '../engines/modules/career_strategic_module.dart';
import '../engines/strategic/gap_analysis_engine.dart';
import '../engines/workspace_extraction_engine.dart';

// Platform Engines
import '../../platform/engine/scoring_engine.dart';
import '../../platform/engine/recommendation_engine.dart';
import '../../platform/engine/analytics_engine.dart';
import '../../platform/engine/engine_interfaces.dart';
import '../../platform/engine/knight_engine.dart'; // For PlatformEventBus
import '../../platform/engine/edge_ai_orchestrator.dart';

// Services
import '../services/activity_feed_repository.dart';
import '../services/perception_scheduler.dart';
import '../services/planning_service.dart';
import '../services/reasoning_service.dart';
import '../services/voice_service.dart';
import '../services/world_service.dart';
import '../services/data_provider_registry.dart';
import '../services/priority_engine.dart';
import '../services/json_validation_service.dart';
import '../services/autonomous_service.dart'; 
import '../services/memory_service.dart';
import '../services/dataset_verification_service.dart';
import '../services/email_classification_service.dart';

// Internal/Services
import '../../internal/services/greeting_service.dart';

// Domain/Infrastructure
import '../intelligence_bus.dart';
import '../intelligence_platform.dart';
import '../intelligence_orchestrator.dart';
import '../knight_cognition.dart';
import '../knight_context_provider.dart';
import '../domain/repositories/memory_repository.dart';
import '../domain/repositories/drift_memory_repository.dart';
import '../qa/knight_ai_test_suite.dart';
import '../../../../features/discovery/infrastructure/question_bank_loader.dart';
import '../domain/cognitive_models.dart';
import '../../repositories/system_integrity_repository.dart'; 
import '../../repositories/mission_repository.dart'; 
import '../../repositories/health_repository.dart'; 
import '../domain/data_provider.dart';

// Data Infrastructure
import 'data_providers.dart';

export 'data_providers.dart';

import '../engines/ai_provider.dart';
import '../domain/ai_models.dart';

// (Infrastructure)

final intelligenceBusProvider = Provider<IntelligenceBus>((ref) {
  final bus = IntelligenceBus();
  ref.onDispose(() => bus.dispose());
  return bus;
});

/// Adapter to provide ref as KnightServiceProvider
class RiverpodServiceProvider implements KnightServiceProvider {
  RiverpodServiceProvider(this.ref);
  final Ref ref;

  @override
  void register<T>(T implementation, {String? key}) {
    // Riverpod is the registry
  }

  @override
  T resolve<T>({String? key}) {
    if (T == IntelligenceBus) return ref.read(intelligenceBusProvider) as T;
    throw UnimplementedError('Cannot resolve $T via RiverpodServiceProvider');
  }
}

final knightServiceProvider = Provider<KnightServiceProvider>((ref) {
  return RiverpodServiceProvider(ref);
});

final platformEventBusProvider = Provider<KnightEventBus>((ref) {
  return PlatformEventBus(intelligenceBus: ref.watch(intelligenceBusProvider));
});

final edgeAiOrchestratorProvider = Provider<EdgeAiOrchestrator>((ref) {
  return EdgeAiOrchestrator();
});

final localLlmEngineProvider = Provider<LocalLlmEngine>((ref) {
  return LocalLlmEngine(runtime: WasmReasoningRuntime());
});

final sensorFusionEngineProvider = Provider<SensorFusionEngine>((ref) {
  return SensorFusionEngine();
});

final perceptionEngineProvider = NotifierProvider<PerceptionEngine, String>(PerceptionEngine.new);

final workspaceExtractionEngineProvider = Provider<WorkspaceExtractionEngine>((ref) {
  return WorkspaceExtractionEngine();
});

// Production Engines

final scoringEngineProvider = Provider<PlatformScoringEngine>((ref) {
  return PlatformScoringEngine(
    eventBus: ref.watch(platformEventBusProvider),
  );
});

final recommendationEngineProvider = Provider<PlatformRecommendationEngine>((ref) {
  return PlatformRecommendationEngine(
    eventBus: ref.watch(platformEventBusProvider),
    graphService: ref.read(knowledgeGraphServiceProvider), // Use read if it might not be ready
  );
});

final analyticsEngineProvider = Provider<AnalyticsEngine>((ref) {
  return AnalyticsEngine(
    eventBus: ref.watch(platformEventBusProvider),
  );
});

final intelligencePlatformProvider = Provider<IntelligencePlatform>((ref) {
  return IntelligencePlatform(
    bus: ref.watch(intelligenceBusProvider),
    orchestrator: ref.watch(intelligenceOrchestratorProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    retrieval: ref.watch(memoryRetrievalEngineProvider),
  );
});

final intelligenceOrchestratorProvider = Provider<IntelligenceOrchestrator>((ref) {
  final orchestrator = IntelligenceOrchestrator(
    bus: ref.watch(intelligenceBusProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    scoringEngine: ref.watch(scoringEngineProvider),
    recommendationEngine: ref.watch(recommendationEngineProvider),
    analyticsEngine: ref.watch(analyticsEngineProvider),
    edgeAi: ref.watch(edgeAiOrchestratorProvider),
  );

  // Register built-in modules
  orchestrator.registerModule(HealthModule(
    retrieval: ref.watch(memoryRetrievalEngineProvider),
    db: ref.watch(knightDatabaseProvider),
    graphService: ref.watch(knowledgeGraphServiceProvider),
    verificationEngine: ref.watch(verificationEngineProvider),
  ));

  orchestrator.registerModule(MissionModule(
    retrieval: ref.watch(memoryRetrievalEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  ));

  orchestrator.registerModule(WorkModule(
    db: ref.watch(knightDatabaseProvider),
  ));

  orchestrator.registerModule(FinanceModule(
    db: ref.watch(knightDatabaseProvider),
    graphService: ref.watch(knowledgeGraphServiceProvider),
  ));

  orchestrator.registerModule(CareerStrategicModule(
    retrieval: ref.watch(memoryRetrievalEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    gapEngine: GapAnalysisEngine(memoryEngine: ref.watch(memoryEngineProvider)),
  ));

  return orchestrator;
});

final jsonValidationServiceProvider = Provider<JsonValidationService>((ref) {
  return JsonValidationService(schemaDirectory: 'assets/schemas');
});

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return DriftMemoryRepository(memoryDao: db.memoryDao);
});

// (Engines)

final intentEngineProvider = Provider<IntentEngine>((ref) => const IntentEngine());

final contextEngineProvider = Provider<ContextEngine>((ref) {
  return ContextEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

final reasoningEngineProvider = Provider<ReasoningEngine>((ref) {
  return ReasoningEngine(llmEngine: ref.watch(localLlmEngineProvider));
});

final optimizationEngineProvider = Provider<OptimizationEngine>((ref) {
  return OptimizationEngine(bus: ref.watch(intelligenceBusProvider));
});

final aiRouterHighLevelProvider = Provider<AiRouter>((ref) {
  final router = AiRouter();
  final mock = MockAiProvider();
  router.registerProvider(mock, const ModelManifest(
    id: 'mock-knight-v1',
    name: 'Knight Mock',
    capabilities: [AiCapability.fast, AiCapability.precise],
    providerName: 'Mock',
  ));
  return router;
});

final planningEngineProvider = Provider<PlanningEngine>((ref) {
  final router = ref.watch(aiRouterHighLevelProvider);
  return PlanningEngine(
    aiProvider: router.selectProvider(KnightIntent.planning),
    optimizationEngine: ref.watch(optimizationEngineProvider),
  );
});

final memoryEngineProvider = Provider<MemoryEngine>((ref) {
  return MemoryEngine(
    repository: ref.watch(memoryRepositoryProvider),
    validationService: ref.watch(jsonValidationServiceProvider),
    bus: ref.watch(intelligenceBusProvider),
  );
});

final verificationEngineProvider = Provider<VerificationEngine>((ref) {
  return VerificationEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

final observationEngineProvider = Provider<ObservationEngine>((ref) {
  return ObservationEngine(
    memoryEngine: ref.watch(memoryEngineProvider),
    bus: ref.watch(intelligenceBusProvider),
  );
});

final worldEngineProvider = Provider<WorldEngine>((ref) {
  return WorldEngine(bus: ref.watch(intelligenceBusProvider));
});

final memoryRetrievalEngineProvider = Provider<MemoryRetrievalEngine>((ref) {
  return MemoryRetrievalEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

// (System Level Services)

final knightCognitionProvider = Provider<KnightCognition>((ref) {
  return KnightCognition(
    intentEngine: ref.watch(intentEngineProvider),
    contextEngine: ref.watch(contextEngineProvider),
    reasoningEngine: ref.watch(reasoningEngineProvider),
    planningService: ref.watch(planningServiceProvider),
    aiRouter: ref.watch(aiRouterHighLevelProvider),
    contextService: ref.watch(knightContextServiceProvider),
    worldService: ref.watch(worldServiceProvider),
  );
});

final discoveryEngineProvider = Provider<DiscoveryEngine>((ref) {
  return DiscoveryEngine(
    memoryEngine: ref.watch(memoryEngineProvider),
    loader: ref.watch(questionBankLoaderProvider),
    verificationEngine: ref.watch(verificationEngineProvider),
  );
});

final questionBankLoaderProvider = Provider<QuestionBankLoader>((ref) {
  return const QuestionBankLoader();
});

final greetingServiceProvider = Provider<GreetingService>((ref) {
  return const GreetingService();
});

final voiceServiceProvider = NotifierProvider<VoiceService, VoiceState>(VoiceService.new);

final worldServiceProvider = Provider<WorldService>((ref) {
  return WorldService(
    engine: ref.watch(worldEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );
});

final memoryServiceProvider = Provider<MemoryService>((ref) {
  return MemoryService(memoryEngine: ref.watch(memoryEngineProvider));
});

final reasoningServiceProvider = Provider<ReasoningService>((ref) {
  return ReasoningService(
    engine: ref.watch(reasoningEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    contextService: ref.watch(knightContextServiceProvider),
    worldService: ref.watch(worldServiceProvider),
    contextEngine: ref.watch(contextEngineProvider),
    optimizationEngine: ref.watch(optimizationEngineProvider),
    graphService: ref.watch(knowledgeGraphServiceProvider),
  );
});

final planningServiceProvider = Provider<PlanningService>((ref) {
  return PlanningService(
    engine: ref.watch(planningEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    contextService: ref.watch(knightContextServiceProvider),
    reasoningService: ref.watch(reasoningServiceProvider),
    worldService: ref.watch(worldServiceProvider),
  );
});

final activityFeedRepositoryProvider = Provider<ActivityFeedRepository>((ref) {
  return ActivityFeedRepository(db: ref.watch(knightDatabaseProvider));
});

// (Data)

final datasetVerificationServiceProvider = Provider<DatasetVerificationService>((ref) {
  return DatasetVerificationService(
    db: ref.watch(knightDatabaseProvider),
    hashService: ref.watch(documentHashServiceProvider),
  );
});

final priorityEngineProvider = Provider<PriorityEngine>((ref) {
  return const PriorityEngine();
});

final dataProviderRegistryProvider = NotifierProvider<DataProviderRegistry, List<DataProvider>>(DataProviderRegistry.new);

final perceptionSchedulerProvider = Provider<PerceptionScheduler>((ref) {
  return PerceptionScheduler(worldService: ref.watch(worldServiceProvider));
});

// (QA/Testing)
final knightAiTestSuiteProvider = Provider<KnightAiTestSuite>((ref) {
  return KnightAiTestSuite(cognition: ref.watch(knightCognitionProvider));
});

// (Missing Repositories for Screens)

final systemIntegrityRepositoryProvider = Provider<SystemIntegrityRepository>((ref) {
  return SystemIntegrityRepository(db: ref.watch(knightDatabaseProvider));
});

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository(
    db: ref.watch(knightDatabaseProvider),
    weaver: ref.watch(knowledgeGraphWeaverProvider),
  );
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository(db: ref.watch(knightDatabaseProvider));
});

final autonomousEngineProvider = Provider<AutonomousEngine>((ref) {
   return AutonomousEngine(
     bus: ref.watch(intelligenceBusProvider),
     memoryEngine: ref.watch(memoryEngineProvider),
     reasoningEngine: ref.watch(reasoningEngineProvider),
     getContext: () => ref.read(currentContextNotifierProvider.future),
     worldService: ref.watch(worldServiceProvider),
     voiceService: ref.watch(voiceServiceProvider.notifier),
   );
});

final autonomousServiceProvider = Provider<AutonomousService>((ref) {
   return AutonomousService(
     engine: ref.watch(autonomousEngineProvider),
     bus: ref.watch(intelligenceBusProvider),
   );
});

final activeExecutionsProvider = StreamProvider<List<dynamic>>((ref) {
  return ref.watch(autonomousServiceProvider).watchActiveExecutions();
});

final pendingApprovalsProvider = StreamProvider<List<dynamic>>((ref) {
  return ref.watch(autonomousServiceProvider).watchPendingApprovals();
});

final vaultItemsProvider = Provider<List<dynamic>>((ref) => []); // Placeholder

final emailClassificationServiceProvider = Provider<EmailClassificationService>((ref) {
  return EmailClassificationService(db: ref.watch(knightDatabaseProvider));
});
