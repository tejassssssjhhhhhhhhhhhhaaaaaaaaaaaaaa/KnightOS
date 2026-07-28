import '../../features/onboarding/domain/onboarding_profile.dart';
import '../platform/repository/knight_repository.dart';
import '../platform/storage/knight_core_constants.dart';
import 'authentication_repository.dart';

class UserRepository extends KnightRepository<UserProfile> {
  UserRepository({
    required super.engine,
    AuthenticationRepository? authenticationRepository,
  }) : _authenticationRepository =
           authenticationRepository ?? AuthenticationRepository.instance;

  final AuthenticationRepository _authenticationRepository;

  Future<UserProfile?> loadProfile() async {
    return engine.get<UserProfile>(KnightCoreConstants.systemProfileId);
  }

  @override
  Future<void> upsert(UserProfile entity) async {
    await super.upsert(entity);

    // Legacy integration: Keep Authentication Session in sync
    final session = await _authenticationRepository.getCurrentSession();
    if (session != null) {
      await _authenticationRepository.persistSession(
        AuthSession(
          userId: session.userId,
          email: session.email,
          displayName: entity.preferredName.isEmpty
              ? entity.fullName
              : entity.preferredName,
          isAuthenticated: true,
          isEmailVerified: session.isEmailVerified,
          provider: session.provider,
        ),
      );
    }
  }

  Future<void> saveProfile(UserProfile profile) => upsert(profile);

  Future<void> clearProfile() async {
    await engine.hardDelete<UserProfile>(KnightCoreConstants.systemProfileId);
  }
}
