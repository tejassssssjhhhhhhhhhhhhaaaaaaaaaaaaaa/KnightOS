import '../domain/knight_memory.dart';
import 'ai_provider.dart';

class GeminiProvider extends MockAiProvider {
  @override
  String get id => 'gemini-1.5-pro';
  
  @override
  Future<String> chat({required List<KnightMemory> context, required String prompt}) async {
    return "[GEMINI PRO] Reasoning through ${context.length} memories for: $prompt";
  }
}

class OpenAiProvider extends MockAiProvider {
  @override
  String get id => 'gpt-4o';

  @override
  Future<String> chat({required List<KnightMemory> context, required String prompt}) async {
    return "[GPT-4O] Synthesizing executive plan for: $prompt";
  }
}

class FlashModelProvider extends MockAiProvider {
  @override
  String get id => 'gemini-1.5-flash';

  @override
  Future<String> chat({required List<KnightMemory> context, required String prompt}) async {
    return "[FLASH] Fast response for: $prompt";
  }
}
