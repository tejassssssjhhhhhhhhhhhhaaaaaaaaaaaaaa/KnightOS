import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/data_provider.dart';
import '../../../core/intelligence/services/provider_sync_stats_provider.dart';
import 'package:intl/intl.dart';

class CalendarSyncDashboard extends ConsumerWidget {
  const CalendarSyncDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(providerSyncStatsProvider('google_calendar_provider'));
    final registry = ref.watch(dataProviderRegistryProvider);
    final providerIndex = registry.indexWhere((p) => p.id == 'google_calendar_provider');

    if (providerIndex == -1) {
       return const KnightPageScaffold(
        title: 'Calendar Sync',
        showBackButton: true,
        body: Center(child: Text('Calendar Provider not found')),
      );
    }
    final provider = registry[providerIndex];

    return KnightPageScaffold(
      title: 'Calendar Sync',
      showBackButton: true,
      body: statsAsync.when(
        data: (stats) => ListView(
          padding: const EdgeInsets.all(KnightTokens.spacingM),
          children: [
            _SyncStatusCard(stats: stats, provider: provider),
            const SizedBox(height: 32),
            _buildActionButtons(ref),
            const SizedBox(height: 32),
            const Text('CALENDAR METRICS', style: KnightTokens.label),
            const SizedBox(height: 16),
            _buildMetricsGrid(stats),
            const SizedBox(height: 140),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Telemetry Error: $e')),
      ),
    );
  }

  Widget _buildActionButtons(WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => ref.read(dataProviderRegistryProvider.notifier).syncAll(),
            icon: const Icon(Icons.sync_rounded),
            label: const Text('SYNC NOW'),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(ProviderSyncStats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _MetricCard(label: 'Events Indexed', value: NumberFormat('#,###').format(stats.totalIndexed)),
        _MetricCard(label: 'Duplicates', value: stats.duplicatesPrevented.toString(), color: Colors.orangeAccent),
        _MetricCard(label: 'Status', value: stats.status.toUpperCase(), color: stats.status == 'failed' ? DesignColors.error : DesignColors.accentBlue),
        _MetricCard(label: 'Refresh Rate', value: '30m'),
      ],
    );
  }
}

class _SyncStatusCard extends StatelessWidget {
  const _SyncStatusCard({required this.stats, required this.provider});
  final ProviderSyncStats stats;
  final DataProvider provider;

  @override
  Widget build(BuildContext context) {
    final bool inProgress = stats.status == 'in_progress' || stats.status == 'syncing';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatusIcon(inProgress: inProgress, connected: provider.status == ProviderStatus.connected),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inProgress ? 'SYNCING...' : (provider.status == ProviderStatus.connected ? 'CONNECTED' : 'DISCONNECTED'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const Text('Direct Google Calendar Integration', style: TextStyle(fontSize: 12, color: Colors.white38)),
                  ],
                ),
              ),
            ],
          ),
          if (stats.lastError != null) ...[
            const SizedBox(height: 16),
            Text(stats.lastError!, style: const TextStyle(color: DesignColors.error, fontSize: 11)),
          ],
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          _InfoRow(label: 'Last Successful Sync', value: stats.lastSync != null ? DateFormat('MMM d, HH:mm').format(stats.lastSync!) : 'Never'),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.inProgress, required this.connected});
  final bool inProgress;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: (inProgress ? Colors.blueAccent : (connected ? Colors.greenAccent : Colors.white10)).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        inProgress ? Icons.sync_rounded : (connected ? Icons.check_circle_outline_rounded : Icons.cloud_off_rounded),
        color: inProgress ? Colors.blueAccent : (connected ? Colors.greenAccent : Colors.white24),
      ),
    );
  }
}
