import '../../features/onboarding/domain/onboarding_profile.dart';
import 'authentication_repository.dart';
import '../storage/local_database.dart';
import '../storage/storage_keys.dart';

class UserRepository {
  UserRepository({LocalDatabase? localDatabase, AuthenticationRepository? authenticationRepository})
      : _database = localDatabase ?? const LocalDatabase(),
        _authenticationRepository = authenticationRepository ?? AuthenticationRepository();

  final LocalDatabase _database;
  final AuthenticationRepository _authenticationRepository;

  Future<OnboardingProfile?> loadProfile() async {
    final decoded = await _database.readJson(StorageKeys.onboardingProfile);
    if (decoded == null) {
      return null;
    }
    return OnboardingProfile.fromJson(decoded.cast<String, Object?>());
  }

  Future<void> saveProfile(OnboardingProfile profile) async {
    await _database.writeJson(StorageKeys.onboardingProfile, profile.toJson().cast<String, dynamic>());
    final session = await _authenticationRepository.getCurrentSession();
    if (session != null) {
      await _authenticationRepository.persistSession(
        AuthSession(
          userId: session.userId,
          email: session.email,
          displayName: profile.preferredName.isEmpty ? profile.fullName : profile.preferredName,
          isAuthenticated: true,
          isEmailVerified: session.isEmailVerified,
          provider: session.provider,
        ),
      );
    }
  }

  Future<void> clearProfile() async {
    await _database.delete(StorageKeys.onboardingProfile);
  }
}
