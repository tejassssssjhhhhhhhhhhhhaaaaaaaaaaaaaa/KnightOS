import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/data_provider.dart';
import '../../../core/intelligence/services/google_drive_provider.dart';

import '../../../app/widgets/google_account_card.dart';

class SyncCenterScreen extends ConsumerWidget {
  const SyncCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(dataProviderRegistryProvider);

    return KnightPageScaffold(
      title: 'Sync Center',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(KnightTokens.spacingM),
        children: [
          _buildOverallStatus(providers),
          const SizedBox(height: 24),
          const GoogleAccountCard(),
          const SizedBox(height: 32),
          const Text(
            'CONNECTED PROVIDERS',
            style: KnightTokens.label,
          ),
          const SizedBox(height: 16),
          ...providers.map((p) => _ProviderTile(provider: p)),
          const SizedBox(height: 32),
          _buildSyncActions(context, ref, providers),
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildOverallStatus(List<DataProvider> providers) {
    final connectedCount = providers.where((p) => p.status == ProviderStatus.connected).length;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_rounded, color: DesignColors.accentBlue, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$connectedCount / ${providers.length} ACTIVE',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const Text(
                  'Connected Intelligence Layer',
                  style: TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncActions(BuildContext context, WidgetRef ref, List<DataProvider> providers) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => ref.read(dataProviderRegistryProvider.notifier).syncAll(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('SYNC ALL NOW'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _triggerRestore(context, ref, providers),
            icon: const Icon(Icons.settings_backup_restore_rounded),
            label: const Text('MANUAL RESTORE'),
          ),
        ),
      ],
    );
  }

  Future<void> _triggerRestore(BuildContext context, WidgetRef ref, List<DataProvider> providers) async {
     final driveProvider = providers.whereType<GoogleDriveProvider>().firstOrNull;
     
     if (driveProvider == null) return;

     final scaffold = ScaffoldMessenger.of(context);
     scaffold.showSnackBar(const SnackBar(content: Text('Initializing Restore...')));

     try {
       await driveProvider.restore();
       scaffold.showSnackBar(const SnackBar(content: Text('System Restored. Restarting KnightOS...')));
     } catch (e) {
       scaffold.showSnackBar(SnackBar(content: Text('Restore Failed: $e'), backgroundColor: DesignColors.error));
     }
  }
}

class _ProviderTile extends ConsumerWidget {
  const _ProviderTile({required this.provider});
  final DataProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          _buildStatusIndicator(),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (provider.id == 'gmail_api') {
                  context.push('/settings/sync/gmail');
                } else if (provider.id == 'google_calendar_provider') {
                  context.push('/settings/sync/calendar');
                } else if (provider.id == 'google_drive_provider') {
                  context.push('/settings/sync/drive');
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    provider.status == ProviderStatus.error && provider.lastError != null
                        ? 'ERROR: ${provider.lastError}'
                        : (provider.lastSyncTime != null 
                            ? 'Last sync: ${provider.lastSyncTime.toString().substring(11, 16)}'
                            : 'Never synced'),
                    style: TextStyle(
                      fontSize: 11, 
                      color: provider.status == ProviderStatus.error ? DesignColors.error : Colors.white24,
                      fontWeight: provider.status == ProviderStatus.error ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMiniStats(provider.stats),
                ],
              ),
            ),
          ),
          Switch(
            value: provider.status == ProviderStatus.connected || provider.status == ProviderStatus.syncing,
            onChanged: (val) {
              ref.read(dataProviderRegistryProvider.notifier).setConnectionIntent(provider.id, val);
            },
            activeThumbColor: DesignColors.accentBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStats(SyncStats stats) {
    return Row(
      children: [
        _miniStat('In', stats.imported, DesignColors.success),
        _miniStat('Up', stats.updated, DesignColors.accentBlue),
        _miniStat('Dp', stats.duplicatesPrevented, DesignColors.warning),
      ],
    );
  }

  Widget _miniStat(String label, int val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text('$val', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    switch (provider.status) {
      case ProviderStatus.connected: color = DesignColors.success; break;
      case ProviderStatus.syncing: color = DesignColors.accentBlue; break;
      case ProviderStatus.error: color = DesignColors.error; break;
      case ProviderStatus.disconnected: color = Colors.white10; break;
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
