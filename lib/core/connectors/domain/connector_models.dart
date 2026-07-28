import 'package:flutter/material.dart';

enum ConnectorCapability { import, sync, validate, webhook }

enum ConnectorStatus { healthy, syncing, error, disconnected }

@immutable
class ConnectorMetadata {
  const ConnectorMetadata({
    required this.id,
    required this.name,
    required this.version,
    required this.icon,
    required this.accentColor,
    required this.capabilities,
    this.supportedFormats = const [],
  });

  final String id;
  final String name;
  final String version;
  final IconData icon;
  final Color accentColor;
  final Set<ConnectorCapability> capabilities;
  final List<String> supportedFormats;
}

@immutable
class ImportProvenance {
  const ImportProvenance({
    required this.connectorId,
    required this.sourceFileName,
    required this.fileHash,
    required this.importedAt,
    required this.originalRecordId,
  });

  final String connectorId;
  final String sourceFileName;
  final String fileHash;
  final DateTime importedAt;
  final String originalRecordId;

  Map<String, dynamic> toJson() => {
    'connectorId': connectorId,
    'sourceFileName': sourceFileName,
    'fileHash': fileHash,
    'importedAt': importedAt.toIso8601String(),
    'originalRecordId': originalRecordId,
  };

  factory ImportProvenance.fromJson(Map<String, dynamic> json) =>
      ImportProvenance(
        connectorId: json['connectorId'] as String,
        sourceFileName: json['sourceFileName'] as String,
        fileHash: json['fileHash'] as String,
        importedAt: DateTime.parse(json['importedAt'] as String),
        originalRecordId: json['originalRecordId'] as String,
      );
}
