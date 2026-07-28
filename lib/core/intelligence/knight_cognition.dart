import 'engines/intent_engine.dart';
import 'engines/context_engine.dart';
import 'engines/reasoning_engine.dart';
import 'engines/graph/causal_reasoning_engine.dart';
import 'engines/ai_provider.dart';
import 'domain/cognitive_models.dart';

/// The central coordinator for the Knight Cognitive Layer.
class KnightCognition {
  KnightCognition({
    required this.intentEngine,
    required this.contextEngine,
    required this.reasoningEngine,
    required this.aiProvider,
    this.causalEngine,
  });

  final IntentEngine intentEngine;
  final ContextEngine contextEngine;
  final ReasoningEngine reasoningEngine;
  final KnightAiProvider aiProvider;
  final CausalReasoningEngine? causalEngine;

  /// Processes a user request through the full cognitive pipeline.
  Future<CognitiveResult> processRequest(String text) async {
    // 1. Intent Detection
    final intent = intentEngine.detectIntent(text);

    // 2. Context Assembly
    final context = await contextEngine.buildActiveContext(
      query: text,
      intent: intent,
    );

    // 3. Reasoning
    ReasoningTrace trace = reasoningEngine.reason(
      intent: intent,
      context: context,
    );

    // 4. Causal Analysis (Phase 13)
    if (intent == KnightIntent.analysis && causalEngine != null) {
      // Attempt to find causal links for the primary context item
      if (context.isNotEmpty) {
        final links = await causalEngine!.findWhy(context.first.id);
        if (links.isNotEmpty) {
          trace = trace.copyWith(
            graphPath: links
                .map((l) => l.source.summary ?? l.source.id)
                .toList(),
          );
        }
      }
    }

    // 5. AI Generation
    // We pass the reasoning trace findings into the prompt.
    final augmentedPrompt = _buildAugmentedPrompt(text, trace);
    final response = await aiProvider.chat(
      context: context,
      prompt: augmentedPrompt,
    );

    return CognitiveResult(response: response, trace: trace);
  }

  String _buildAugmentedPrompt(String text, ReasoningTrace trace) {
    if (trace.potentialRisks.isEmpty) return text;

    // Inject Challenge Mode instructions if risks detected.
    return """
User Request: $text
Detected Risks: ${trace.potentialRisks.join(', ')}
Instruction: Evaluate if this request harms long-term goals. If so, challenge respectfully and offer alternatives as per the Knight Constitution.
""";
  }
}

class CognitiveResult {
  const CognitiveResult({required this.response, required this.trace});
  final String response;
  final ReasoningTrace trace;
}
