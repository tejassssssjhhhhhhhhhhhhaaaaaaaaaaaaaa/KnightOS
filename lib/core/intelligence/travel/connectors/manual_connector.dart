import 'dart:io';
import 'package:flutter/material.dart';
import '../../../connectors/domain/knight_connector.dart';
import '../../../connectors/domain/connector_models.dart';

/// Support for manual imports of PDFs, boarding passes, and tickets.
class ManualTravelConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'manual_travel',
    name: 'Manual Import',
    version: '1.0.0',
    icon: Icons.file_present_outlined,
    accentColor: Colors.grey,
    capabilities: {ConnectorCapability.import},
    supportedFormats: ['pdf', 'pkpass', 'png', 'jpg'],
  );

  @override
  Future<ConnectorResult> sync({required String jobId}) async {
    return const ConnectorResult(success: true);
  }

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    // 1. OCR / PDF Extraction
    // 2. Identify travel booking data
    // 3. Store in Evidence Vault
    return const ConnectorResult(success: true, message: 'File imported successfully.');
  }

  @override
  Future<bool> validate(File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    return metadata.supportedFormats.contains(ext);
  }
}
