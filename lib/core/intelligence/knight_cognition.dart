import 'package:collection/collection.dart';
import 'package:knight_os/core/intelligence/engines/intent_engine.dart';
import 'package:knight_os/core/intelligence/engines/context_engine.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';
import 'package:knight_os/core/intelligence/engines/ai_router.dart';
import 'package:knight_os/core/intelligence/engines/graph/causal_reasoning_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';
import 'package:knight_os/core/intelligence/services/planning_service.dart';
import 'package:knight_os/core/intelligence/services/world_service.dart';
import 'package:knight_os/core/intelligence/services/data_retrieval_service.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/planning_models.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';

/// The central coordinator for the Knight Cognitive Layer.
class KnightCognition {
  KnightCognition({
    required this.intentEngine,
    required this.contextEngine,
    required this.reasoningEngine,
    required this.planningService,
    required this.aiRouter,
    required this.contextService,
    required this.worldService,
    required this.retrievalService,
    this.causalEngine,
  });

  final IntentEngine intentEngine;
  final ContextEngine contextEngine;
  final ReasoningEngine reasoningEngine;
  final PlanningService planningService;
  final AiRouter aiRouter;
  final KnightContextService contextService;
  final WorldService worldService;
  final DataRetrievalService retrievalService;
  final CausalReasoningEngine? causalEngine;

  /// Processes a user request through the full cognitive pipeline.
  Future<CognitiveResult> processRequest(
    String text, {
    List<String> history = const [],
    String currentModule = 'system',
    String currentScreen = '/',
  }) async {
    // 1. Intent Detection
    final intent = intentEngine.detectIntent(text);

    // 2. Model Selection (Multi-Model Sprint 2.1)
    final aiProvider = aiRouter.selectProvider(intent);

    // 3. Memory Context Assembly
    final memories = intent == KnightIntent.conversation 
      ? <KnightMemory>[] 
      : await contextEngine.buildActiveContext(
          query: text,
          intent: intent,
          worldState: worldService.currentState,
        );

    // 3.1. Real Data Retrieval (Sprint V5.2 Category 1 Phase 3)
    final realEvidence = await retrievalService.retrieveEvidence(intent, text);

    // 3.2 Build User Context
    final context = contextService.buildContext(
      featureModules: [], // Future: Pass registered modules
      recentMemories: memories,
      worldState: worldService.currentState,
      currentModule: currentModule,
      currentScreen: currentScreen,
    );

    // 4. Reasoning
    final reasoningResult = await reasoningEngine.reason(
      context: context,
      memories: memories,
    );
    
    ReasoningTrace trace = reasoningResult.trace.copyWith(
      evidence: realEvidence,
    );

    // 5. Planning (Version 3 Sprint 4)
    KnightPlan? plan;
    if (intent == KnightIntent.planning || reasoningResult.recommendations.isNotEmpty) {
      final planningResult = planningService.engine.plan(
        context: context,
        memories: memories,
        reasoning: reasoningResult,
      );
      plan = planningResult.dailyPlan;
    }

    // 6. Causal Analysis
    if (intent == KnightIntent.analysis && causalEngine != null) {
      // Attempt to find causal links for the primary context item
      final firstMemory = memories.firstOrNull;
      if (firstMemory != null) {
        final links = await causalEngine!.findWhy(firstMemory.id);
        if (links.isNotEmpty) {
          trace = trace.copyWith(
            graphPath: links
                .map((l) => l.source.summary ?? l.source.id)
                .toList(),
          );
        }
      }
    }

    // 7. AI Generation
    // We pass the reasoning trace findings into the prompt.
    final augmentedPrompt = _buildAugmentedPrompt(text, trace, history, context);
    final response = await aiProvider.chat(
      context: memories,
      evidence: trace.evidence, // Passing retrieved evidence to the provider
      prompt: augmentedPrompt,
    );

    return CognitiveResult(response: response, trace: trace, plan: plan);
  }

  String _buildAugmentedPrompt(String text, ReasoningTrace trace, List<String> history, KnightContext context) {
    final buffer = StringBuffer();
    
    buffer.writeln('System Context:');
    buffer.writeln('- Current Time: ${DateTime.now()}');
    buffer.writeln('- User Greeting: ${context.greeting}');
    buffer.writeln('- User Status: ${context.healthStatus}');
    
    // Privacy & Sensitivity Filtering
    if (trace.intent == KnightIntent.analysis || trace.intent == KnightIntent.question) {
       buffer.writeln('- Total Balance: ₹${context.totalBalance}');
       buffer.writeln('- Step Count: ${context.steps}');
       buffer.writeln('- Sleep Status: ${context.sleepStatus}');
    }

    buffer.writeln('- Current Module: ${context.currentModule}');
    buffer.writeln('- Current Screen: ${context.currentScreen}');
    if (context.activeActivity != 'stationary') {
      buffer.writeln('- Device Activity: ${context.activeActivity}');
    }
    buffer.writeln('---');

    if (history.isNotEmpty) {
      buffer.writeln('Conversation History:');
      for (var msg in history) {
        buffer.writeln('- $msg');
      }
      buffer.writeln('---');
    }

    if (trace.potentialRisks.isNotEmpty) {
      buffer.writeln('Detected Risks: ${trace.potentialRisks.join(', ')}');
      buffer.writeln('Instruction: Evaluate if this request harms long-term goals. If so, challenge respectfully.');
    }

    if (trace.evidence.isNotEmpty) {
      buffer.writeln('Retrieved Evidence (OBSERVED):');
      for (final e in trace.evidence) {
        buffer.writeln('- Source: ${e.source} (${e.timestamp})');
        buffer.writeln('  Data: ${e.metadata}');
      }
      buffer.writeln('Instruction: Ground your answer strictly in the OBSERVED evidence above. If evidence is insufficient, state that the information is unavailable.');
      buffer.writeln('---');
    }

    buffer.writeln('### USER REQUEST');
    buffer.writeln(text);
    
    return buffer.toString();
  }
}

class CognitiveResult {
  const CognitiveResult({required this.response, required this.trace, this.plan});
  final String response;
  final ReasoningTrace trace;
  final KnightPlan? plan;
}
