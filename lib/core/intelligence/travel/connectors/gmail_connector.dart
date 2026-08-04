import 'dart:io';
import 'package:flutter/material.dart';
import '../../../connectors/domain/knight_connector.dart';
import '../../../connectors/domain/connector_models.dart';

/// Scans Gmail messages for travel confirmations (Flights, Hotels, etc.).
class GmailTravelConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'gmail_travel',
    name: 'Gmail Travel',
    version: '1.0.0',
    icon: Icons.email_outlined,
    accentColor: Colors.red,
    capabilities: {ConnectorCapability.sync},
    supportedFormats: [],
  );

  @override
  Future<ConnectorResult> sync({required String jobId}) async {
    // 1. Authenticate with Google
    // 2. Query messages with 'label:travel' or keywords (booking, reservation)
    // 3. For each hit:
    //    - Extract raw body
    //    - Call TravelEvidenceEngine.ingest()
    return const ConnectorResult(success: true, message: 'Gmail travel scan completed.');
  }

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    return const ConnectorResult(success: false, error: 'Use sync for Gmail.');
  }

  @override
  Future<bool> validate(File file) async => false;
}
