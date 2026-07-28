import 'import_models.dart';

/// Persistent record of an ingestion operation.
class ImportManifest {
  const ImportManifest({
    required this.jobId,
    required this.sourceId,
    required this.fileName,
    required this.fileHash,
    required this.importedAt,
    required this.recordCount,
    required this.durationMs,
    this.status = ImportStatus.completed,
    this.errorMessage,
    this.parserVersion = '1.0.0',
  });

  final String jobId;
  final String sourceId;
  final String fileName;
  final String fileHash;
  final DateTime importedAt;
  final int recordCount;
  final int durationMs;
  final ImportStatus status;
  final String? errorMessage;
  final String parserVersion;

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'sourceId': sourceId,
      'fileName': fileName,
      'fileHash': fileHash,
      'importedAt': importedAt.toIso8601String(),
      'recordCount': recordCount,
      'durationMs': durationMs,
      'status': status.name,
      'errorMessage': errorMessage,
      'parserVersion': parserVersion,
    };
  }
}
