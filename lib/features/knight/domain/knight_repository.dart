import 'knight_conversation.dart';

/// Interface for managing Knight conversations and memory.
abstract class KnightRepository {
  /// Retrieves all saved conversations.
  Future<List<KnightConversation>> getConversations();

  /// Saves or updates a conversation.
  Future<void> saveConversation(KnightConversation conversation);

  /// Deletes a specific conversation by ID.
  Future<void> deleteConversation(String id);

  /// Clears all conversation history.
  Future<void> clearAll();
}
