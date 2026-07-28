import '../domain/knight_memory.dart';

/// Interface for interchangable AI backends (Gemini, OpenAI, Local LLM).
abstract class KnightAiProvider {
  /// Unique identifier for the provider.
  String get id;

  /// Generates a response based on the provided context and history.
  Future<String> chat({
    required List<KnightMemory> context,
    required String prompt,
  });

  /// Specialized method for summarizing a life chapter or period.
  Future<String> summarize(List<KnightMemory> memories);

  /// Capability to analyze confidence levels for a specific claim.
  Future<double> checkConfidence(String claim, List<KnightMemory> facts);
}

/// A simple implementation for testing and bootstrapping.
class MockAiProvider implements KnightAiProvider {
  @override
  String get id => 'mock-knight-v1';

  @override
  Future<String> chat({
    required List<KnightMemory> context,
    required String prompt,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return "I am Knight, currently operating in foundation mode. I can see ${context.length} relevant memories in your context.";
  }

  @override
  Future<String> summarize(List<KnightMemory> memories) async {
    return "Summary of ${memories.length} life events: Progressive stability with key milestones in ${memories.map((m) => m.category.name).toSet().join(', ')}.";
  }

  @override
  Future<double> checkConfidence(String claim, List<KnightMemory> facts) async {
    return 1.0;
  }
}
