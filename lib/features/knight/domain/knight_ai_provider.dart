import 'knight_message.dart';

/// Interface for AI providers (Gemini, OpenAI, Claude, Local, etc.)
abstract class KnightAiProvider {
  /// Generates a response based on the conversation history.
  Future<String> generateResponse(List<KnightMessage> history);

  /// Support for streaming responses (Future proofing).
  Stream<String> streamResponse(List<KnightMessage> history);

  /// Capability to summarize a conversation.
  Future<String> summarize(List<KnightMessage> history);
}
