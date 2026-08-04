import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/data_provider.dart';
import '../../../core/intelligence/services/provider_sync_stats_provider.dart';
import '../../../core/intelligence/services/extraction_stats_provider.dart';
import '../../../core/intelligence/services/sync_task_service.dart';
import 'package:intl/intl.dart';

class GmailSyncDashboard extends ConsumerStatefulWidget {
  const GmailSyncDashboard({super.key});

  @override
  ConsumerState<GmailSyncDashboard> createState() => _GmailSyncDashboardState();
}

class _GmailSyncDashboardState extends ConsumerState<GmailSyncDashboard> {
  bool _showWizard = false;

  @override
  Widget build(BuildContext context) {
    final syncStatsAsync = ref.watch(providerSyncStatsProvider('gmail_api'));
    final extStatsAsync = ref.watch(extractionStatsProvider);
    final workerState = ref.watch(syncTaskServiceProvider);
    
    final registry = ref.watch(dataProviderRegistryProvider);
    final gmailIndex = registry.indexWhere((p) => p.id == 'gmail_api');

    if (gmailIndex == -1) {
      return const KnightPageScaffold(
        title: 'Gmail Intelligence',
        showBackButton: true,
        body: Center(child: Text('Gmail Provider not found')),
      );
    }
    
    final gmailProvider = registry[gmailIndex];

    return KnightPageScaffold(
      title: 'Gmail Intelligence',
      showBackButton: true,
      body: Stack(
        children: [
          syncStatsAsync.when(
            data: (syncStats) => ListView(
              padding: const EdgeInsets.all(KnightTokens.spacingM),
              children: [
                _SyncStatusCard(stats: syncStats, provider: gmailProvider, workerState: workerState),
                const SizedBox(height: 32),
                _buildActionButtons(ref),
                const SizedBox(height: 32),
                const Text('EXTRACTION INTELLIGENCE', style: KnightTokens.label),
                const SizedBox(height: 16),
                extStatsAsync.when(
                  data: (extStats) => _buildExtractionGrid(syncStats, extStats),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Ext Error: $e'),
                ),
                const SizedBox(height: 32),
                const Text('KNOWLEDGE COVERAGE', style: KnightTokens.label),
                const SizedBox(height: 16),
                _CoverageSection(stats: syncStats),
                const SizedBox(height: 32),
                _buildQueueStatus(syncStats),
                const SizedBox(height: 140),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Telemetry Error: $e')),
          ),
          if (_showWizard) _ForceSyncWizard(onClose: () => setState(() => _showWizard = false)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              setState(() => _showWizard = true);
              ref.read(dataProviderRegistryProvider.notifier).syncAll();
            },
            icon: const Icon(Icons.sync_rounded),
            label: const Text('FORCE SYNC'),
          ),
        ),
      ],
    );
  }

  Widget _buildExtractionGrid(ProviderSyncStats syncStats, ExtractionStats extStats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _MetricCard(label: 'Emails Indexed', value: NumberFormat('#,###').format(syncStats.totalIndexed)),
        _MetricCard(label: 'Entities Extracted', value: NumberFormat('#,###').format(extStats.entitiesExtracted), color: Colors.greenAccent),
        _MetricCard(label: 'Canonical IDs', value: extStats.canonicalIdentities.toString(), color: Colors.blueAccent),
        _MetricCard(label: 'Avg Confidence', value: '${(extStats.averageConfidence * 100).toInt()}%', color: Colors.orangeAccent),
      ],
    );
  }

  Widget _buildQueueStatus(ProviderSyncStats stats) {
     return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SYSTEM QUEUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 1.0)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QueueItem(label: 'PENDING', count: stats.pendingTasks, color: DesignColors.accentBlue),
              _QueueItem(label: 'FAILED', count: stats.failedTasks, color: DesignColors.error),
              const _QueueItem(label: 'DEAD LETTER', count: 0, color: Colors.white10),
            ],
          ),
        ],
      ),
    );
  }
}

class _SyncStatusCard extends StatelessWidget {
  const _SyncStatusCard({required this.stats, required this.provider, required this.workerState});
  final ProviderSyncStats stats;
  final DataProvider provider;
  final WorkerState workerState;

  @override
  Widget build(BuildContext context) {
    final bool inProgress = stats.status == 'in_progress' || workerState == WorkerState.processing;

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
                      inProgress ? 'PROCESSING...' : (provider.status == ProviderStatus.connected ? 'CONNECTED' : 'DISCONNECTED'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      inProgress ? 'Background workers are active' : 'Evidence-Based Intelligence Active',
                      style: const TextStyle(fontSize: 12, color: Colors.white38),
                    ),
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
          _InfoRow(label: 'Knowledge Age', value: _formatAge(stats.lastSync)),
          _InfoRow(label: 'Last Successful', value: stats.lastSync != null ? DateFormat('MMM d, HH:mm').format(stats.lastSync!) : 'Never'),
        ],
      ),
    );
  }

  String _formatAge(DateTime? lastSync) {
    if (lastSync == null) return 'N/A';
    final diff = DateTime.now().difference(lastSync);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    return '${diff.inHours}h';
  }
}

class _ForceSyncWizard extends ConsumerWidget {
  const _ForceSyncWizard({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(providerSyncStatsProvider('gmail_api')).value;
    final workerState = ref.watch(syncTaskServiceProvider);

    final bool isDownloading = stats?.status == 'in_progress';
    final bool isProcessing = workerState == WorkerState.processing;

    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('FORCE SYNC WIZARD', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              const SizedBox(height: 40),
              _Step(label: 'Authentication', status: 'COMPLETE', color: Colors.greenAccent),
              _Step(label: 'Download (Gmail API)', status: isDownloading ? 'RUNNING' : (stats?.totalIndexed != 0 ? 'COMPLETE' : 'PENDING'), color: isDownloading ? Colors.blueAccent : Colors.white24),
              _Step(label: 'Classification', status: isProcessing ? 'RUNNING' : 'PENDING', color: isProcessing ? Colors.blueAccent : Colors.white24),
              _Step(label: 'Entity Extraction', status: 'PENDING', color: Colors.white24),
              const SizedBox(height: 40),
              if (!isDownloading && !isProcessing)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: onClose, child: const Text('DISMISS')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.label, required this.status, required this.color});
  final String label;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
          Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _CoverageSection extends StatelessWidget {
  const _CoverageSection({required this.stats});
  final ProviderSyncStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.05),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Knowledge Depth', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text('Full Extraction Mode', style: TextStyle(fontSize: 10, color: Colors.white24, letterSpacing: 1.0)),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: stats.totalIndexed > 0 ? 0.9 : 0.0,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            color: Colors.blueAccent,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
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

class _QueueItem extends StatelessWidget {
  const _QueueItem({required this.label, required this.count, required this.color});
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
      ],
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
        inProgress ? Icons.auto_awesome_rounded : (connected ? Icons.check_circle_outline_rounded : Icons.cloud_off_rounded),
        color: inProgress ? Colors.blueAccent : (connected ? Colors.greenAccent : Colors.white24),
      ),
    );
  }
}
