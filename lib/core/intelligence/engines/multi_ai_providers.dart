import 'package:google_generative_ai/google_generative_ai.dart';
import '../domain/knight_memory.dart';
import '../domain/cognitive_models.dart';
import 'ai_provider.dart';

class GeminiProvider extends MockAiProvider {
  @override
  String get id => 'gemini-1.5-pro';
  
  @override
  Future<String> chat({
    required List<KnightMemory> context, 
    List<Evidence> evidence = const [],
    required String prompt
  }) async {
    return "[GEMINI PRO] Reasoning through ${context.length} memories and ${evidence.length} evidence points for: $prompt";
  }
}

class OpenAiProvider extends MockAiProvider {
  @override
  String get id => 'gpt-4o';

  @override
  Future<String> chat({
    required List<KnightMemory> context, 
    List<Evidence> evidence = const [],
    required String prompt
  }) async {
    return "[GPT-4O] Synthesizing executive plan using ${evidence.length} data points: $prompt";
  }
}

class FlashModelProvider extends MockAiProvider {
  @override
  String get id => 'gemini-1.5-flash';

  @override
  Future<String> chat({
    required List<KnightMemory> context, 
    List<Evidence> evidence = const [],
    required String prompt
  }) async {
    return "[FLASH] Fast response using ${evidence.length} evidence points: $prompt";
  }
}
