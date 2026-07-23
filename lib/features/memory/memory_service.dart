import 'memory_models.dart';

class MemoryService {
  const MemoryService();

  MemoryItem createMemory({
    required String userId,
    required String title,
    required String body,
    required String source,
    required String category,
    String permission = 'conversation_only',
  }) {
    return MemoryItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
      title: title,
      body: body,
      createdAt: DateTime.now(),
      source: source,
      category: category,
      permission: permission,
      tags: <String>[category, source],
    );
  }
}
