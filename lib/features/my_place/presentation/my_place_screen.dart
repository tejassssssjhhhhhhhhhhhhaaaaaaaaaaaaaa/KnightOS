import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/router/app_routes.dart';

class MyPlaceScreen extends ConsumerWidget {
  const MyPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildHubGrid(context),
            const SizedBox(height: 40),
            _buildAtAGlance(context),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shield_rounded, color: DesignColors.accentPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Personal Hub',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your Life. Organized.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const CircleAvatar(
          radius: 20,
          backgroundColor: DesignColors.surfaceHigh,
          child: Text('T', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildHubGrid(BuildContext context) {
    final items = [
      _HubItem('Life Atlas', 'Your timeline & memories', Icons.history_rounded, DesignColors.accentPurple, AppRoutes.lifeAtlas),
      _HubItem('Health & Fitness', 'Track, improve and evolve', Icons.favorite_outline_rounded, DesignColors.health, AppRoutes.health),
      _HubItem('Finance', 'Track, plan and grow', Icons.account_balance_wallet_outlined, DesignColors.finance, AppRoutes.finance),
      _HubItem('Career', 'Skills, goals and growth', Icons.work_outline_rounded, DesignColors.career, AppRoutes.work),
      _HubItem('Knowledge', 'Learn, capture and apply', Icons.psychology_outlined, DesignColors.knowledge, AppRoutes.knowledgeVault),
      _HubItem('Travel', 'Explore, track and remember', Icons.flight_takeoff_rounded, DesignColors.travel, AppRoutes.travelHome),
      _HubItem('Documents', 'Secure, store, access anywhere', Icons.description_outlined, Colors.orangeAccent, AppRoutes.documents),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Card(
          color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
          child: InkWell(
            onTap: () => context.push(item.route),
            borderRadius: DesignRadius.card,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: item.color, size: 24),
                  const Spacer(),
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.white24, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAtAGlance(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AT A GLANCE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 2.0),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGlanceStat(Icons.directions_run_rounded, '8,432', 'Steps'),
            _buildGlanceStat(Icons.water_drop_rounded, '1.8 L', 'Water'),
            _buildGlanceStat(Icons.local_fire_department_rounded, '1,200', 'Calories'),
            _buildGlanceStat(Icons.bedtime_rounded, '6h 45m', 'Sleep'),
          ],
        ),
      ],
    );
  }

  Widget _buildGlanceStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: DesignColors.accentBlue),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
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
