import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../domain/finance_budget_models.dart';

class DailySafeSpendCard extends StatelessWidget {
  const DailySafeSpendCard({super.key, required this.amount});
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: KnightTokens.glass(accentColor: Colors.greenAccent, opacity: 0.1),
      child: Column(
        children: [
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: KnightTokens.headline.copyWith(color: Colors.greenAccent, fontSize: 42),
          ),
          const SizedBox(height: 8),
          const Text('DAILY SAFE SPEND', style: KnightTokens.label),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 14, color: Colors.white24),
              const SizedBox(width: 8),
              Text(
                'Protecting your monthly savings target.',
                style: const TextStyle(fontSize: 10, color: Colors.white24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({super.key, required this.report});
  final BudgetReport report;

  @override
  Widget build(BuildContext context) {
    final color = report.percentageUsed >= 1.0 ? Colors.redAccent : (report.percentageUsed > 0.8 ? Colors.orangeAccent : Colors.blueAccent);
    
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
              Text(report.budget.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Spacer(),
              Text(
                '₹${report.remaining.toStringAsFixed(0)} LEFT',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: report.percentageUsed.clamp(0, 1),
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniMetric(label: 'ALLOCATED', value: '₹${report.budget.allocatedAmount.toStringAsFixed(0)}'),
              _MiniMetric(label: 'SPENT', value: '₹${report.spent.toStringAsFixed(0)}'),
              _MiniMetric(label: 'PROJECTED', value: '₹${report.projectedEndOfMonth.toStringAsFixed(0)}', color: color.withValues(alpha: 0.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value, this.color = Colors.white38});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: KnightTokens.label.copyWith(fontSize: 7)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class PlanningInsightTile extends StatelessWidget {
  const PlanningInsightTile({super.key, required this.insight});
  final PlanningInsight insight;

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
