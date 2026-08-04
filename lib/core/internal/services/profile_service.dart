import 'dart:async';
import 'package:drift/drift.dart';
import '../../../../features/onboarding/domain/onboarding_profile.dart';
import '../storage/drift/knight_database.dart';
import '../utils/knight_logger.dart';

/// Manages the local user profile and preferences.
/// Ensures a profile exists from the first launch and handles all updates.
class ProfileService {
  ProfileService({required this.db});

  final KnightDatabase db;
  UserProfile? _currentProfile;

  /// Returns the current profile or null if not yet loaded.
  UserProfile? get currentProfile => _currentProfile;

  /// Loads the profile from the database, creating a default one if it doesn't exist.
  Future<UserProfile> initializeProfile() async {
    final existing = await db.userProfileDao.getProfile();
    
    if (existing != null) {
      _currentProfile = _mapToDomain(existing);
      KnightLogger.info('Profile loaded: ${_currentProfile?.fullName}');
    } else {
      KnightLogger.info('No profile found. Creating default local profile.');
      final defaultProfile = UserProfile(
        id: 'system_owner',
        fullName: 'Knight User',
        preferredName: 'Owner',
        completedSteps: [],
        healthGoals: [],
        financialPriorities: [],
      );
      
      // Save to DB
      await db.userProfileDao.saveProfile(_mapToCompanion(defaultProfile));
      _currentProfile = defaultProfile;
    }
    
    return _currentProfile!;
  }

  /// Updates the profile with new data.
  Future<void> updateProfile(UserProfile updated) async {
    await db.userProfileDao.saveProfile(_mapToCompanion(updated));
    _currentProfile = updated;
    KnightLogger.info('Profile updated: ${updated.fullName}');
  }

  // --- Mapping Helpers ---

  UserProfile _mapToDomain(UserProfileTableData data) {
    return UserProfile(
      id: data.id,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      version: data.version,
      isDeleted: data.isDeleted,
      fullName: data.fullName,
      preferredName: data.preferredName,
      completedSteps: data.completedSteps,
      themePreference: data.themePreference,
      timeZone: data.timeZone,
      notificationPreference: data.notificationPreference,
      aiPersonality: data.aiPersonality,
      healthGoals: data.healthGoals,
      financialPriorities: data.financialPriorities,
    );
  }

  UserProfileTableCompanion _mapToCompanion(UserProfile profile) {
    return UserProfileTableCompanion.insert(
      id: profile.id,
      fullName: Value(profile.fullName),
      preferredName: Value(profile.preferredName),
      completedSteps: profile.completedSteps,
      healthGoals: profile.healthGoals,
      financialPriorities: profile.financialPriorities,
      themePreference: Value(profile.themePreference),
      timeZone: Value(profile.timeZone),
      notificationPreference: Value(profile.notificationPreference),
      aiPersonality: Value(profile.aiPersonality),
    );
  }
}
