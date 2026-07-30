import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/providers/storage_providers.dart';
import '../../core/router/app_routes.dart';
import '../widgets/knight_page_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      title: 'Settings',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildProfileCard(context, ref),
            const SizedBox(height: 32),
            _buildSettingsList(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(authSessionProvider);

    return sessionAsync.when(
      data: (session) {
        final isAuthenticated = session?.isAuthenticated ?? false;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: DesignColors.white05),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: DesignColors.accentBlue,
                child: Text(
                  isAuthenticated
                      ? (session?.displayName.isNotEmpty == true
                          ? session!.displayName[0].toUpperCase()
                          : 'K')
                      : 'G',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAuthenticated
                          ? (session?.displayName ?? 'Knight User')
                          : 'Guest User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isAuthenticated
                          ? (session?.email ?? '')
                          : 'Sign in to enable all features',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isAuthenticated)
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.auth),
                  icon: const Icon(Icons.login_rounded, size: 16),
                  label: const Text('Sign In'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text('Session status unavailable')),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final items = [
      _SItem('Profile & Account', Icons.person_outline_rounded),
      _SItem('Preferences', Icons.tune_rounded),
      _SItem('Data & Privacy', Icons.security_rounded),
      _SItem('Integrations', Icons.hub_outlined),
      _SItem('Notifications', Icons.notifications_none_rounded),
      _SItem('Appearance', Icons.palette_outlined),
    ];

    return Column(
      children: [
        ...items.map((item) => _buildSettingsTile(item)),
        const SizedBox(height: 12),
        _buildAboutTile(context),
      ],
    );
  }

  Widget _buildSettingsTile(_SItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.white38, size: 22),
        title: Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10, size: 20),
        onTap: () {},
      ),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline_rounded, color: Colors.white38, size: 22),
      title: const Text('About Knight OS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: const Text('Version 2.0.0', style: TextStyle(fontSize: 11, color: Colors.white24)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10, size: 20),
      onTap: () {},
    );
  }
}

class _SItem {
  const _SItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
