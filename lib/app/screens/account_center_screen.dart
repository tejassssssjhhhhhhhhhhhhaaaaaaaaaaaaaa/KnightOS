import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/current_user_provider.dart';
import '../../core/repositories/authentication_repository.dart';
import '../../core/router/app_routes.dart';
import '../widgets/knight_page_scaffold.dart';

class AccountCenterScreen extends ConsumerWidget {
  const AccountCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final authRepository = AuthenticationRepository();

    return KnightPageScaffold(
      title: 'Account',
      showBackButton: true,
      body: currentUser.when(
        data: (user) => ListView(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
                title: Text(user.displayName),
                subtitle: Text(user.profileSummary),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              subtitle: const Text('View and update your Knight profile'),
              onTap: () => context.push(AppRoutes.settings),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              subtitle: const Text('Theme, reminders, and daily preferences'),
              onTap: () => context.push(AppRoutes.settings),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy'),
              subtitle: const Text(
                'Your personal data stays local to this device',
              ),
              onTap: () => context.push(AppRoutes.settings),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              onTap: () async {
                await authRepository.signOut();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have been logged out successfully.'),
                  ),
                );
                context.go(AppRoutes.auth);
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Unable to load account: $error')),
      ),
    );
  }
}
