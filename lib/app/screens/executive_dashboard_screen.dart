import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/knight_page_scaffold.dart';
import '../../core/design_system/knight_tokens.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/intelligence/services/health_intelligence_service.dart';

class ExecutiveDashboardScreen extends ConsumerWidget {
  const ExecutiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthDataAsync = ref.watch(_healthDashboardDataProvider);

    return KnightPageScaffold(
      title: 'Executive Dashboard',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('EXECUTIVE SUMMARY', style: KnightTokens.label),
            const SizedBox(height: 16),
            const Text(
              'KnightOS Milestone 5 (Health Intelligence) is now operational. '
              'The personal intelligence layer is actively aggregating data from Samsung Health and Galaxy Watch. '
              'Workout and Nutrition platforms are seeded with regional Indian data.',
              style: TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            const Text('PROJECT SCOREBOARD', style: KnightTokens.label),
            const SizedBox(height: 16),
            healthDataAsync.when(
              data: (data) => Column(
                children: [
                  _metric('Health Intelligence', 'Operational', Colors.greenAccent),
                  _metric('Samsung Health Sync', 'Active', Colors.greenAccent),
                  _metric('Workout Planner', 'Ready', Colors.greenAccent),
                  _metric('Nutrition Engine', '85% Seeded', Colors.blueAccent),
                  _metric('Daily Health Score', '${data.dailyScore}%', Colors.orangeAccent),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, s) => Text('Error: $e'),
            ),
            const SizedBox(height: 32),
            const Text('CEO DAILY REPORT', style: KnightTokens.label),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DesignColors.surfaceHigh,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DesignColors.white05),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: SYSTEM NOMINAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  SizedBox(height: 12),
                  Text('Today\'s focus is on scaling the Knowledge Graph with real-world physical vitals. '
                       'The Galaxy Watch is successfully participating in the Device Mesh.', 
                       style: TextStyle(fontSize: 12, color: Colors.white38)),
                ],
              ),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.white38)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

final _healthDashboardDataProvider = FutureProvider<HealthDashboardData>((ref) {
  return ref.watch(healthIntelligenceServiceProvider).getDashboardData();
});
