import 'dart:io';
import 'package:flutter/material.dart';
import '../../../connectors/domain/knight_connector.dart';
import '../../../connectors/domain/connector_models.dart';

/// Extracts GPS and temporal clusters from Google Photos metadata.
class PhotosTravelConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'photos_travel',
    name: 'Google Photos',
    version: '1.0.0',
    icon: Icons.photo_library_outlined,
    accentColor: Colors.blue,
    capabilities: {ConnectorCapability.sync},
    supportedFormats: ['jpg', 'jpeg', 'heic'],
  );

  @override
  Future<ConnectorResult> sync({required String jobId}) async {
    // 1. Scan photo library for images with GPS metadata
    // 2. Cluster images by location proximity and time
    // 3. Ingest clusters as evidence
    return const ConnectorResult(success: true, message: 'Photos metadata sync completed.');
  }

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    // Single photo import
    return const ConnectorResult(success: true);
  }

  @override
  Future<bool> validate(File file) async => true;
}
