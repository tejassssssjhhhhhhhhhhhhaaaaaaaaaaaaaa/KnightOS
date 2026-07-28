import 'dart:io';
import '../../services/hashing_service.dart';
import '../../intelligence/engines/memory_engine.dart';
import '../../intelligence/domain/knight_memory.dart';
import '../domain/knight_connector.dart';
import '../domain/connector_models.dart';

/// Implementation of the multi-stage ingestion pipeline.
class ConnectorPipeline {
  const ConnectorPipeline({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Ingests a file through a specific connector.
  Future<ConnectorResult> execute(File file, KnightConnector connector) async {
    final jobId =
        '${connector.metadata.id}-${DateTime.now().millisecondsSinceEpoch}';

    // 1. DEDUPLICATION (File Level)
    final fileHash = await HashingService.calculateFileHash(file);
    final isDuplicate = await HashingService.isDuplicate(fileHash);

    if (isDuplicate) {
      return ConnectorResult(
        success: false,
        error: 'Duplicate file detected (SHA: ${fileHash.substring(0, 8)})',
      );
    }

    // 2. VALIDATION
    final isValid = await connector.validate(file);
    if (!isValid) {
      return const ConnectorResult(
        success: false,
        error: 'Validation failed: File format incorrect.',
      );
    }

    // 3. PARSING & NORMALIZATION
    final result = await connector.import(file, jobId: jobId);
    if (!result.success) return result;

    // 4. MAP TO MEMORIES & PROVENANCE
    final List<KnightMemory> memories = [];
    for (final record in result.records) {
      // In a real implementation, each connector record should provide its own unique ID
      final recordId = 'rec-${DateTime.now().nanosecondsSinceEpoch}';

      final provenance = ImportProvenance(
        connectorId: connector.metadata.id,
        sourceFileName: file.path.split(Platform.pathSeparator).last,
        fileHash: fileHash,
        importedAt: DateTime.now(),
        originalRecordId: recordId,
      );

      if (record is KnightMemory) {
        memories.add(
          record.copyWith(
            metadata: record.metadata.copyWith(
              provenance: provenance.sourceFileName,
              semanticMetadata: {
                ...record.metadata.semanticMetadata,
                'connector': provenance.connectorId,
                'fileHash': provenance.fileHash,
              },
            ),
          ),
        );
      }
    }

    // 5. COMMIT
    if (memories.isNotEmpty) {
      await memoryEngine.saveAll(memories);
    }

    return result;
  }
}

extension on DateTime {
  int get nanosecondsSinceEpoch => microsecondsSinceEpoch * 1000;
}
