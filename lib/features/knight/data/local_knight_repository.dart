import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/knight_conversation.dart';
import '../domain/knight_repository.dart';

/// Local persistence implementation of [KnightRepository] using [LocalDatabase].
class LocalKnightRepository implements KnightRepository {
  LocalKnightRepository({LocalDatabase? database})
    : _database = database ?? const LocalDatabase();

  final LocalDatabase _database;
  List<KnightConversation>? _cache;

  @override
  Future<List<KnightConversation>> getConversations() async {
    if (_cache != null) return _cache!;

    final data = await _database.readJsonList(StorageKeys.knightConversations);
    if (data == null) {
      _cache = [];
      return _cache!;
    }

    try {
      _cache = data
          .map((e) => KnightConversation.fromJson(e as Map<String, dynamic>))
          .toList();
      // Sort by last updated
      _cache!.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
      return _cache!;
    } catch (e) {
      _cache = [];
      return _cache!;
    }
  }

  @override
  Future<void> saveConversation(KnightConversation conversation) async {
    final conversations = await getConversations();
    final index = conversations.indexWhere((c) => c.id == conversation.id);

    final updatedList = List<KnightConversation>.from(conversations);
    if (index != -1) {
      updatedList[index] = conversation;
    } else {
      updatedList.add(conversation);
    }

    _cache = updatedList;
    await _saveToDisk(updatedList);
  }

  @override
  Future<void> deleteConversation(String id) async {
    final conversations = await getConversations();
    final updatedList = conversations.where((c) => c.id != id).toList();

    _cache = updatedList;
    await _saveToDisk(updatedList);
  }

  @override
  Future<void> clearAll() async {
    _cache = [];
    await _database.delete(StorageKeys.knightConversations);
  }

  Future<void> _saveToDisk(List<KnightConversation> conversations) async {
    await _database.writeJsonList(
      StorageKeys.knightConversations,
      conversations.map((c) => c.toJson()).toList(),
    );
  }
}
