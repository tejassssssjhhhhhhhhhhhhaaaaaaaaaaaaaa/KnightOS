import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';

class HealthDashboardScreen extends ConsumerWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildTabs(context),
            const SizedBox(height: 32),
            _buildScoreAndStats(context),
            const SizedBox(height: 32),
            _buildWorkoutSection(context),
            const SizedBox(height: 32),
            _buildSleepSection(context),
            const SizedBox(height: 32),
            _buildWaterIntake(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text('Health & Fitness', style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['Overview', 'Workout', 'Nutrition', 'Sleep'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab == 'Overview';
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScoreAndStats(BuildContext context) {
    return Row(
      children: [
        // Health Score Gauge
        Expanded(
          flex: 4,
          child: Card(
            color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('HEALTH SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: 0.82,
                          strokeWidth: 8,
                          backgroundColor: DesignColors.white05,
                          color: DesignColors.accentBlue,
                        ),
                      ),
                      const Column(
                        children: [
                          Text('82%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                          Text('Great', style: TextStyle(fontSize: 10, color: DesignColors.success)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Quick Stats
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _buildSmallStat(Icons.directions_run_rounded, 'Steps', '8,432', DesignColors.accentBlue),
              const SizedBox(height: 12),
              _buildSmallStat(Icons.local_fire_department_rounded, 'Calories', '1,200', DesignColors.achievements),
              const SizedBox(height: 12),
              _buildSmallStat(Icons.timer_outlined, 'Active Mins', '45', DesignColors.success),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStat(IconData icon, String label, String value, Color color) {
    return Container(
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
    );
  }

  Widget _buildWorkoutSection(BuildContext context) {
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
                      Text('Full Body Strength', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('45 min • 8 Exercises', style: TextStyle(fontSize: 12, color: Colors.white38)),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill_rounded, size: 32, color: DesignColors.accentBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('SLEEP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
            const Text('6h 45m', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _buildWaterIntake(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('WATER INTAKE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
            Text('1.8 / 2.0 L', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
            widthFactor: 0.9,
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

class _SleepGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DesignColors.accentBlue.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    
    // Draw a wavy path for sleep cycles
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
