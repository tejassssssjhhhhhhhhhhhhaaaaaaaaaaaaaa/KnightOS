import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../intelligence/user_context.dart';
import '../repositories/authentication_repository.dart';
import 'storage_providers.dart';

final currentUserProvider = FutureProvider<UserContext>((ref) async {
  final authRepository = AuthenticationRepository();
  final userRepository = ref.watch(userRepositoryProvider);

  final session = await authRepository.getCurrentSession();
  final profile = await userRepository.loadProfile();

  return UserContext(
    userId: session?.userId ?? 'local-user',
    displayName:
        session?.displayName ?? profile?.preferredName ?? 'Knight User',
    profileSummary: profile == null
        ? 'New account pending onboarding'
        : profile.fullName.isEmpty
        ? 'Profile ready'
        : profile.fullName,
    preferences: [
      if (profile?.themePreference.isNotEmpty ?? false)
        profile!.themePreference,
      if (profile?.notificationPreference.isNotEmpty ?? false)
        profile!.notificationPreference,
    ],
    goals: [
      if (profile?.lifeGoals.isNotEmpty ?? false) profile!.lifeGoals,
      if (profile?.learningGoals.isNotEmpty ?? false) profile!.learningGoals,
    ],
    cloudReady: false,
    voiceReady: true,
  );
});
