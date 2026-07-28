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
import '../engines/graph/causal_reasoning_engine.dart';
import '../engines/planning_engine.dart';
import '../engines/goal_intelligence.dart';
import '../engines/reflection_engine.dart';
import '../engines/insight_engine.dart';
import '../engines/identity_engine.dart';
import '../engines/context_engine.dart';
import '../engines/knowledge_graph.dart';
import '../engines/confidence_engine.dart';
import '../engines/decision_engine.dart';
import '../engines/rules_engine.dart';
import '../engines/life_chapters_engine.dart';
import '../engines/memory_health_engine.dart';
import '../engines/discovery_engine.dart';
import '../engines/verification_engine.dart';
import '../engines/observation_engine.dart';
import '../importers/import_framework.dart';
import '../knight_cognition.dart';
import '../../../features/discovery/infrastructure/question_bank_loader.dart';
import '../../../features/memory/memory_service.dart';
import '../../../features/finance/memory_finance_service.dart';
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
  orchestrator.registerModule(SynthesisModule(retrieval: retrieval));
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

/// Provider for the client-side Memory Service.
final memoryServiceProvider = Provider<MemoryService>((ref) {
  return MemoryService(memoryEngine: ref.watch(memoryEngineProvider));
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
    causalEngine: ref.watch(causalReasoningEngineProvider),
    aiProvider: ref.watch(aiProviderImplProvider),
  );
});

/// Provider for the Planning Engine.
final planningEngineProvider = Provider<PlanningEngine>((ref) {
  return PlanningEngine(memoryEngine: ref.watch(memoryEngineProvider));
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

/// Provider for the Memory Migration Service.
final memoryMigrationServiceProvider = Provider<MemoryMigrationService>((ref) {
  return MemoryMigrationService(memoryEngine: ref.watch(memoryEngineProvider));
});
