import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/design_system/knight_tokens.dart';
import '../../core/providers/storage_providers.dart';
import '../../core/providers/google_auth_providers.dart';
import '../../core/router/app_routes.dart';
import '../../core/design_system/widgets/knight_circuit_shield.dart';
import '../../core/internal/services/greeting_service.dart';
import '../../core/intelligence/knight_context_provider.dart';
import '../../core/design_system/widgets/usage_transparency_widget.dart';
import '../widgets/knight_page_scaffold.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _devTapCount = 0;

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Profile',
      showBackButton: false, // Shell route primary destination
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildProfileCard(context, ref),
            const SizedBox(height: 24),
            const UsageTransparencyWidget(
              resourceName: 'Neural Core Usage',
              used: 12,
              total: 1000,
              unit: 'calls',
              resetInfo: 'Local processing - No technical reset required',
            ),
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
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return sessionAsync.when(
      data: (session) {
        final isAuthenticated = session?.isAuthenticated ?? false;
        
        // P0: Get identity from memories if session is minimal
        String displayName = session?.displayName ?? 'Knight';
        String email = session?.email ?? 'Intelligence active';
        String? photoUrl = session?.photoUrl;

        contextAsync.whenData((ctx) {
          final identity = ctx.relatedMemories.firstWhereOrNull((m) => m.memoryId == 'user-profile-identity');
          if (identity != null) {
            displayName = identity.content['displayName'] ?? displayName;
            email = identity.content['email'] ?? email;
            photoUrl = identity.content['photoUrl'] ?? photoUrl;
          }
        });

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: KnightTokens.glass(
            accentColor: DesignColors.accentBlue,
            opacity: 0.1,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: DesignColors.surfaceHigh,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
                child: photoUrl == null 
                  ? const KnightCircuitShield(size: 32, period: KnightDayPeriod.day)
                  : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAuthenticated ? email : 'Sign in to enable cloud sync',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                    if (isAuthenticated) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'CLOUD SYNC ACTIVE',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => ref.read(googleAuthServiceProvider).signOut(),
                            child: const Text('SIGN OUT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (!isAuthenticated)
                FilledButton(
                  onPressed: () => context.push(AppRoutes.auth),
                  style: FilledButton.styleFrom(
                    backgroundColor: DesignColors.accentBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Connect'),
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
      _SItem('Data Hub', Icons.hub_rounded, route: AppRoutes.dataHub),
      _SItem('Profile & Account', Icons.person_outline_rounded, route: AppRoutes.profile),
      _SItem('Preferences', Icons.tune_rounded, explanation: 'Knight automatically adapts to your behavior. Manual overrides are restricted to ensure OS stability.'),
      _SItem('Data & Privacy', Icons.security_rounded, route: AppRoutes.privacy),
      _SItem('Sync Center', Icons.sync_rounded, route: AppRoutes.integrations),
      _SItem('Intelligence QA', Icons.science_outlined, route: AppRoutes.aiQa),
      _SItem('Notifications', Icons.notifications_none_rounded, explanation: 'Smart notifications are managed by the Knight Observation Engine. No manual setup required.'),
      _SItem('Appearance', Icons.palette_outlined, explanation: 'Horizon Design System 2.0 is forced for luxury consistency. Themes adapt automatically to the time of day.'),
    ];

    return Column(
      children: [
        ...items.map((item) => _buildSettingsTile(context, item)),
        const SizedBox(height: 12),
        _buildAboutTile(context),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, _SItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.white38, size: 22),
        title: Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10, size: 20),
        onTap: () {
          if (item.route != null) {
            context.push(item.route!);
          } else if (item.explanation != null) {
            _showExplanation(context, item.label, item.explanation!);
          }
        },
      ),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const KnightCircuitShield(size: 24, period: KnightDayPeriod.day),
      title: const Text('About Knight OS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: GestureDetector(
        onTap: () {
          _devTapCount++;
          if (_devTapCount >= 7) {
            _devTapCount = 0;
            context.push(AppRoutes.developerMode);
          }
        },
        child: const Text('Version 5.0.0 (Concept 08)', style: TextStyle(fontSize: 11, color: Colors.white24)),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10, size: 20),
      onTap: () => _showAbout(context),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignColors.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const KnightCircuitShield(size: 80, period: KnightDayPeriod.day),
            const SizedBox(height: 24),
            const Text('KNIGHT OS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4.0)),
            const SizedBox(height: 8),
            const Text('Personal Operating System', style: TextStyle(fontSize: 10, color: DesignColors.accentBlue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            const Text(
              'A living intelligence system designed for total life ownership.\n\nBuilt on the Concept 08 Identity Framework.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 40),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('DISMISS')),
          ],
        ),
      ),
    );
  }
  void _showExplanation(BuildContext context, String title, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignColors.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: DesignRadius.sheet),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0, color: DesignColors.accentBlue)),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.white70)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('UNDERSTOOD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SItem {
  const _SItem(this.label, this.icon, {this.route, this.explanation});
  final String label;
  final IconData icon;
  final String? route;
  final String? explanation;
}
