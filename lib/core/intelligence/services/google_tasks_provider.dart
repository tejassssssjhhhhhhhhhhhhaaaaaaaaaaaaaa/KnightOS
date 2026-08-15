import 'dart:async';
import '../domain/data_provider.dart';
import 'tasks_sync_orchestrator.dart';
import '../../services/google_auth_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import 'base_data_provider.dart';

class GoogleTasksProvider extends BaseDataProvider {
  GoogleTasksProvider({
    required this.authService,
    required super.db,
    super.onChanged,
  });

  final GoogleAuthService authService;

  @override
  String get id => 'google_tasks_api';

  @override
  String get name => 'Google Tasks';

  @override
  Future<void> connect() async {
    updateInternalState(status: ProviderStatus.syncing, error: '');
    try {
      if (authService.currentUser == null) {
        await authService.signIn();
      }

      final requiredScopes = [
        'https://www.googleapis.com/auth/tasks.readonly',
      ];

      final success = await authService.requestScopes(requiredScopes);
      if (success && await authService.hasScopes(requiredScopes)) {
        updateInternalState(status: ProviderStatus.connected, error: '');
        KnightLogger.info('Tasks connected');
      } else {
        updateInternalState(status: ProviderStatus.error, error: 'Permissions not granted');
      }
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
    }
  }

  @override
  Future<void> disconnect() async {
    updateInternalState(status: ProviderStatus.disconnected, error: '');
  }

  @override
  Future<void> syncIncremental() async {
    if (status != ProviderStatus.connected) return;

    updateInternalState(status: ProviderStatus.syncing, attempted: DateTime.now());
    try {
      final orchestrator = TasksSyncOrchestrator(db: db, authService: authService);
      await orchestrator.runSync();

      updateInternalState(
        status: ProviderStatus.connected, 
        successful: DateTime.now(), 
        error: '', 
        stats: orchestrator.stats
      );
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
      KnightLogger.error('Tasks sync failed', error: e);
    }
  }
}
