import 'dart:async';
import '../domain/connectors/i_connector.dart';
import '../domain/connectors/connector_manifest.dart';
import '../domain/connectors/connector_health.dart';
import '../storage/privacy_vault.dart';
import '../intelligence/normalization_pipeline.dart';
import '../internal/utils/knight_logger.dart';

/// Reference implementation for local file ingestion (PDF, Resume, CSV).
class ManualConnector implements IConnector {
  ManualConnector({required this.pipeline});

  final NormalizationPipeline pipeline;
  final StreamController<ConnectorStatus> _statusController = StreamController<ConnectorStatus>.broadcast();
  ConnectorStatus _status = ConnectorStatus.registered;

  @override
  ConnectorManifest get manifest => const ConnectorManifest(
        id: 'knight.manual_import',
        name: 'Manual File Import',
        version: '1.0.0',
        vendor: 'KnightOS',
        supportedPlatforms: ['android', 'ios', 'web'],
        authMethod: AuthMethod.none,
        supportedCapabilities: ['documents', 'resumes', 'certificates'],
        syncModes: [SyncMode.manual],
        privacyClassification: PrivacyClassification.personal,
      );

  @override
  ConnectorStatus get status => _status;

  @override
  Stream<ConnectorStatus> get onStatusChanged => _statusController.stream;

  @override
  Future<ConnectorHealth> getHealth() async {
    return ConnectorHealth(
      apiStatus: 'operational',
      version: manifest.version,
    );
  }

  @override
  Future<ConnectorResult<void>> authorize() async {
    _updateStatus(ConnectorStatus.authorized);
    return const ConnectorResult(status: ConnectorStatus.authorized);
  }

  @override
  Future<ConnectorResult<void>> connect() async {
    _updateStatus(ConnectorStatus.connected);
    return const ConnectorResult(status: ConnectorStatus.connected);
  }

  @override
  Future<ConnectorResult<int>> sync({bool fullSync = false}) async {
    // Manual connector doesn't 'sync' with an API, but we simulate processing a file.
    return const ConnectorResult(status: ConnectorStatus.completed, data: 0);
  }

  /// Entry point for importing a specific local file.
  Future<void> importFile({
    required String type,
    required String path,
    required String caid,
    required String name,
    Map<String, dynamic> metadata = const {},
  }) async {
    _updateStatus(ConnectorStatus.syncing);
    
    try {
      await pipeline.process(
        connectorId: manifest.id,
        type: type,
        caid: caid,
        rawData: {
          'source_name': name,
          'path': path,
          ...metadata,
        },
      );
      _updateStatus(ConnectorStatus.completed);
    } catch (e) {
      KnightLogger.error('[MANUAL] Import failed for $name', error: e);
      _updateStatus(ConnectorStatus.failed);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    _updateStatus(ConnectorStatus.disabled);
  }

  @override
  Future<void> revoke() async {
    _updateStatus(ConnectorStatus.revoked);
  }

  void _updateStatus(ConnectorStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
    KnightLogger.info('[MANUAL] Status: $_status');
  }
}
