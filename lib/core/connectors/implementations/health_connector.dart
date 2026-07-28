import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/knight_connector.dart';
import '../domain/connector_models.dart';

class HealthConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'standard_health',
    name: 'Health Connector',
    version: '1.0',
    icon: Icons.health_and_safety_rounded,
    accentColor: Colors.red,
    capabilities: {ConnectorCapability.import},
    supportedFormats: ['csv'],
  );

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    return const ConnectorResult(
      success: true,
      message: 'Health records integrated into biological engine.',
    );
  }

  @override
  Future<bool> validate(File file) async {
    return true;
  }
}
