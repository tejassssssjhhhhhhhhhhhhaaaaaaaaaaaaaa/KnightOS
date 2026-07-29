import '../../../../features/knight/domain/knight_message.dart';
import '../../../../features/knight/domain/knight_conversation.dart';
import '../knight_cognition.dart';
import '../engines/memory_engine.dart';
import '../knight_context_service.dart';
import 'planning_service.dart';
import '../../platform/engine/engine_interfaces.dart';

/// Core AI Copilot Service that provides a unified conversational interface.
class CopilotService {
  CopilotService({
    required this.cognition,
    required this.memoryEngine,
    required this.contextService,
    required this.planningService,
  });

  final KnightCognition cognition;
  final MemoryEngine memoryEngine;
  final KnightContextService contextService;
  final PlanningService planningService;

  /// Processes a user message and returns a conversational response with metadata.
  Future<KnightMessage> interact({
    required String text,
    required KnightConversation conversation,
    required List<KnightFeatureModule> featureModules,
  }) async {
    // 1. Process via cognition pipeline
    final result = await cognition.processRequest(text);

    // 2. Extract suggested actions from planning/reasoning
    final List<Map<String, dynamic>> actions = [];
    if (result.plan != null) {
      actions.add({
        'type': 'suggest_plan',
        'title': result.plan!.title,
        'task_count': result.plan!.tasks.length,
      });
    }

    // 3. Construct response message
    return KnightMessage(
      role: KnightMessageRole.assistant,
      content: result.response,
      metadata: {
        'confidence': result.trace.confidence,
        'actions': actions,
        'thoughtChain': result.trace.thoughtChain,
      },
    );
  }

  /// Streams a response for lower latency feeling.
  Stream<String> streamInteract({
    required String text,
    required List<KnightFeatureModule> featureModules,
  }) async* {
    // Basic streaming wrapper
    final memories = await memoryEngine.search('');
    yield* cognition.aiProvider.streamChat(context: memories, prompt: text);
  }
}
