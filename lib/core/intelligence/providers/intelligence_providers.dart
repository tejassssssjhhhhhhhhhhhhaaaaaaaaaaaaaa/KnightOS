import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../domain/repositories/memory_repository.dart';
import '../domain/repositories/evidence_repository.dart';
import '../domain/repositories/drift_memory_repository.dart';
import '../domain/repositories/drift_evidence_repository.dart';
import '../services/json_validation_service.dart';
import '../services/memory_migration_service.dart';
import '../engines/memory_engine.dart';
import '../engines/ai_provider.dart';
import '../engines/intent_engine.dart';
import '../engines/reasoning_engine.dart';
import '../services/reasoning_service.dart';
import '../engines/graph/causal_reasoning_engine.dart';
import '../engines/planning_engine.dart';
import '../services/planning_service.dart';
import '../services/copilot_service.dart';
import '../engines/plugin_manager.dart';
import '../services/plugin_service.dart';
import '../engines/goal_intelligence.dart';
import '../engines/reflection_engine.dart';
import '../engines/insight_engine.dart';
import '../engines/identity_engine.dart';
import '../engines/context_engine.dart';
import '../engines/knowledge_graph.dart';
import '../engines/confidence_engine.dart';
import '../engines/decision_engine.dart';
import '../engines/rules_engine.dart';
import '../engines/world_engine.dart';
import '../engines/autonomous_engine.dart';
import '../engines/multi_device_manager.dart';
import '../engines/workflow_orchestrator.dart';
import '../engines/unified_search_layer.dart';
import '../engines/synthesis_engine.dart';
import '../services/search_service.dart';
import '../services/voice_service.dart';
import '../engines/optimization_engine.dart';
import '../engines/notification_engine.dart';
import '../services/world_service.dart';
import '../services/notification_service.dart';
import '../services/autonomous_service.dart';
import '../../world/adapters/mock_connectors.dart';
import '../../world/adapters/calendar_connector.dart';
import '../../world/adapters/email_connector.dart';
import '../../world/adapters/weather_connector.dart';
import '../../world/adapters/real_world_clients.dart';
import '../../world/adapters/real_world_mocks.dart';
import '../services/perception_scheduler.dart';
import '../engines/ai_router.dart';
import '../engines/multi_ai_providers.dart';
import '../domain/ai_models.dart';
import '../domain/intelligence_events.dart';
import '../domain/workflow_models.dart';
import '../domain/approval_models.dart';
import '../domain/device_models.dart';
import '../engines/life_chapters_engine.dart';
import '../engines/memory_health_engine.dart';
import '../engines/discovery_engine.dart';
import '../engines/verification_engine.dart';
import '../engines/observation_engine.dart';
import '../services/data_ingestion_service.dart';
import '../importers/import_framework.dart';
import '../knight_cognition.dart';
import '../../../features/discovery/infrastructure/question_bank_loader.dart';
import '../../../features/finance/memory_finance_service.dart';
import '../services/memory_service.dart';
import '../intelligence_bus.dart';
import '../intelligence_orchestrator.dart';
import '../intelligence_platform.dart';
import '../engines/memory_retrieval_engine.dart';
import '../engines/modules/world_context_module.dart';
import '../engines/modules/daily_briefing_module.dart';
import '../engines/modules/predictive_module.dart';
import '../engines/modules/insight_module.dart';
import '../engines/modules/mission_module.dart';
import '../engines/modules/synthesis_module.dart';
import '../engines/modules/recommendation_module.dart';
import '../engines/modules/health_module.dart';
import '../engines/modules/knowledge_module.dart';
import '../engines/modules/knowledge_graph_module.dart';
import '../services/embedding_service.dart';
import '../knight_context_provider.dart';
import '../../world/engines/device_intelligence.dart';

/// Provider for the Intelligence Bus.
final intelligenceBusProvider = Provider<IntelligenceBus>((ref) {
  return IntelligenceBus();
});

