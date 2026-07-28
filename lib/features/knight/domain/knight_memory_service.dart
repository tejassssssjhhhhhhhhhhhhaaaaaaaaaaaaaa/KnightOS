import 'knight_message.dart';

/// Interface for long-term memory and context retrieval.
abstract class KnightMemoryService {
  /// Stores a message in long-term memory (e.g., Vector DB).
  Future<void> store(KnightMessage message);

  /// Retrieves relevant context for a given query.
  Future<List<KnightMessage>> retrieveContext(String query, {int limit = 5});

  /// Clears or compacts memory.
  Future<void> clearMemory();
}
