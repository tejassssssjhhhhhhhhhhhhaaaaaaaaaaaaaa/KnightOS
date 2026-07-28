import '../../intelligence/domain/knight_memory.dart';
import '../../intelligence/importers/import_framework.dart';

/// Importer for local file system metadata.
class LocalFileImporter extends MemoryImporter {
  @override
  String get sourceName => 'local-files';

  @override
  Future<List<KnightMemory>> fetchAndConvert() async {
    // Strategy: Crawl specific user directories (with permission).
    return [];
  }
}
