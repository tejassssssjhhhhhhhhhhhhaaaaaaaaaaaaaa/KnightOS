import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../platform/storage/storage_engine.dart';
import '../storage/drift/drift_storage_engine.dart';
import '../storage/drift/knight_database.dart';
import '../../storage/local_database.dart';
import '../../storage/storage_keys.dart';
import '../../intelligence/services/memory_migration_service.dart';
import '../../intelligence/engines/memory_engine.dart';
import '../../../../features/onboarding/domain/onboarding_profile.dart';
import '../utils/knight_logger.dart';
import 'storage_failure.dart';

/// Internal manager for the Storage Engine lifecycle and data migrations.
class StorageService {
  StorageService({required this.engine, this.memoryEngine});

  final StorageEngine engine;
  final MemoryEngine? memoryEngine;
  bool _isInitialized = false;

  /// Feature flag for Drift migration.
  static const String kEnableDriftMigration = 'enable_drift_migration';

  /// Initializes the storage system.
  Future<void> initialize() async {
    if (_isInitialized) return;

    final stopwatch = Stopwatch()..start();
    try {
      KnightLogger.info(
        'Initializing engine...',
        category: KnightLogCategory.startup,
      );
      await engine.initialize();
      KnightLogger.info(
        'Engine initialized (${stopwatch.elapsedMilliseconds}ms).',
        category: KnightLogCategory.startup,
      );
      _isInitialized = true;

      final prefs = await SharedPreferences.getInstance();
      final migrationEnabled = prefs.getBool(kEnableDriftMigration) ?? true;

      if (migrationEnabled) {
        await _checkAndPerformMigration();
      }
      KnightLogger.info(
        'Total initialization complete (${stopwatch.elapsedMilliseconds}ms).',
        category: KnightLogCategory.startup,
      );
    } catch (e, stack) {
      KnightLogger.error(
        'Initialization failed after ${stopwatch.elapsedMilliseconds}ms: $e',
        error: e,
        stackTrace: stack,
        category: KnightLogCategory.startup,
      );
      throw DatabaseInitializationFailure('Failed to start StorageService: $e');
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> _checkAndPerformMigration() async {
    final stopwatch = Stopwatch()..start();
    KnightLogger.info(
      'Checking for pending data migrations...',
      category: KnightLogCategory.database,
    );
    if (engine is! DriftStorageEngine) {
      KnightLogger.warn(
        'Engine is not Drift, skipping migrations.',
        category: KnightLogCategory.database,
      );
      return;
    }

    final driftEngine = engine as DriftStorageEngine;

    try {
      // 1. Profile Migration
      KnightLogger.info(
        'Checking profile migration...',
        category: KnightLogCategory.database,
      );
      final profileReport = await driftEngine.migrationDao.getByModule(
        'profile',
      );
      if (profileReport == null || profileReport.status != 'success') {
        await _migrateProfile(driftEngine);
      } else {
        KnightLogger.info(
          'Profile migration already completed.',
          category: KnightLogCategory.database,
        );
      }

      // 2. Unified Memory Migration
      KnightLogger.info(
        'Checking memory migration...',
        category: KnightLogCategory.database,
      );
      final memoryReport = await driftEngine.migrationDao.getByModule(
        'memory_v2',
      );
      if (memoryReport == null || memoryReport.status != 'success') {
        if (memoryEngine != null) {
          KnightLogger.info(
            'Running memory migration (Optimized Batch)...',
            category: KnightLogCategory.database,
          );
          final migrationService = MemoryMigrationService(
            memoryEngine: memoryEngine!,
          );

          final migrationStopwatch = Stopwatch()..start();
          await migrationService.runMigration();
          migrationStopwatch.stop();

          await _recordMigration(driftEngine, 'memory_v2', 1, 0, 'success');
          KnightLogger.info(
            'Memory migration successful (${migrationStopwatch.elapsedMilliseconds}ms).',
            category: KnightLogCategory.database,
          );
        } else {
          KnightLogger.warn(
            'MemoryEngine is null, cannot migrate.',
            category: KnightLogCategory.database,
          );
        }
      } else {
        KnightLogger.info(
          'Memory migration already completed.',
          category: KnightLogCategory.database,
        );
      }
    } finally {
      stopwatch.stop();
      KnightLogger.info(
        'Migration check complete (${stopwatch.elapsedMilliseconds}ms).',
        category: KnightLogCategory.database,
      );
    }
  }

  Future<void> _migrateProfile(DriftStorageEngine driftEngine) async {
    KnightLogger.info(
      'Migrating Profile from legacy JSON...',
      category: KnightLogCategory.database,
    );
    try {
      const legacyDb = LocalDatabase();
      final json = await legacyDb.readJson(StorageKeys.onboardingProfile);

      if (json == null) {
        KnightLogger.info(
          'No legacy profile found. Skipping.',
          category: KnightLogCategory.database,
        );
        await _recordMigration(driftEngine, 'profile', 0, 0, 'success');
        return;
      }

      final profile = UserProfile.fromJson(json).copyWith(id: 'main_profile');
      await driftEngine.upsert(profile);

      await _recordMigration(driftEngine, 'profile', 1, 0, 'success');
      KnightLogger.info(
        'Profile migration successful.',
        category: KnightLogCategory.database,
      );
    } catch (e) {
      KnightLogger.error(
        'Profile migration failed: $e',
        error: e,
        category: KnightLogCategory.database,
      );
      await _recordMigration(
        driftEngine,
        'profile',
        0,
        1,
        'failed',
        error: e.toString(),
      );
    }
  }

  Future<void> _recordMigration(
    DriftStorageEngine driftEngine,
    String module,
    int success,
    int failed,
    String status, {
    String? error,
  }) async {
    await driftEngine.migrationDao.upsert(
      driftEngine.migrationDao.attachedDatabase.migrationLedger,
      MigrationLedgerCompanion.insert(
        id: module,
        module: module,
        migratedRecords: success,
        failedRecords: failed,
        status: status,
      ),
    );
  }

  Future<void> dispose() async {
    await engine.dispose();
    _isInitialized = false;
  }
}
