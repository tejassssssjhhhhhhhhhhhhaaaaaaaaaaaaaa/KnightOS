import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../intelligence/engines/memory_engine.dart';
import '../../intelligence/providers/intelligence_providers.dart';
import '../domain/knight_connector.dart';
import 'connector_pipeline.dart';
import 'connector_registry.dart';

/// Orchestrates the data ingestion lifecycle.
class ConnectorOrchestrator {
  ConnectorOrchestrator({required this.memoryEngine})
    : _pipeline = ConnectorPipeline(memoryEngine: memoryEngine);

  final MemoryEngine memoryEngine;
  final ConnectorPipeline _pipeline;

  /// Main ingestion path for any file.
  Future<ConnectorResult> ingest(File file, String connectorId) async {
    final connector = ConnectorRegistry.get(connectorId);
    if (connector == null) {
      return const ConnectorResult(
        success: false,
        error: 'Connector not found.',
      );
    }

    return _pipeline.execute(file, connector);
  }

  /// Triggers a sync across all healthy connectors.
  Future<void> syncAll() async {
    for (final _ in ConnectorRegistry.connectors) {
      // Future: execute sync logic
    }
  }
}

/// Provider for the Connector Orchestrator.
final connectorOrchestratorProvider = Provider<ConnectorOrchestrator>((ref) {
  return ConnectorOrchestrator(memoryEngine: ref.watch(memoryEngineProvider));
});
