import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/intelligence/knight_context_provider.dart';
import '../../../core/intelligence/knight_context_models.dart';

class MyPlaceScreen extends ConsumerWidget {
  const MyPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      body: contextAsync.when(
        data: (knightContext) => SingleChildScrollView(
          padding: const EdgeInsets.all(DesignSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, knightContext),
              const SizedBox(height: 32),
              
              // Relationship Spotlight (Connected Space)
              _RelationshipSpotlight(knightContext: knightContext),
              
              const SizedBox(height: 32),
              const Text('KNOWLEDGE BOOKS', style: KnightTokens.label),
              const SizedBox(height: 16),
              _buildHubGrid(context),
              
              const SizedBox(height: 40),
              _buildAtAGlance(context, knightContext),
              const SizedBox(height: 140),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Context Error: $e')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, KnightContext knightContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Hub',
              style: KnightTokens.headline.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 4),
            const Text(
              'Unified personal environment active.',
              style: KnightTokens.subheadline,
            ),
          ],
        ),
        const Icon(Icons.blur_on_rounded, color: Colors.white10, size: 32),
      ],
    );
  }

  Widget _buildHubGrid(BuildContext context) {
    final items = [
      _HubItem('Life Atlas', 'Timeline & Memories', Icons.history_rounded, DesignColors.accentPurple, AppRoutes.lifeAtlas),
      _HubItem('Data Hub', 'Infrastructure & Sync', Icons.hub_rounded, DesignColors.accentBlue, AppRoutes.importCenter),
      _HubItem('Planner', 'Ambitions & Future', Icons.task_alt_rounded, Colors.greenAccent, AppRoutes.planner),
      _HubItem('Skills', 'Vault & Expertise', Icons.psychology_outlined, DesignColors.knowledge, AppRoutes.knowledgeVault),
      _HubItem('Finance', 'Capital & Growth', Icons.account_balance_wallet_outlined, DesignColors.finance, AppRoutes.finance),
      _HubItem('Health', 'Vitality & Metrics', Icons.favorite_outline_rounded, DesignColors.health, AppRoutes.health),
      _HubItem('Travel', 'Journeys & Maps', Icons.flight_takeoff_rounded, DesignColors.travel, AppRoutes.travelHome),
      _HubItem('Career', 'Mission & Impact', Icons.work_outline_rounded, DesignColors.career, AppRoutes.career),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () => context.push(item.route),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Icon(item.icon, color: item.color.withValues(alpha: 0.5), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      Text(item.subtitle, style: const TextStyle(fontSize: 9, color: Colors.white24), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAtAGlance(BuildContext context, KnightContext knightContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('REAL-TIME STATUS', style: KnightTokens.label),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGlanceStat(context, Icons.directions_run_rounded, '${knightContext.steps}', 'Steps', AppRoutes.health),
              _buildGlanceStat(context, Icons.water_drop_rounded, '${knightContext.waterIntake}L', 'Water', AppRoutes.health),
              _buildGlanceStat(context, Icons.account_balance_wallet_rounded, '₹${knightContext.totalBalance.toInt()}', 'Finance', AppRoutes.finance),
              _buildGlanceStat(context, Icons.bolt_rounded, '98%', 'System', AppRoutes.providerHealth),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlanceStat(BuildContext context, IconData icon, String value, String label, String route) {
    return InkWell(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.white24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _RelationshipSpotlight extends StatelessWidget {
  const _RelationshipSpotlight({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignColors.accentPurple.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.accentPurple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: DesignColors.accentPurple, size: 16),
              const SizedBox(width: 8),
              Text('INTELLIGENT SPOTLIGHT', style: KnightTokens.label.copyWith(color: DesignColors.accentPurple)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'High correlation detected between late-night work sessions and reduced physical activity the following day.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _Tag(label: 'WORK', color: Colors.blueAccent),
              const SizedBox(width: 8),
              _Tag(label: 'HEALTH', color: Colors.pinkAccent),
              const Spacer(),
              TextButton(
                onPressed: () => context.push(AppRoutes.knight),
                child: const Text('DISCUSS WITH KNIGHT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _HubItem {
  const _HubItem(this.title, this.subtitle, this.icon, this.color, this.route);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}
