import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/engines/memory_engine.dart';
import '../domain/knight_conversation.dart';
import '../domain/knight_repository.dart';

class MemoryKnightRepository implements KnightRepository {
  const MemoryKnightRepository({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  @override
  Future<List<KnightConversation>> getConversations() async {
    final memories = await memoryEngine.getByCategory(BookCategory.history);
    // Filter for conversations if needed, or assume all in this domain are conversations for this repo
    return memories.map((m) => KnightConversation.fromJson(m.content)).toList();
  }

  @override
  Future<void> saveConversation(KnightConversation conversation) async {
    final memory = KnightMemory.create(
      memoryId: 'conversation-${conversation.id}',
      category: BookCategory.history,
      domain: MemoryDomain.memories,
      content: conversation.toJson(),
      summary: 'Conversation: ${conversation.title}',
      source: MemorySource.manual,
      importance: 0.5,
      effectiveAt: conversation.lastUpdatedAt,
    );
    await memoryEngine.save(memory);
  }

  @override
  Future<void> deleteConversation(String id) async {}

  @override
  Future<void> clearAll() async {}
}
