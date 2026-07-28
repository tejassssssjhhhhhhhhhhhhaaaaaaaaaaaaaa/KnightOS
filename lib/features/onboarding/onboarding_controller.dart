import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/storage_providers.dart';
import 'domain/onboarding_profile.dart';

final onboardingProfileProvider =
    AsyncNotifierProvider<OnboardingNotifier, UserProfile?>(
      OnboardingNotifier.new,
    );

class OnboardingNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final repository = ref.watch(userRepositoryProvider);
    return repository.loadProfile();
  }

  Future<void> saveProfile(UserProfile profile) async {
    final repository = ref.watch(userRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.saveProfile(profile);
      return repository.loadProfile();
    });
  }

  Future<void> clearProfile() async {
    final repository = ref.watch(userRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.clearProfile();
      return repository.loadProfile();
    });
  }
}
