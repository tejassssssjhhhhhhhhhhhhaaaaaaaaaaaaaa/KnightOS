import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/knight_tokens.dart';
import '../core/design_system/widgets/entrance_fader.dart';
import '../core/intelligence/knight_context_models.dart';
import '../core/intelligence/knight_context_provider.dart';
import '../core/intelligence/providers/intelligence_providers.dart';
import '../core/intelligence/services/priority_engine.dart';
import 'widgets/knight_page_scaffold.dart';
import 'widgets/home/perception_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      body: contextAsync.when(
        data: (knightContext) => _HomeScreenContent(knightContext: knightContext),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Context Error: $e')),
      ),
    );
  }
}

class _HomeScreenContent extends ConsumerWidget {
  const _HomeScreenContent({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorities = ref.watch(priorityEngineProvider).calculatePriorities(knightContext);
    final topPriority = priorities.isNotEmpty ? priorities.first : null;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 140),
          
          const PerceptionWidget(),

          // 1. Standardized Greeting (P0-4)
          EntranceFader(
            child: Text(
              knightContext.greeting,
              style: KnightTokens.headline,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // 2. Primary Priority Slot (P0-11: "What matters right now?")
          if (topPriority != null)
            EntranceFader(
              delay: const Duration(milliseconds: 200),
              child: _PriorityFocusSlot(item: topPriority),
            ),
          
          const SizedBox(height: 80),

          // 3. Today's Context Snapshot
          const EntranceFader(
            delay: Duration(milliseconds: 400),
            child: Text('SYSTEM SNAPSHOT', style: KnightTokens.label),
          ),
          const SizedBox(height: 20),
          _SnapshotStrip(context: knightContext),

          const SizedBox(height: 140),
        ],
      ),
    );
  }
}

class _PriorityFocusSlot extends StatelessWidget {
  const _PriorityFocusSlot({required this.item});
  final PriorityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.1),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: item.color.withValues(alpha: 0.2), width: 0.5),
        boxShadow: KnightTokens.glow(item.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, color: item.color, size: 20),
              const SizedBox(width: 12),
              Text(item.title.toUpperCase(), style: KnightTokens.label.copyWith(color: item.color)),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            item.description, 
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.4, color: Colors.white),
          ),
          const SizedBox(height: 40),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: item.color,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: KnightTokens.radiusPill),
            ),
            child: const Text('ACT NOW', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
          ),
        ],
      ),
    );
  }
}

class _SnapshotStrip extends StatelessWidget {
  const _SnapshotStrip({required this.context});
  final KnightContext context;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _SnapshotCard(label: 'FINANCE', value: '₹${this.context.totalBalance.toInt()}', icon: Icons.account_balance_wallet_rounded),
          const SizedBox(width: 16),
          _SnapshotCard(label: 'HEALTH', value: '${this.context.steps} Steps', icon: Icons.directions_run_rounded),
          const SizedBox(width: 16),
          _SnapshotCard(label: 'MISSIONS', value: '2 ACTIVE', icon: Icons.flag_rounded),
        ],
      ),
    );
  }
}

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(28),
      decoration: KnightTokens.glass(accentColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white24),
          const SizedBox(height: 24),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: KnightTokens.label.copyWith(fontSize: 8, color: Colors.white10)),
        ],
      ),
    );
  }
}
