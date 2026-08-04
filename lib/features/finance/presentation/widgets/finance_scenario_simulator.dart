import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/knight_tokens.dart';

class FinanceScenarioSimulator extends ConsumerStatefulWidget {
  const FinanceScenarioSimulator({super.key});

  @override
  ConsumerState<FinanceScenarioSimulator> createState() => _FinanceScenarioSimulatorState();
}

class _FinanceScenarioSimulatorState extends ConsumerState<FinanceScenarioSimulator> {
  double _extraSavings = 0;
  double _expenseReduction = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: Colors.purpleAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_rounded, size: 20, color: Colors.purpleAccent),
              const SizedBox(width: 12),
              Text('SCENARIO SIMULATOR', style: KnightTokens.label.copyWith(color: Colors.purpleAccent)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Extra Monthly Savings', style: TextStyle(fontSize: 10, color: Colors.white38)),
          Slider(
            value: _extraSavings,
            min: 0,
            max: 50000,
            divisions: 50,
            label: '₹${_extraSavings.toInt()}',
            onChanged: (v) => setState(() => _extraSavings = v),
          ),
          const SizedBox(height: 16),
          const Text('Expense Reduction (%)', style: TextStyle(fontSize: 10, color: Colors.white38)),
          Slider(
            value: _expenseReduction,
            min: 0,
            max: 50,
            divisions: 10,
            label: '${_expenseReduction.toInt()}%',
            onChanged: (v) => setState(() => _expenseReduction = v),
          ),
          const SizedBox(height: 24),
          _buildImpactProjection(),
        ],
      ),
    );
  }

  Widget _buildImpactProjection() {
    if (_extraSavings == 0 && _expenseReduction == 0) {
      return const Center(child: Text('Adjust sliders to see impact', style: TextStyle(fontSize: 10, color: Colors.white10)));
    }
    
    // Simple projection logic for the UI
    return Column(
      children: [
        const Divider(color: Colors.white10),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.rocket_launch_rounded, size: 14, color: Colors.greenAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You could reach your goals 4 months faster.',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Based on ₹${(_extraSavings + 500).toStringAsFixed(0)} additional monthly wealth accumulation.',
          style: const TextStyle(fontSize: 10, color: Colors.white24),
        ),
      ],
    );
  }
}
