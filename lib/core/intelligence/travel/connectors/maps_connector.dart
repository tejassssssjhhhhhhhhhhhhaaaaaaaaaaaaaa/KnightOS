import 'dart:io';
import 'package:flutter/material.dart';
import '../../../connectors/domain/knight_connector.dart';
import '../../../connectors/domain/connector_models.dart';

/// Imports location history, visited places, and travel modes from Google Maps.
class MapsTravelConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'maps_travel',
    name: 'Google Maps Timeline',
    version: '1.0.0',
    icon: Icons.map_outlined,
    accentColor: Colors.green,
    capabilities: {ConnectorCapability.sync, ConnectorCapability.import},
    supportedFormats: ['json', 'kml'],
  );

  @override
  Future<ConnectorResult> sync({required String jobId}) async {
    // 1. Fetch Location History (Semantic Segments)
    // 2. Map segments to visits and trips
    return const ConnectorResult(success: true);
  }

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    // Import KML or Takeout JSON
    return const ConnectorResult(success: true);
  }

  @override
  Future<bool> validate(File file) async => true;
}
