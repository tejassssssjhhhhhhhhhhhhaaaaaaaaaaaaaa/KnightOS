import 'dart:io';
import 'package:flutter/material.dart';
import '../../../connectors/domain/knight_connector.dart';
import '../../../connectors/domain/connector_models.dart';

/// Links travel expenses from the KnightOS Finance module.
class FinanceTravelConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'finance_travel',
    name: 'Finance Link',
    version: '1.0.0',
    icon: Icons.payments_outlined,
    accentColor: Colors.teal,
    capabilities: {ConnectorCapability.sync},
    supportedFormats: [],
  );

  @override
  Future<ConnectorResult> sync({required String jobId}) async {
    // 1. Query Finance module for transactions categorized as 'Travel'
    // 2. Cross-reference with existing trips in Knowledge Graph
    return const ConnectorResult(success: true);
  }

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    return const ConnectorResult(success: false);
  }

  @override
  Future<bool> validate(File file) async => false;
}
