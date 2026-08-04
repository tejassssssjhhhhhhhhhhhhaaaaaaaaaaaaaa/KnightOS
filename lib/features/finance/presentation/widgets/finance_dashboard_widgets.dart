import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../../../core/internal/services/greeting_service.dart';

class NetWorthCard extends StatelessWidget {
  const NetWorthCard({super.key, required this.amount, required this.period});
  final double amount;
  final KnightDayPeriod period;

  @override
  Widget build(BuildContext context) {
    final accent = KnightTokens.accent(period);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: accent, opacity: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NET WORTH', style: KnightTokens.label),
          const SizedBox(height: 8),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: KnightTokens.headline.copyWith(color: accent),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniMetric(label: 'CASH', value: '₹0.00'), // To be implemented
              const SizedBox(width: 24),
              _MiniMetric(label: 'DEBT', value: '₹0.00'),
            ],
          ),
        ],
      ),
    );
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
        Text(label, style: KnightTokens.label.copyWith(fontSize: 8)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70)),
      ],
    );
  }
}

class FinanceMetricGrid extends StatelessWidget {
  const FinanceMetricGrid({
    super.key,
    required this.income,
    required this.expenses,
    required this.savings,
  });
  final double income;
  final double expenses;
  final double savings;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _MetricCard(label: 'INCOME', value: '₹${income.toStringAsFixed(0)}', color: Colors.greenAccent),
        _MetricCard(label: 'EXPENSES', value: '₹${expenses.toStringAsFixed(0)}', color: Colors.redAccent),
        _MetricCard(label: 'SAVINGS', value: '₹${savings.toStringAsFixed(0)}', color: Colors.blueAccent),
        _MetricCard(label: 'UTILIZATION', value: '0%', color: Colors.orangeAccent),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: KnightTokens.glass(accentColor: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: KnightTokens.label.copyWith(fontSize: 8)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}

class FinanceHealthIndicator extends StatelessWidget {
  const FinanceHealthIndicator({
    super.key,
    required this.healthScore,
    required this.engineHealth,
    required this.completeness,
    this.needsReviewCount = 0,
    this.onInboxTap,
  });
  final int healthScore;
  final int engineHealth;
  final double completeness;
  final int needsReviewCount;
  final VoidCallback? onInboxTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HealthRow(label: 'FINANCIAL HEALTH', value: healthScore, icon: Icons.favorite_rounded),
        const SizedBox(height: 12),
        _HealthRow(label: 'ENGINE RELIABILITY', value: engineHealth, icon: Icons.memory_rounded),
        const SizedBox(height: 12),
        _HealthRow(label: 'DATA COMPLETENESS', value: (completeness * 100).toInt(), icon: Icons.inventory_rounded),
        if (needsReviewCount > 0) ...[
          const SizedBox(height: 24),
          InkWell(
            onTap: onInboxTap,
            borderRadius: KnightTokens.radiusCard,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.1),
                borderRadius: KnightTokens.radiusCard,
                border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inbox_rounded, size: 16, color: Colors.orangeAccent),
                  const SizedBox(width: 12),
                  Text(
                    '$needsReviewCount TASKS NEED REVIEW',
                    style: KnightTokens.label.copyWith(color: Colors.orangeAccent),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.orangeAccent),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow({required this.label, required this.value, required this.icon});
  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = value > 80 ? Colors.greenAccent : (value > 50 ? Colors.orangeAccent : Colors.redAccent);
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.5)),
        const SizedBox(width: 12),
        Text(label, style: KnightTokens.label.copyWith(color: Colors.white38)),
        const Spacer(),
        Text('$value%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key, required this.insight});
  final String insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              insight,
              style: KnightTokens.subheadline.copyWith(fontSize: 13, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
