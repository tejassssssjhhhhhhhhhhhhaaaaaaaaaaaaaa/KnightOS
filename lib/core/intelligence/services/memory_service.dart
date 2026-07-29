import '../engines/memory_engine.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';

/// Comprehensive memory management service for KnightOS.
/// Provides high-level APIs for CRUD operations and search, backed by the Memory Engine.
class MemoryService {
  const MemoryService({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Persists a new memory unit.
  Future<void> saveMemory(KnightMemory memory) => memoryEngine.save(memory);

  /// Saves a textual note as a manual memory.
  Future<void> saveQuickNote(String title, String body) async {
    final memory = KnightMemory.create(
      memoryId: 'note-${DateTime.now().millisecondsSinceEpoch}',
      category: BookCategory.history,
      domain: MemoryDomain.memories,
      content: {'title': title, 'body': body},
      summary: title,
      source: MemorySource.manual,
      importance: 0.5,
    );
    await memoryEngine.save(memory);
  }

  /// Persists multiple memory units in a single transaction.
  Future<void> saveAllMemories(List<KnightMemory> memories) =>
      memoryEngine.saveAll(memories);

  /// Retrieves the latest version of a specific memory fact.
  Future<KnightMemory?> retrieveMemory(String memoryId) =>
      memoryEngine.getLatest(memoryId);

  /// Retrieves all memories belonging to a specific Knowledge Book.
  Future<List<KnightMemory>> retrieveByCategory(BookCategory category) =>
      memoryEngine.getByCategory(category);

  /// Updates an existing memory. This typically creates a new version in the fact chain.
  Future<void> updateMemory(KnightMemory memory) => memoryEngine.save(memory);

  /// Deletes an entire memory fact chain.
  Future<void> deleteMemory(String memoryId) => memoryEngine.delete(memoryId);

  /// Performs a keyword-based search across all memories.
  /// Designed to be augmented with vector search in future iterations.
  Future<List<KnightMemory>> searchMemories(
    String query, {
    bool semantic = false,
  }) async {
    // Current implementation only supports keyword search.
    // Future: If semantic is true, use embedding service and vector search.
    return memoryEngine.search(query);
  }

  /// Establishes a semantic link between two memories.
  Future<void> linkMemories(
    String sourceId,
    String targetId,
    String relationType, {
    double strength = 1.0,
  }) => memoryEngine.link(sourceId, targetId, relationType, strength: strength);
}
