import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../internal/storage/drift/drift_storage_engine.dart';
import '../internal/services/storage_service.dart';
import '../internal/services/profile_service.dart';
import '../platform/storage/storage_engine.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/user_repository.dart';
import '../intelligence/providers/intelligence_providers.dart';
import '../intelligence/services/import_preference_service.dart';
import 'database_provider.dart';
import 'preferences_provider.dart';

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

/// Provider for the Local Profile Service.
final profileServiceProvider = Provider<ProfileService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return ProfileService(db: db);
});

/// Initialization provider to ensure the database is ready.
final storageInitializerProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(storageServiceProvider);
  await service.initialize();
});

/// Provider for the Import Preference Service.
final importPreferenceServiceProvider = Provider<ImportPreferenceService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ImportPreferenceService(prefs);
});

/// Provider for the Authentication Repository.
final authenticationRepositoryProvider = Provider<AuthenticationRepository>((
  ref,
) {
  return AuthenticationRepository();
});

/// Reactive provider for the current auth session.
final authSessionProvider = FutureProvider<AuthSession?>((ref) async {
  final repo = ref.watch(authenticationRepositoryProvider);
  final session = await repo.getCurrentSession();
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
