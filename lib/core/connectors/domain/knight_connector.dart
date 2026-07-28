import 'dart:io';
import 'connector_models.dart';

/// Contract for all data ecosystem plugins in KnightOS.
abstract class KnightConnector {
  /// Static metadata identifying the connector.
  ConnectorMetadata get metadata;

  /// Returns true if this connector can process the provided file.
  bool canHandle(File file) {
    if (metadata.supportedFormats.isEmpty) return false;
    final ext = file.path.split('.').last.toLowerCase();
    return metadata.supportedFormats.contains(ext);
  }

  /// One-time import of a data file.
  Future<ConnectorResult> import(File file, {required String jobId});

  /// Performs an incremental synchronization (for future cloud/API connectors).
  Future<ConnectorResult> sync({required String jobId}) async {
    return const ConnectorResult(success: true, records: []);
  }

  /// Validates the structure of a file before ingestion.
  Future<bool> validate(File file);
}

class ConnectorResult {
  const ConnectorResult({
    required this.success,
    this.message,
    this.records = const [],
    this.error,
  });

  final bool success;
  final String? message;
  final List<dynamic> records;
  final String? error;
}
