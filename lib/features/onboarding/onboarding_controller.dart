import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/onboarding_storage.dart';
import 'domain/onboarding_profile.dart';

final onboardingProfileProvider = AsyncNotifierProvider<OnboardingNotifier, OnboardingProfile?>(
  OnboardingNotifier.new,
);

class OnboardingNotifier extends AsyncNotifier<OnboardingProfile?> {
  late final OnboardingStorage _storage;

  @override
  Future<OnboardingProfile?> build() async {
    _storage = OnboardingStorage();
    return _storage.loadProfile();
  }

  Future<void> saveProfile(OnboardingProfile profile) async {
    state = await AsyncValue.guard(() async {
      await _storage.saveProfile(profile);
      return _storage.loadProfile();
    });
  }

  Future<void> clearProfile() async {
    state = await AsyncValue.guard(() async {
      await _storage.clearProfile();
      return _storage.loadProfile();
    });
  }
}
