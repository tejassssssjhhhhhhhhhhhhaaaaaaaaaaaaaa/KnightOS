import '../../../core/repositories/user_repository.dart';
import '../domain/onboarding_profile.dart';

class OnboardingStorage {
  OnboardingStorage({UserRepository? repository}) : _repository = repository ?? UserRepository();

  final UserRepository _repository;

  Future<OnboardingProfile?> loadProfile() async => _repository.loadProfile();

  Future<void> saveProfile(OnboardingProfile profile) async => _repository.saveProfile(profile);

  Future<void> clearProfile() async => _repository.clearProfile();

  Future<bool> hasCompletedOnboarding() async {
    final profile = await loadProfile();
    return profile != null && profile.completedSteps.isNotEmpty;
  }
}
