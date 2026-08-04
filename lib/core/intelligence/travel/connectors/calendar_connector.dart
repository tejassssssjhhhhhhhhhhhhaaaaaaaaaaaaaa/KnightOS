import 'dart:io';
import 'package:flutter/material.dart';
import '../../../connectors/domain/knight_connector.dart';
import '../../../connectors/domain/connector_models.dart';

/// Imports travel-related calendar events.
class CalendarTravelConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'calendar_travel',
    name: 'Google Calendar',
    version: '1.0.0',
    icon: Icons.calendar_today_outlined,
    accentColor: Colors.amber,
    capabilities: {ConnectorCapability.sync},
    supportedFormats: [],
  );

  @override
  Future<ConnectorResult> sync({required String jobId}) async {
    // 1. Search for keywords in events (Flight to, Trip to, Hotel stay)
    // 2. Ingest events as potential travel evidence
    return const ConnectorResult(success: true);
  }

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    return const ConnectorResult(success: false);
  }

  @override
  Future<bool> validate(File file) async => false;
}
