import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/services/copilot_service.dart';
import 'package:knight_os/core/intelligence/knight_cognition.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';
import 'package:knight_os/core/intelligence/services/planning_service.dart';
import 'package:knight_os/features/knight/domain/knight_conversation.dart';
import 'package:knight_os/features/knight/domain/knight_message.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/intelligence/engines/ai_provider.dart';
import 'package:knight_os/core/intelligence/engines/intent_engine.dart';
import 'package:knight_os/core/intelligence/engines/context_engine.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';

class MockAiProvider extends Fake implements KnightAiProvider {
  @override
  Future<String> chat({required List<dynamic> context, required String prompt}) async => 'Response';
}

void main() {
  late CopilotService service;

  setUp(() {
    final ai = MockAiProvider();
    final mem = FakeMemoryEngine();
    final ctx = KnightContextService();
    final planEngine = FakePlanningEngine();
    final cog = KnightCognition(
      intentEngine: const IntentEngine(),
      contextEngine: ContextEngine(memoryEngine: mem),
      reasoningEngine: const ReasoningEngine(),
      aiProvider: ai,
      contextService: ctx,
      planningService: FakePlanningService(),
    );
    
    service = CopilotService(
      cognition: cog,
      memoryEngine: mem,
      contextService: ctx,
      planningService: FakePlanningService(),
    );
  });

  group('AI Copilot Service', () {
    test('interact returns a structured message with metadata', () async {
      final conversation = KnightConversation.empty;
      final message = await service.interact(
        text: 'Hello',
        conversation: conversation,
        featureModules: [],
      );

      expect(message.role, KnightMessageRole.assistant);
      expect(message.content, isNotEmpty);
      expect(message.metadata, contains('confidence'));
    });
  });
}

class FakeMemoryEngine extends Fake implements MemoryEngine {
  @override
  Future<List<dynamic>> getByCategory(dynamic cat) async => [];
  @override
  Future<List<dynamic>> search(String query) async => [];
}

class FakePlanningEngine extends Fake {}
class FakePlanningService extends Fake implements PlanningService {}
