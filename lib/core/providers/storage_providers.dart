import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../internal/storage/drift/drift_storage_engine.dart';
import '../internal/services/storage_service.dart';
import '../platform/storage/storage_engine.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/user_repository.dart';
import '../intelligence/providers/intelligence_providers.dart';
import '../internal/utils/knight_logger.dart';

/// Flagship Storage Engine provider.
final storageEngineProvider = Provider<StorageEngine>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final engine = DriftStorageEngine(database: db);
  return engine;
});

/// Internal Storage Service for lifecycle and migrations.
final storageServiceProvider = Provider<StorageService>((ref) {
  final engine = ref.watch(storageEngineProvider);
  final memoryEngine = ref.watch(memoryEngineProvider);
  return StorageService(engine: engine, memoryEngine: memoryEngine);
});

/// Initialization provider to ensure the database is ready before the app starts.
final storageInitializerProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(storageServiceProvider);
  await service.initialize();
});

/// Provider for the Authentication Repository.
final authenticationRepositoryProvider = Provider<AuthenticationRepository>((
  ref,
) {
  return AuthenticationRepository();
});

/// Reactive provider for the current auth session.
final authSessionProvider = FutureProvider<AuthSession?>((ref) async {
  KnightLogger.info('[AUTH] authSessionProvider starting...', category: KnightLogCategory.riverpod);
  final repo = ref.watch(authenticationRepositoryProvider);
  final session = await repo.getCurrentSession();
  KnightLogger.info('[AUTH] authSessionProvider complete: ${session != null}', category: KnightLogCategory.riverpod);
  return session;
});

/// Public UserRepository provider.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final engine = ref.watch(storageEngineProvider);
  final authRepository = ref.read(authenticationRepositoryProvider);
  return UserRepository(
    engine: engine,
    authenticationRepository: authRepository,
  );
});
