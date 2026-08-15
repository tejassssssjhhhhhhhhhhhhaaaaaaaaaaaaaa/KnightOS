import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/data_provider.dart';

class ProviderHealthScreen extends ConsumerWidget {
  const ProviderHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(dataProviderRegistryProvider);

    return KnightPageScaffold(
      title: 'Provider Health',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(KnightTokens.spacingM),
        children: [
          _buildHealthOverview(providers),
          const SizedBox(height: 32),
          const Text(
            'DIAGNOSTIC FEED',
            style: KnightTokens.label,
          ),
          const SizedBox(height: 16),
          ...providers.map((p) => _ProviderHealthCard(provider: p)),
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildHealthOverview(List<DataProvider> providers) {
    final healthyCount = providers.where((p) => p.status == ProviderStatus.connected).length;
    final errorCount = providers.where((p) => p.status == ProviderStatus.error).length;

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
              const Icon(Icons.health_and_safety_rounded, color: DesignColors.success, size: 32),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$healthyCount HEALTHY / $errorCount ISSUES',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const Text(
                      'Data Integrity Diagnostic',
                      style: TextStyle(fontSize: 12, color: Colors.white38),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (errorCount > 0) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DesignColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: DesignColors.error, size: 16),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Action required for one or more providers to ensure intelligence accuracy.',
                      style: TextStyle(fontSize: 11, color: DesignColors.error, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProviderHealthCard extends StatelessWidget {
  const _ProviderHealthCard({required this.provider});
  final DataProvider provider;

  @override
  Widget build(BuildContext context) {
    final isHealthy = provider.status == ProviderStatus.connected || provider.status == ProviderStatus.syncing;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHealthy ? Colors.white.withValues(alpha: 0.05) : DesignColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      provider.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10, 
                        letterSpacing: 1.2,
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.status == ProviderStatus.error)
                const Icon(Icons.error_outline_rounded, color: DesignColors.error),
            ],
          ),
          if (provider.status == ProviderStatus.error && provider.lastError != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.lastError!,
                style: const TextStyle(fontSize: 12, color: DesignColors.error, fontFamily: 'monospace'),
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildHealthMetrics(),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _metric('LATENCY', 'Low', DesignColors.success),
        _metric('FRESHNESS', _getFreshness(), DesignColors.accentBlue),
        _metric('UPTIME', '100%', DesignColors.success),
      ],
    );
  }

  String _getFreshness() {
    if (provider.lastSuccessfulSync == null) return 'N/A';
    final diff = DateTime.now().difference(provider.lastSuccessfulSync!);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  Widget _metric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildIcon() {
    IconData icon;
    switch (provider.id) {
      case 'gmail_api': icon = Icons.email_outlined; break;
      case 'google_calendar_provider': icon = Icons.calendar_today_outlined; break;
      case 'google_drive_provider': icon = Icons.cloud_queue_rounded; break;
      case 'google_health_provider': icon = Icons.health_and_safety_outlined; break;
      default: icon = Icons.settings_input_component_outlined;
    }
    return Icon(icon, color: Colors.white70);
  }

  Color _getStatusColor() {
    switch (provider.status) {
      case ProviderStatus.connected: return DesignColors.success;
      case ProviderStatus.syncing: return DesignColors.accentBlue;
      case ProviderStatus.error: return DesignColors.error;
      case ProviderStatus.requiresAuthorization: return DesignColors.warning;
      case ProviderStatus.notConfigured: return Colors.white10;
      case ProviderStatus.disconnected: return Colors.white24;
    }
  }
}
