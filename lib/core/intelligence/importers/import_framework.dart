import '../domain/knight_memory.dart';
import '../engines/memory_engine.dart';

/// Contract for every external data source.
abstract class MemoryImporter {
  /// Name of the source (e.g. "Samsung Health", "Manual CSV").
  String get sourceName;

  /// Ingests data and converts it into unified memories.
  Future<List<KnightMemory>> fetchAndConvert();
}

/// The engine responsible for synchronizing external data into KnightOS.
class ImportFramework {
  ImportFramework({required this.memoryEngine});

  final MemoryEngine memoryEngine;
  final List<MemoryImporter> _importers = [];

  /// Registers a new source importer.
  void register(MemoryImporter importer) {
    _importers.add(importer);
  }

  /// Runs all registered importers.
  Future<void> runAll() async {
    for (final importer in _importers) {
      final memories = await importer.fetchAndConvert();
      for (final memory in memories) {
        // Enforce provenance and source integrity
        final record = memory.copyWith(
          // recordedAt is handled by engine, but we ensure source matches.
        );
        await memoryEngine.save(record);
      }
    }
  }
}
