import 'package:drift/drift.dart';
import '../../services/storage_failure.dart';
import '../../../platform/storage/knight_entity.dart';
import '../../../platform/storage/storage_engine.dart';
import '../../../../features/onboarding/domain/onboarding_profile.dart';
import '../../utils/knight_logger.dart';
import 'knight_database.dart';

/// Internal Drift implementation of the platform Storage Engine.
class DriftStorageEngine implements StorageEngine {
  DriftStorageEngine({required KnightDatabase database}) : _db = database;

  final KnightDatabase _db;
  KnightDatabase get database => _db;

  /// Singleton instance for transition period (incremental migration).
  static late final DriftStorageEngine instance;
  static void setInstance(DriftStorageEngine engine) {
    instance = engine;
  }

  /// Internal access to the migration ledger for the StorageService.
  MigrationDao get migrationDao => _db.migrationDao;

  @override
  Future<void> initialize() async {
    try {
      KnightLogger.info(
        'Opening database connection...',
        category: KnightLogCategory.database,
      );
      // Basic connectivity check using the migration ledger
      // This call triggers the opening of the database and any pending migrations.
      await _db.migrationDao.getByModule('core');
      KnightLogger.info(
        'Database connection established.',
        category: KnightLogCategory.database,
      );
    } catch (e) {
      KnightLogger.error(
        'SQLite connection failed: $e',
        error: e,
        category: KnightLogCategory.database,
      );
      throw DatabaseInitializationFailure('SQLite connection failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    await _db.close();
  }

  @override
  Stream<T?> watch<T extends KnightEntity>(String id) {
    if (T == UserProfile) {
      return _db.userProfileDao
          .getById(id)
          .asStream()
          .map((data) => data != null ? _mapToEntity<T>(data) : null);
    }
    return const Stream.empty();
  }

  @override
  Stream<List<T>> watchAll<T extends KnightEntity>() {
    if (T == UserProfile) {
      return _db.userProfileDao
          .selectActive(_db.userProfileTable)
          .watch()
          .map((list) => list.map((data) => _mapToEntity<T>(data)).toList());
    }
    return const Stream.empty();
  }

  @override
  Future<void> upsert<T extends KnightEntity>(T entity) async {
    if (entity is UserProfile) {
      await _db.userProfileDao.saveProfile(
        _convertToUserProfileCompanion(entity),
      );
      return;
    }
    throw UnsupportedError(
      'Upsert for type ${entity.runtimeType} not implemented.',
    );
  }

  @override
  Future<void> batchUpsert<T extends KnightEntity>(List<T> entities) async {
    await _db.transaction(() async {
      for (final entity in entities) {
        await upsert(entity);
      }
    });
  }

  @override
  Future<T?> get<T extends KnightEntity>(String id) async {
    if (T == UserProfile) {
      final data = await _db.userProfileDao.getById(id);
      return data != null ? _mapToEntity<T>(data) : null;
    }
    return null;
  }

  @override
  Future<void> hardDelete<T extends KnightEntity>(String id) async {
    if (T == UserProfile) {
      await _db.userProfileDao.clearProfile();
    }
  }

  @override
  Future<void> clearAll<T extends KnightEntity>() async {
    if (T == UserProfile) {
      await _db.userProfileDao.clearProfile();
    }
  }

  @override
  Future<R> transaction<R>(Future<R> Function() action) async {
    return _db.transaction(action);
  }

  // --- Mapping Helpers ---

  T _mapToEntity<T extends KnightEntity>(dynamic data) {
    if (data is UserProfileTableData) {
      return UserProfile(
            id: data.id,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
            version: data.version,
            isDeleted: data.isDeleted,
            deletedAt: data.deletedAt,
            syncStatus: data.syncStatus,
            deviceId: data.deviceId,
            name: data.name,
            role: data.role,
            focusArea: data.focusArea,
            workStyle: data.workStyle,
            healthGoal: data.healthGoal,
            financeGoal: data.financeGoal,
            goalText: data.goalText,
            aiTone: data.aiTone,
            aiDepth: data.aiDepth,
            completedSteps: data.completedSteps,
            fullName: data.fullName,
            preferredName: data.preferredName,
            dateOfBirth: data.dateOfBirth,
            gender: data.gender,
            height: data.height,
            weight: data.weight,
            country: data.country,
            timeZone: data.timeZone,
            occupation: data.occupation,
            company: data.company,
            workType: data.workType,
            shiftType: data.shiftType,
            workHours: data.workHours,
            sleepGoal: data.sleepGoal,
            waterGoal: data.waterGoal,
            exerciseFrequency: data.exerciseFrequency,
            fitnessLevel: data.fitnessLevel,
            healthGoals: data.healthGoals,
            currency: data.currency,
            monthlyIncome: data.monthlyIncome,
            monthlyBudget: data.monthlyBudget,
            savingsGoal: data.savingsGoal,
            financialPriorities: data.financialPriorities,
            lifeGoals: data.lifeGoals,
            learningGoals: data.learningGoals,
            focusAreas: data.focusAreas,
            reminderPreference: data.reminderPreference,
            aiPersonality: data.aiPersonality,
            notificationPreference: data.notificationPreference,
            themePreference: data.themePreference,
            privacyPreference: data.privacyPreference,
          )
          as T;
    }
    throw UnsupportedError(
      'Mapping for type ${data.runtimeType} not implemented.',
    );
  }

  UserProfileTableCompanion _convertToUserProfileCompanion(
    UserProfile profile,
  ) {
    return UserProfileTableCompanion.insert(
      id: profile.id,
      createdAt: Value(profile.createdAt),
      updatedAt: Value(profile.updatedAt),
      version: Value(profile.version),
      isDeleted: Value(profile.isDeleted),
      deletedAt: Value(profile.deletedAt),
      syncStatus: Value(profile.syncStatus),
      deviceId: Value(profile.deviceId),
      name: Value(profile.name),
      role: Value(profile.role),
      focusArea: Value(profile.focusArea),
      workStyle: Value(profile.workStyle),
      healthGoal: Value(profile.healthGoal),
      financeGoal: Value(profile.financeGoal),
      goalText: Value(profile.goalText),
      aiTone: Value(profile.aiTone),
      aiDepth: Value(profile.aiDepth),
      completedSteps: profile.completedSteps,
      fullName: Value(profile.fullName),
      preferredName: Value(profile.preferredName),
      dateOfBirth: Value(profile.dateOfBirth),
      gender: Value(profile.gender),
      height: Value(profile.height),
      weight: Value(profile.weight),
      country: Value(profile.country),
      timeZone: Value(profile.timeZone),
      occupation: Value(profile.occupation),
      company: Value(profile.company),
      workType: Value(profile.workType),
      shiftType: Value(profile.shiftType),
      workHours: Value(profile.workHours),
      sleepGoal: Value(profile.sleepGoal),
      waterGoal: Value(profile.waterGoal),
      exerciseFrequency: Value(profile.exerciseFrequency),
      fitnessLevel: Value(profile.fitnessLevel),
      healthGoals: profile.healthGoals,
      currency: Value(profile.currency),
      monthlyIncome: Value(profile.monthlyIncome),
      monthlyBudget: Value(profile.monthlyBudget),
      savingsGoal: Value(profile.savingsGoal),
      financialPriorities: profile.financialPriorities,
      lifeGoals: Value(profile.lifeGoals),
      learningGoals: Value(profile.learningGoals),
      focusAreas: Value(profile.focusAreas),
      reminderPreference: Value(profile.reminderPreference),
      aiPersonality: Value(profile.aiPersonality),
      notificationPreference: Value(profile.notificationPreference),
      themePreference: Value(profile.themePreference),
      privacyPreference: Value(profile.privacyPreference),
    );
  }
}