/// Provider for the Embedding Service.
final embeddingServiceProvider = Provider<EmbeddingService>((ref) {
  return EmbeddingService();
});

/// Provider for the Memory Retrieval Engine.
final memoryRetrievalEngineProvider = Provider<MemoryRetrievalEngine>((ref) {
  return MemoryRetrievalEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Knowledge Module.
final knowledgeModuleProvider = Provider<KnowledgeModule>((ref) {
  return KnowledgeModule(
    retrieval: ref.watch(memoryRetrievalEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    embeddingService: ref.watch(embeddingServiceProvider),
  );
});

/// Provider for the Knowledge Graph Module.
final knowledgeGraphModuleProvider = Provider<KnowledgeGraphModule>((ref) {
  return KnowledgeGraphModule(
    retrieval: ref.watch(memoryRetrievalEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );
});

/// Provider for the Mission Module.
final missionModuleProvider = Provider<MissionModule>((ref) {
  return MissionModule(
    retrieval: ref.watch(memoryRetrievalEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );
});

/// Provider for the Intelligence Orchestrator.
final intelligenceOrchestratorProvider = Provider<IntelligenceOrchestrator>((
  ref,
) {
  final orchestrator = IntelligenceOrchestrator(
    bus: ref.watch(intelligenceBusProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );

  // Register Modules
  final retrieval = ref.watch(memoryRetrievalEngineProvider);

  orchestrator.registerModule(
    WorldContextModule(
      retrieval: retrieval,
      deviceIntelligence: DeviceIntelligence(), // Future: Inject properly
    ),
  );

  orchestrator.registerModule(HealthModule(retrieval: retrieval));
  orchestrator.registerModule(ref.watch(knowledgeModuleProvider));
  orchestrator.registerModule(ref.watch(knowledgeGraphModuleProvider));
  orchestrator.registerModule(DailyBriefingModule(retrieval: retrieval));
  orchestrator.registerModule(PredictiveModule(retrieval: retrieval));
  orchestrator.registerModule(InsightModule(retrieval: retrieval));
  orchestrator.registerModule(ref.watch(missionModuleProvider));
  orchestrator.registerModule(
    SynthesisModule(
      retrieval: retrieval,
      synthesisEngine: SynthesisEngine(
        retrieval: retrieval,
        knowledgeGraph: KnowledgeGraph(memoryEngine: ref.watch(memoryEngineProvider)),
      ),
    ),
  );
  orchestrator.registerModule(RecommendationModule(retrieval: retrieval));

  return orchestrator;
});

/// Provider for the Intelligence Platform facade.
final intelligencePlatformProvider = Provider<IntelligencePlatform>((ref) {
  return IntelligencePlatform(
    bus: ref.watch(intelligenceBusProvider),
    orchestrator: ref.watch(intelligenceOrchestratorProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    retrieval: ref.watch(memoryRetrievalEngineProvider),
  );
});

/// Provider for the singleton database instance.
final knightDatabaseProvider = Provider<KnightDatabase>((ref) {
  final db = KnightDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider for the Memory Repository.
final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return DriftMemoryRepository(memoryDao: db.memoryDao);
});

/// Provider for the Evidence Repository.
final evidenceRepositoryProvider = Provider<EvidenceRepository>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return DriftEvidenceRepository(evidenceDao: db.evidenceDao);
});

/// Provider for the JSON Validation Service.
final jsonValidationServiceProvider = Provider<JsonValidationService>((ref) {
  return JsonValidationService(
    schemaDirectory: 'knight_knowledge_base/schemas/master_memory',
  );
});

/// The central Intelligence Engine for KnightOS.
final memoryEngineProvider = Provider<MemoryEngine>((ref) {
  return MemoryEngine(
    repository: ref.watch(memoryRepositoryProvider),
    validationService: ref.watch(jsonValidationServiceProvider),
    bus: ref.watch(intelligenceBusProvider),
  );
});

/// Provider for the Unified Memory Service.
final memoryServiceProvider = Provider<MemoryService>((ref) {
  return MemoryService(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Data Ingestion Service.
final dataIngestionServiceProvider = Provider<DataIngestionService>((ref) {
  return DataIngestionService(
    memoryEngine: ref.watch(memoryEngineProvider),
    knowledgeGraph: ref.watch(knowledgeGraphProvider),
    discoveryEngine: ref.watch(discoveryEngineProvider),
  );
});

/// Provider for the Copilot Service.
final copilotServiceProvider = Provider<CopilotService>((ref) {
  return CopilotService(
    cognition: ref.watch(knightCognitionProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    contextService: ref.watch(knightContextServiceProvider),
    planningService: ref.watch(planningServiceProvider),
  );
});

/// Provider for the Plugin Service.
final pluginServiceProvider = Provider<PluginService>((ref) {
  return PluginService(manager: PluginManager());
});

/// Provider for the Notification Engine.
final notificationEngineProvider = Provider<NotificationEngine>((ref) {
  return NotificationEngine(bus: ref.watch(intelligenceBusProvider));
});

/// Provider for the Notification Service.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(engine: ref.watch(notificationEngineProvider));
});

/// Provider for the AI Router.
final aiRouterProvider = Provider<AiRouter>((ref) {
  final router = AiRouter();
  
  router.registerProvider(
    GeminiProvider(),
    const ModelManifest(
      id: 'gemini-1.5-pro',
      name: 'Gemini Pro',
      capabilities: [AiCapability.precise, AiCapability.longContext],
      providerName: 'Google',
    ),
  );
  
  router.registerProvider(
    FlashModelProvider(),
    const ModelManifest(
      id: 'gemini-1.5-flash',
      name: 'Gemini Flash',
      capabilities: [AiCapability.fast],
      providerName: 'Google',
    ),
  );

  router.registerProvider(
    OpenAiProvider(),
    const ModelManifest(
      id: 'gpt-4o',
      name: 'GPT-4o',
      capabilities: [AiCapability.precise, AiCapability.imageAware],
      providerName: 'OpenAI',
    ),
  );

  return router;
});

/// Provider for the client-side Finance Service.
final financeServiceProvider = Provider<MemoryFinanceService>((ref) {
  return MemoryFinanceService(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Question Bank Loader.
final questionBankLoaderProvider = Provider<QuestionBankLoader>((ref) {
  return const QuestionBankLoader();
});

/// Provider for the Verification Engine.
final verificationEngineProvider = Provider<VerificationEngine>((ref) {
  return VerificationEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Discovery Engine.
final discoveryEngineProvider = Provider<DiscoveryEngine>((ref) {
  return DiscoveryEngine(
    memoryEngine: ref.watch(memoryEngineProvider),
    loader: ref.watch(questionBankLoaderProvider),
    verificationEngine: ref.watch(verificationEngineProvider),
  );
});

/// Provider for the Observation Engine.
final observationEngineProvider = Provider<ObservationEngine>((ref) {
  return ObservationEngine(
    memoryEngine: ref.watch(memoryEngineProvider),
    bus: ref.watch(intelligenceBusProvider),
  );
});

/// Provider for the AI backend implementation.
final aiProviderImplProvider = Provider<KnightAiProvider>((ref) {
  return MockAiProvider();
});

/// Provider for the Intent Detection Engine.
final intentEngineProvider = Provider<IntentEngine>((ref) {
  return const IntentEngine();
});

/// Provider for the Reasoning Engine.
final reasoningEngineProvider = Provider<ReasoningEngine>((ref) {
  return const ReasoningEngine();
});

/// Provider for the Reasoning Service.
final Provider<ReasoningService> reasoningServiceProvider = Provider<ReasoningService>((ref) {
  return ReasoningService(
    engine: ref.watch(reasoningEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    contextService: ref.watch(knightContextServiceProvider),
    worldService: ref.watch(worldServiceProvider),
    contextEngine: ref.watch(contextEngineProvider),
    optimizationEngine: ref.watch(optimizationEngineProvider),
  );
});

/// Provider for the Causal Reasoning Engine.
final causalReasoningEngineProvider = Provider<CausalReasoningEngine>((ref) {
  return CausalReasoningEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Knight Cognitive Layer Coordinator.
final knightCognitionProvider = Provider<KnightCognition>((ref) {
  return KnightCognition(
    intentEngine: ref.watch(intentEngineProvider),
    contextEngine: ref.watch(contextEngineProvider),
    reasoningEngine: ref.watch(reasoningEngineProvider),
    planningService: ref.watch(planningServiceProvider),
    aiRouter: ref.watch(aiRouterProvider),
    contextService: ref.watch(knightContextServiceProvider),
    worldService: ref.watch(worldServiceProvider),
    causalEngine: ref.watch(causalReasoningEngineProvider),
  );
});

/// Provider for the Optimization Engine.
final optimizationEngineProvider = Provider<OptimizationEngine>((ref) {
  return OptimizationEngine(bus: ref.watch(intelligenceBusProvider));
});

/// Provider for the Planning Engine.
final planningEngineProvider = Provider<PlanningEngine>((ref) {
  return PlanningEngine(
    aiProvider: ref.watch(aiProviderImplProvider),
    optimizationEngine: ref.watch(optimizationEngineProvider),
  );
});

/// Provider for the Planning Service.
final Provider<PlanningService> planningServiceProvider = Provider<PlanningService>((ref) {
  return PlanningService(
    engine: ref.watch(planningEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
    contextService: ref.watch(knightContextServiceProvider),
    reasoningService: ref.watch(reasoningServiceProvider),
    worldService: ref.watch(worldServiceProvider),
  );
});

/// Provider for Goal Intelligence.
final goalIntelligenceProvider = Provider<GoalIntelligence>((ref) {
  return GoalIntelligence(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Reflection Engine.
final reflectionEngineProvider = Provider<ReflectionEngine>((ref) {
  return ReflectionEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Insight Engine.
final insightEngineProvider = Provider<InsightEngine>((ref) {
  return const InsightEngine();
});

/// Provider for the Knowledge Graph.
final knowledgeGraphProvider = Provider<KnowledgeGraph>((ref) {
  return KnowledgeGraph(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Identity Engine.
final identityEngineProvider = Provider<IdentityEngine>((ref) {
  return IdentityEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Context Engine.
final contextEngineProvider = Provider<ContextEngine>((ref) {
  return ContextEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Confidence Engine.
final confidenceEngineProvider = Provider<ConfidenceEngine>((ref) {
  return const ConfidenceEngine();
});

/// Provider for the Decision Engine.
final decisionEngineProvider = Provider<DecisionEngine>((ref) {
  return DecisionEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Rules Engine.
final rulesEngineProvider = Provider<RulesEngine>((ref) {
  return RulesEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Life Chapters Engine.
final lifeChaptersEngineProvider = Provider<LifeChaptersEngine>((ref) {
  return LifeChaptersEngine(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Memory Health Engine.
final memoryHealthEngineProvider = Provider<MemoryHealthEngine>((ref) {
  return MemoryHealthEngine();
});

/// Provider for the Import Framework.
final importFrameworkProvider = Provider<ImportFramework>((ref) {
  return ImportFramework(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the World Engine.
final Provider<WorldEngine> worldEngineProvider = Provider<WorldEngine>((ref) {
  return WorldEngine(
    bus: ref.watch(intelligenceBusProvider),
  );
});

/// Provider for the World Service.
final Provider<WorldService> worldServiceProvider = Provider<WorldService>((ref) {
  final service = WorldService(
    engine: ref.watch(worldEngineProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );
  
  // Register Mock Connectors for Sprint 5
  service.registerConnector(MockCalendarConnector());
  service.registerConnector(MockWeatherConnector());
  service.registerConnector(MockFinanceConnector());
  service.registerConnector(GoogleEmailConnector(client: MockEmailClient()));

  // Register V4 Real-world style Connectors
  service.registerConnector(
    GoogleCalendarConnector(client: GoogleCalendarClientImpl()),
  );
  service.registerConnector(OpenWeatherConnector(client: OpenWeatherClientImpl()));
  service.registerConnector(
    GoogleEmailConnector(client: GoogleEmailClientImpl()),
  );
  
  return service;
});

/// Provider for the Perception Scheduler.
final perceptionSchedulerProvider = Provider<PerceptionScheduler>((ref) {
  return PerceptionScheduler(worldService: ref.watch(worldServiceProvider));
});

/// Provider for the Autonomous Engine.
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

/// Provider for the Workflow Orchestrator.
final workflowOrchestratorProvider = Provider<WorkflowOrchestrator>((ref) {
  return WorkflowOrchestrator(engine: ref.watch(autonomousEngineProvider));
});

/// Provider for the Autonomous Service.
final autonomousServiceProvider = Provider<AutonomousService>((ref) {
  return AutonomousService(engine: ref.watch(autonomousEngineProvider));
});

/// Provider for the Multi-Device Manager.
final multiDeviceManagerProvider = Provider<MultiDeviceManager>((ref) {
  return MultiDeviceManager(bus: ref.watch(intelligenceBusProvider));
});

/// Provider for the Memory Migration Service.
final memoryMigrationServiceProvider = Provider<MemoryMigrationService>((ref) {
  return MemoryMigrationService(memoryEngine: ref.watch(memoryEngineProvider));
});

/// Provider for the Unified Search Layer.
final unifiedSearchLayerProvider = Provider<UnifiedSearchLayer>((ref) {
  return UnifiedSearchLayer(
    memoryEngine: ref.watch(memoryEngineProvider),
    intentEngine: ref.watch(intentEngineProvider),
  );
});

/// Provider for the Smart Search Service.
final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(layer: ref.watch(unifiedSearchLayerProvider));
});

/// Provider for active autonomous executions.
final activeExecutionsProvider = StreamProvider<List<WorkflowState>>((ref) {
  final bus = ref.watch(intelligenceBusProvider);
  final List<WorkflowState> active = [];

  return bus.events.where((e) => e is WorkflowUpdatedEvent).map((e) {
    final state = (e as WorkflowUpdatedEvent).state;
    active.removeWhere((s) => s.planId == state.planId);
    if (state.status == WorkflowStatus.running || 
        state.status == WorkflowStatus.awaitingApproval || 
        state.status == WorkflowStatus.queued) {
      active.add(state);
    }
    return List<WorkflowState>.unmodifiable(active);
  });
});

/// Provider for pending autonomous approvals.
final pendingApprovalsProvider = StreamProvider<List<ApprovalRequest>>((ref) {
  final bus = ref.watch(intelligenceBusProvider);
  final engine = ref.watch(autonomousEngineProvider);
  
  return bus.events.where((e) => e is ApprovalRequestedEvent || e is ApprovalResolvedEvent).map((_) {
    return List<ApprovalRequest>.unmodifiable(engine.pendingApprovals);
  });
});

/// Provider for connected devices.
final connectedDevicesProvider = StreamProvider<List<KnightDevice>>((ref) {
  return ref.watch(multiDeviceManagerProvider).devices;
});

/// Provider for external integration status.
final externalIntegrationsProvider = FutureProvider<Map<String, bool>>((ref) async {
  final service = ref.watch(worldServiceProvider);
  final connectors = service.engine.registeredConnectors;
  
  final Map<String, bool> results = {};
  for (final connector in connectors) {
    results[connector.name] = await connector.isAvailable();
  }
  return results;
});

/// Provider for the Voice Service.
final voiceServiceProvider = NotifierProvider<VoiceService, VoiceState>(VoiceService.new);
