import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/widgets/knight_shield_entrance.dart';
import '../../../core/intelligence/services/google_data_hub.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/providers/journey_provider.dart';
import '../../../core/intelligence/domain/data_provider.dart';
import '../../../core/intelligence/providers/brain_provider.dart';
import '../../../core/router/app_routes.dart';
import 'widgets/knight_core_visualization.dart';
import 'widgets/data_pipeline_journey.dart';

class KnightCoreScreen extends ConsumerStatefulWidget {
  const KnightCoreScreen({super.key});

  @override
  ConsumerState<KnightCoreScreen> createState() => _KnightCoreScreenState();
}

class _KnightCoreScreenState extends ConsumerState<KnightCoreScreen> {
  bool _showEntrance = true;

  @override
  Widget build(BuildContext context) {
    if (_showEntrance) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: KnightShieldEntrance(
          onComplete: () => setState(() => _showEntrance = false),
        ),
      );
    }

    final hubStatus = ref.watch(googleDataHubProvider);
    final journey = ref.watch(journeyProvider);
    final providers = ref.watch(dataProviderRegistryProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white24),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white24),
            onPressed: () => context.push(AppRoutes.importCenter),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.blueAccent.withValues(alpha: 0.05),
              Colors.black,
            ],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'KNIGHT CORE',
                    style: TextStyle(
                      letterSpacing: 8,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'INFRASTRUCTURE & DATA HUB',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.white24,
                    ),
                  ),
                  const Spacer(),
                  KnightCoreVisualization(
                    sources: providers.map((p) => ConnectedSource(
                      id: p.id,
                      label: p.name,
                      icon: _getIconForProvider(p.id),
                      status: _mapStatus(p.status, hubStatus),
                    )).toList(),
                  ),
                  const Spacer(),
                  _buildBrainEntry(context, ref),
                  const SizedBox(height: 32),
                  _buildActivityArea(journey, hubStatus),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrainEntry(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(brainMetricsProvider);

    return InkWell(
      onTap: () => context.push(AppRoutes.brain),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.psychology_outlined, color: Colors.blueAccent, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MY KNIGHT BRAIN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 14)),
                  Text(
                    'What KNIGHT currently knows about your life.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10),
                  ),
                ],
              ),
            ),
            metricsAsync.when(
              data: (m) => Text('${m.totalFacts}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.blueAccent)),
              loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, _) => const Icon(Icons.error_outline, color: Colors.redAccent),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Colors.white10),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityArea(PipelineJourney? journey, HubStatus status) {
    if (journey == null || (status != HubStatus.syncingHistorical && status != HubStatus.syncingIncremental)) {
      return Column(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 32),
          const SizedBox(height: 12),
          const Text(
            'Everything is up to date.',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            'All sources are synchronized and verified.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10),
          ),
        ],
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: DataPipelineJourneyVisualizer(journey: journey),
      ),
    );
  }

  SourceStatus _mapStatus(ProviderStatus providerStatus, HubStatus hubStatus) {
    if (providerStatus == ProviderStatus.syncing) return SourceStatus.syncing;
    if (providerStatus == ProviderStatus.error) return SourceStatus.error;
    if (providerStatus == ProviderStatus.connected) {
       if (hubStatus == HubStatus.syncingHistorical || hubStatus == HubStatus.syncingIncremental) {
         return SourceStatus.processing;
       }
       return SourceStatus.upToDate;
    }
    return SourceStatus.notConnected;
  }

  IconData _getIconForProvider(String id) {
    if (id.contains('gmail')) return Icons.email_rounded;
    if (id.contains('calendar')) return Icons.calendar_today_rounded;
    if (id.contains('drive')) return Icons.insert_drive_file_rounded;
    if (id.contains('health')) return Icons.favorite_rounded;
    if (id.contains('contacts')) return Icons.people_rounded;
    if (id.contains('tasks')) return Icons.task_alt_rounded;
    return Icons.hub_rounded;
  }
}
