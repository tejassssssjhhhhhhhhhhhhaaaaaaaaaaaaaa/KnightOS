import '../domain/knight_memory.dart';
import 'import_framework.dart';

/// Importer for the Knight Knowledge Base (YAML/Markdown).
class KnowledgeBaseImporter extends MemoryImporter {
  @override
  String get sourceName => 'knight-knowledge-base';

  @override
  Future<List<KnightMemory>> fetchAndConvert() async {
    // Strategy: Read local assets or files.
    // Convert YAML/MD nodes into memories.
    return [];
  }

  /// Specialized method for incremental updates.
  Future<void> importNode(String id, Map<String, dynamic> data) async {
    // Logic to upsert a specific knowledge node.
  }
}
