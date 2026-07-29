import 'engines/intent_engine.dart';
import 'engines/context_engine.dart';
import 'engines/reasoning_engine.dart';
import 'engines/ai_router.dart';
import 'engines/graph/causal_reasoning_engine.dart';
import 'knight_context_service.dart';
import 'services/planning_service.dart';
import 'services/world_service.dart';
import 'domain/cognitive_models.dart';
import 'domain/planning_models.dart';

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
    this.causalEngine,
  });

  final IntentEngine intentEngine;
  final ContextEngine contextEngine;
  final ReasoningEngine reasoningEngine;
  final PlanningService planningService;
  final AiRouter aiRouter;
  final KnightContextService contextService;
  final WorldService worldService;
  final CausalReasoningEngine? causalEngine;

  /// Processes a user request through the full cognitive pipeline.
  Future<CognitiveResult> processRequest(
    String text, {
    List<String> history = const [],
  }) async {
    // 1. Intent Detection
    final intent = intentEngine.detectIntent(text);

    // 2. Model Selection (Multi-Model Sprint 2.1)
    final aiProvider = aiRouter.selectProvider(intent);

    // 3. Memory Context Assembly
    final memories = await contextEngine.buildActiveContext(
      query: text,
      intent: intent,
      worldState: worldService.currentState,
    );

    // 3. Build User Context
    final context = contextService.buildContext(
      featureModules: [], // Future: Pass registered modules
      recentMemories: memories,
      worldState: worldService.currentState,
    );

    // 4. Reasoning
    final reasoningResult = reasoningEngine.reason(
      context: context,
      memories: memories,
    );
    
    ReasoningTrace trace = reasoningResult.trace;

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
      if (memories.isNotEmpty) {
        final links = await causalEngine!.findWhy(memories.first.id);
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
    final augmentedPrompt = _buildAugmentedPrompt(text, trace, history);
    final response = await aiProvider.chat(
      context: memories,
      prompt: augmentedPrompt,
    );

    return CognitiveResult(response: response, trace: trace, plan: plan);
  }

  String _buildAugmentedPrompt(String text, ReasoningTrace trace, List<String> history) {
    final buffer = StringBuffer();
    if (history.isNotEmpty) {
      buffer.writeln('Conversation History:');
      for (var msg in history) {
        buffer.writeln('- $msg');
      }
      buffer.writeln('---');
    }

    if (trace.potentialRisks.isEmpty) {
      buffer.write(text);
    } else {
      buffer.writeln('User Request: $text');
      buffer.writeln('Detected Risks: ${trace.potentialRisks.join(', ')}');
      buffer.write('Instruction: Evaluate if this request harms long-term goals. If so, challenge respectfully and offer alternatives as per the Knight Constitution.');
    }

    return buffer.toString();
  }
}

class CognitiveResult {
  const CognitiveResult({required this.response, required this.trace, this.plan});
  final String response;
  final ReasoningTrace trace;
  final KnightPlan? plan;
}
