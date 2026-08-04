import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';
import 'engines/travel_dna_engine.dart';

class TravelDnaScreen extends ConsumerWidget {
  const TravelDnaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dnaAsync = ref.watch(travelDnaProvider);
    final metricsAsync = ref.watch(travelMetricsProvider);

    return KnightPageScaffold(
      title: 'Travel DNA',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntranceFader(child: _buildHeroHeader(dnaAsync)),
            const SizedBox(height: 40),
            EntranceFader(delay: const Duration(milliseconds: 200), child: _buildBehavioralInsights(dnaAsync)),
            const SizedBox(height: 40),
            EntranceFader(delay: const Duration(milliseconds: 400), child: _buildGeographicProfile(metricsAsync)),
            const SizedBox(height: 40),
            EntranceFader(delay: const Duration(milliseconds: 600), child: _buildDetailedStats(metricsAsync, dnaAsync)),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(AsyncValue<TravelDna> dnaAsync) {
    return dnaAsync.when(
      data: (dna) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: KnightTokens.glass(accentColor: DesignColors.travel, opacity: 0.15),
        child: Column(
          children: [
            const Icon(Icons.fingerprint, size: 64, color: DesignColors.travel),
            const SizedBox(height: 24),
            Text(dna.explorerType.toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 8),
            Text('YOUR TRAVEL SIGNATURE', style: KnightTokens.label.copyWith(color: Colors.white38)),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Widget _buildBehavioralInsights(AsyncValue<TravelDna> dnaAsync) {
    return dnaAsync.when(
      data: (dna) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BEHAVIORAL DNA', style: KnightTokens.label),
          const SizedBox(height: 16),
          _InsightCard(label: 'Travel Style', value: dna.travelStyle, icon: Icons.auto_awesome),
          const SizedBox(height: 12),
          _InsightCard(label: 'Preferred Transport', value: dna.preferredTransport.toUpperCase(), icon: Icons.train),
          const SizedBox(height: 12),
          _InsightCard(label: 'Peak Season', value: DateFormat('MMMM').format(DateTime(2024, dna.preferredMonth)), icon: Icons.wb_sunny),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget _buildGeographicProfile(AsyncValue<Map<String, double>> metricsAsync) {
    return metricsAsync.when(
      data: (metrics) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GEOGRAPHIC FOOTPRINT', style: KnightTokens.label),
          const SizedBox(height: 20),
          _ProfileRow(label: 'Countries Visited', value: '${metrics['countries_visited']?.toInt() ?? 0}'),
          _ProfileRow(label: 'States/Provinces', value: '14'), // Placeholder
          _ProfileRow(label: 'Cities Explored', value: '42'), // Placeholder
          const SizedBox(height: 16),
          const LinearProgressIndicator(value: 0.12, color: DesignColors.travel, backgroundColor: Colors.white10),
          const SizedBox(height: 8),
          const Text('12% of the world explored', style: TextStyle(fontSize: 10, color: Colors.white38)),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget _buildDetailedStats(AsyncValue<Map<String, double>> metricsAsync, AsyncValue<TravelDna> dnaAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('LIFETIME METRICS', style: KnightTokens.label),
        const SizedBox(height: 16),
        metricsAsync.when(
          data: (metrics) => GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _StatTile(label: 'DISTANCE', value: '${(dnaAsync.value?.totalDistance ?? 0).toInt()} km'),
              _StatTile(label: 'FLIGHTS', value: '${metrics['total_flights']?.toInt() ?? 0}'),
              _StatTile(label: 'AVG DURATION', value: '${dnaAsync.value?.averageTripDuration.toInt() ?? 0} DAYS'),
              _StatTile(label: 'TOTAL TRIPS', value: '${metrics['total_trips']?.toInt() ?? 0}'),
            ],
          ),
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: KnightTokens.radiusCard),
      child: Row(
        children: [
          Icon(icon, size: 20, color: DesignColors.travel),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: DesignColors.travel)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: KnightTokens.glass(accentColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
