import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/google_account_provider.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/services/google_auth_service.dart';

class GoogleAccountCard extends ConsumerWidget {
  const GoogleAccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAccountAsync = ref.watch(googleAccountProvider);

    return googleAccountAsync.when(
      data: (account) {
        if (account == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesignColors.surfaceHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle_outlined, color: Colors.white24, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Google Workspace', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Not connected', style: TextStyle(fontSize: 12, color: Colors.white24)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => GoogleAuthService.instance.signIn(),
                  child: const Text('CONNECT'),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: DesignColors.accentBlue.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: account.photoUrl != null ? NetworkImage(account.photoUrl!) : null,
                child: account.photoUrl == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.displayName ?? 'Google Account', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(account.email, style: const TextStyle(fontSize: 11, color: Colors.white38)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _confirmSignOut(context),
                icon: const Icon(Icons.logout_rounded, color: Colors.white24, size: 20),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Text('Auth Error: $e'),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignColors.surfaceHigh,
        title: const Text('Disconnect Google?'),
        content: const Text('This will stop all Google Workspace integrations from syncing.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              GoogleAuthService.instance.signOut();
              Navigator.pop(context);
            },
            child: const Text('DISCONNECT', style: TextStyle(color: DesignColors.error)),
          ),
        ],
      ),
    );
  }
}
