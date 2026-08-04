import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../domain/finance_goal_models.dart';

class WealthBuilderHero extends StatelessWidget {
  const WealthBuilderHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: KnightTokens.glass(accentColor: Colors.amberAccent, opacity: 0.1),
      child: Column(
        children: [
          const Icon(Icons.auto_graph_rounded, size: 32, color: Colors.amberAccent),
          const SizedBox(height: 16),
          Text(
            'WEALTH BUILDER',
            style: KnightTokens.label.copyWith(color: Colors.amberAccent),
          ),
          const SizedBox(height: 8),
          const Text(
            'Achieve your life milestones through evidence-driven planning.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({super.key, required this.report});
  final FinanceGoalReport report;

  @override
  Widget build(BuildContext context) {
    final progress = report.currentProgress.clamp(0, 1).toDouble();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GoalIcon(type: report.goal.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.goal.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(report.status.toUpperCase(), style: KnightTokens.label.copyWith(fontSize: 8, color: Colors.blueAccent)),
                  ],
                ),
              ),
              Text(
                '₹${report.goal.targetAmount.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          _buildMilestones(progress),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniMetric(label: 'SAVED', value: '₹${report.goal.currentAmount.toStringAsFixed(0)}'),
              _MiniMetric(label: 'COMPLETION', value: '${report.expectedCompletion.year}'),
              _MiniMetric(label: 'PROGRESS', value: '${(progress * 100).toInt()}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(double progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MilestoneMarker(label: '25%', reached: progress >= 0.25),
        _MilestoneMarker(label: '50%', reached: progress >= 0.50),
        _MilestoneMarker(label: '75%', reached: progress >= 0.75),
        _MilestoneMarker(label: '100%', reached: progress >= 1.0),
      ],
    );
  }
}

class _MilestoneMarker extends StatelessWidget {
  const _MilestoneMarker({required this.label, required this.reached});
  final String label;
  final bool reached;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          reached ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 10,
          color: reached ? Colors.greenAccent : Colors.white10,
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 6, color: reached ? Colors.white70 : Colors.white10)),
      ],
    );
  }
}

class _GoalIcon extends StatelessWidget {
  const _GoalIcon({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (type) {
      case 'emergency_fund': icon = Icons.security_rounded; break;
      case 'vehicle': icon = Icons.directions_car_rounded; break;
      case 'home': icon = Icons.home_rounded; break;
      case 'travel': icon = Icons.flight_takeoff_rounded; break;
      case 'education': icon = Icons.school_rounded; break;
      case 'investment': icon = Icons.trending_up_rounded; break;
      default: icon = Icons.star_rounded;
    }
    return Icon(icon, size: 20, color: Colors.white24);
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: KnightTokens.label.copyWith(fontSize: 7)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
      ],
    );
  }
}

class GoalInsightTile extends StatelessWidget {
  const GoalInsightTile({super.key, required this.insight});
  final GoalInsight insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 14, color: Colors.blueAccent),
              const SizedBox(width: 12),
              Text(insight.title.toUpperCase(), style: KnightTokens.label.copyWith(fontSize: 8, color: Colors.blueAccent)),
            ],
          ),
          const SizedBox(height: 8),
          Text(insight.message, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(insight.evidence, style: const TextStyle(fontSize: 11, color: Colors.white24)),
        ],
      ),
    );
  }
}
