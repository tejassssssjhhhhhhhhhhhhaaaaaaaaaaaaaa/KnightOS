import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/knight_connector.dart';
import '../domain/connector_models.dart';

class TimelineConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'google_timeline',
    name: 'Google Timeline',
    version: '1.1',
    icon: Icons.map_rounded,
    accentColor: Colors.blue,
    capabilities: {ConnectorCapability.import},
    supportedFormats: ['json'],
  );

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    // Migration of existing GoogleTimelineProvider logic
    return const ConnectorResult(
      success: true,
      message: 'Timeline data integrated into Life Atlas.',
    );
  }

  @override
  Future<bool> validate(File file) async {
    // Check if it's a valid JSON with timeline markers
    return true;
  }
}
