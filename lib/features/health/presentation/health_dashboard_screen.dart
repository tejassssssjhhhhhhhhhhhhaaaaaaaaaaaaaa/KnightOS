import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/knight_context_models.dart';
import '../../../core/intelligence/knight_context_provider.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import 'widgets/knight_health_chart.dart';
import 'health_visualization_providers.dart';
import '../../../core/intelligence/domain/health_visualization_models.dart';

class HealthDashboardScreen extends ConsumerStatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  ConsumerState<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends ConsumerState<HealthDashboardScreen> {
  String _activeTab = 'Overview';

  @override
  Widget build(BuildContext context) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      title: 'Health & Fitness',
      showBackButton: true,
      settingsRoute: AppRoutes.integrations, // Data Hub/Sync is health settings
      body: contextAsync.when(
        data: (knightContext) => _buildContent(knightContext),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(KnightContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabs(),
          const SizedBox(height: 24),
          _buildPeriodSelector(),
          const SizedBox(height: 32),
          if (_activeTab == 'Overview') ...[
            _buildScoreAndStats(context),
            const SizedBox(height: 32),
            _buildVitalityBreakdown(context),
            const SizedBox(height: 32),
            const Text('ACTIVITY TREND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
            const SizedBox(height: 16),
            _buildMetricChart('steps', ChartType.bar),
            const SizedBox(height: 32),
            _buildWorkoutSection(),
            const SizedBox(height: 32),
            _buildSleepSection(context),
            const SizedBox(height: 32),
            _buildWaterIntake(context),
            const SizedBox(height: 32),
            _buildWatchStatus(context),
          ],
          if (_activeTab == 'Workout') ...[
             _buildMetricChart('heart_rate', ChartType.line),
             const SizedBox(height: 24),
             _buildWorkoutList(),
          ],
          if (_activeTab == 'Nutrition') ...[
             _buildMetricChart('calories', ChartType.bar),
             const SizedBox(height: 24),
             _buildWaterIntake(context),
          ],
          if (_activeTab == 'Sleep') ...[
             _buildMetricChart('sleep_session', ChartType.bar),
             const SizedBox(height: 24),
             _buildSleepList(),
          ],
          if (_activeTab == 'Body') ...[
             _buildMetricChart('weight', ChartType.line),
             const SizedBox(height: 24),
             _buildMeasurementList(),
          ],
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Overview', 'Workout', 'Nutrition', 'Sleep', 'Body'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab == _activeTab;
          return GestureDetector(
            onTap: () => setState(() => _activeTab = tab),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isActive ? null : Border.all(color: Colors.white10),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white38,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final period = ref.watch(healthPeriodProvider);
    final options = ChartTimePeriod.values;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: options.map((o) {
        final isActive = o == period;
        return GestureDetector(
          onTap: () => ref.read(healthPeriodProvider.notifier).state = o,
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? DesignColors.accentBlue.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isActive ? DesignColors.accentBlue : Colors.white10),
            ),
            child: Text(
              o.name.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isActive ? DesignColors.accentBlue : Colors.white24,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVitalityBreakdown(KnightContext context) {
    final scores = context.healthScores;
    if (scores == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('VITALITY BREAKDOWN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildVitalityItem('Recovery', scores.recoveryScore.score, DesignColors.accentBlue),
            _buildVitalityItem('Sleep', scores.sleepScore.score, DesignColors.accentPurple),
            _buildVitalityItem('Stress', scores.stressScore.score, Colors.orangeAccent),
            _buildVitalityItem('Readiness', scores.readinessScore.score, DesignColors.success),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalityItem(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('$score%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
              const Spacer(),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChart(String metric, ChartType type) {
    final chartData = ref.watch(healthChartDataProvider(metric));
    
    return chartData.when(
      data: (series) => KnightHealthChart(series: series, type: type),
      loading: () => Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
      error: (e, s) => Container(
        height: 200,
        alignment: Alignment.center,
        child: Text('Data Unavailable: $metric'),
      ),
    );
  }

  Widget _buildScoreAndStats(KnightContext knightContext) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: InkWell(
            onTap: () => context.push(AppRoutes.providerHealth),
            borderRadius: BorderRadius.circular(12),
            child: Card(
              color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('VITALITY INDEX', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: (knightContext.healthScores?.dailyScore.score ?? 0) / 100.0,
                            strokeWidth: 8,
                            backgroundColor: DesignColors.white05,
                            color: DesignColors.accentBlue,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${knightContext.healthScores?.dailyScore.score ?? '--'}%', 
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                            const Text('STATUS: NOMINAL', style: TextStyle(fontSize: 10, color: DesignColors.success)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _buildSmallStat(Icons.directions_run_rounded, 'Steps', '${knightContext.steps}', DesignColors.accentBlue, onTap: () => setState(() => _activeTab = 'Overview')),
              const SizedBox(height: 12),
              _buildSmallStat(Icons.local_fire_department_rounded, 'Calories', '${knightContext.calories}', DesignColors.achievements, onTap: () => setState(() => _activeTab = 'Nutrition')),
              const SizedBox(height: 12),
              _buildSmallStat(Icons.timer_outlined, 'Active Mins', '45', DesignColors.success, onTap: () => setState(() => _activeTab = 'Workout')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStat(IconData icon, String label, String value, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DesignColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignColors.white05),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white38)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TODAY\'S WORKOUT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        Card(
          color: DesignColors.surfaceHigh,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fitness_center_rounded, color: Colors.white24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No workout logged today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Optimization suggested', style: TextStyle(fontSize: 12, color: Colors.white38)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutList() {
    final workoutsAsync = ref.watch(_recentWorkoutsProvider);
    return workoutsAsync.when(
      data: (list) {
         if (list.isEmpty) return const Center(child: Text('No historical workouts.'));
         return Column(
           children: list.map((w) => Card(
             child: ListTile(
               leading: const Icon(Icons.fitness_center_rounded, color: DesignColors.accentBlue),
               title: Text(w.workoutType),
               subtitle: Text('${w.durationMinutes.toInt()} mins'),
             ),
           )).toList(),
         );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildSleepList() {
    final sleepAsync = ref.watch(_recentSleepProvider);
    return sleepAsync.when(
      data: (list) {
         if (list.isEmpty) return const Center(child: Text('No sleep sessions logged.'));
         return Column(
           children: list.map((s) => Card(
             child: ListTile(
               leading: const Icon(Icons.bedtime_rounded, color: DesignColors.accentPurple),
               title: Text('Quality: ${s.sleepQuality}/10'),
               subtitle: Text('${s.wakeTime.difference(s.bedTime).inHours}h sleep'),
             ),
           )).toList(),
         );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildWatchStatus(KnightContext context) {
    if (context.deviceHealth.isEmpty) return const SizedBox.shrink();
    
    // Look for Galaxy Watch in context
    final watch = context.deviceHealth.values.firstWhereOrNull(
      (d) => d.deviceId.toLowerCase().contains('watch'),
    ) ?? context.deviceHealth.values.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('WATCH INTELLIGENCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        Card(
          color: DesignColors.surfaceHigh,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.watch_rounded, size: 40, color: DesignColors.accentBlue),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(watch.deviceId.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '${watch.batteryLevel}% Battery • ${watch.isCharging ? "Charging" : "Discharging"}',
                        style: const TextStyle(fontSize: 12, color: Colors.white38),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: DesignColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('HEALTHY', style: TextStyle(fontSize: 10, color: DesignColors.success, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementList() {
    final measurementsAsync = ref.watch(_recentMeasurementsProvider);
    return measurementsAsync.when(
      data: (list) {
         if (list.isEmpty) return const Center(child: Text('No measurements recorded.'));
         return Column(
           children: list.map((m) => Card(
             child: ListTile(
               leading: const Icon(Icons.monitor_weight_outlined, color: DesignColors.accentBlue),
               title: Text('${m.value} ${m.unit}'),
               subtitle: Text(m.measurementType.toUpperCase()),
             ),
           )).toList(),
         );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildSleepSection(KnightContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('SLEEP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
            Text(context.sleepStatus, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DesignColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DesignColors.white05),
          ),
          child: CustomPaint(
            painter: _SleepGraphPainter(),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterIntake(KnightContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('WATER INTAKE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
            Text('${context.waterIntake} / 2.0 L', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DesignColors.white05,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (context.waterIntake / 2.0).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: DesignColors.accentBlue,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: DesignColors.accentBlue.withValues(alpha: 0.5), blurRadius: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final _recentWorkoutsProvider = FutureProvider<List<WorkoutSessionData>>((ref) async {
  return ref.watch(healthRepositoryProvider).getRecentWorkouts();
});

final _recentSleepProvider = FutureProvider<List<SleepSessionData>>((ref) async {
  return ref.watch(healthRepositoryProvider).getRecentSleep();
});

final _recentMeasurementsProvider = FutureProvider<List<BodyMeasurementData>>((ref) async {
  return ref.watch(healthRepositoryProvider).getMeasurementHistory('weight');
});

class _SleepGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DesignColors.accentBlue.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    for (var i = 0; i <= 10; i++) {
      final x = size.width * (i / 10);
      final y = size.height * (0.4 + 0.3 * (i % 2 == 0 ? 1 : -1));
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
