import 'dart:async';
import '../domain/data_provider.dart';
import 'data_ingestion_service.dart';
import 'import_preference_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'base_data_provider.dart';

class LocalFileDataProvider extends BaseDataProvider {
  LocalFileDataProvider({
    required this.ingestionService,
    required this.prefsService,
    required super.db,
    super.onChanged,
  });

  final DataIngestionService ingestionService;
  final ImportPreferenceService prefsService;

  @override
  String get id => 'local_file_provider';

  @override
  String get name => 'Local Files & OneDrive';

  @override
  Future<void> connect() async {
    updateInternalState(status: ProviderStatus.connected, error: '');
  }

  @override
  Future<void> disconnect() async {
    updateInternalState(status: ProviderStatus.disconnected, error: '');
  }

  @override
  Future<void> syncIncremental() async {
    if (status != ProviderStatus.connected) {
      updateInternalState(error: 'Provider not connected');
      return;
    }

    updateInternalState(status: ProviderStatus.syncing, attempted: DateTime.now());
    try {
      await ingestionService.runFullIngestion();
      updateInternalState(status: ProviderStatus.connected, successful: DateTime.now(), error: '');
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
    }
  }
}
