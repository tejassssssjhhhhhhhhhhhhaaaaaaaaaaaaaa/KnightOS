import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/design_system/design_constants.dart';
import '../controllers/achievement_vault_controller.dart';
import '../widgets/explainable_insight_card.dart';
import '../../domain/career_models.dart';

class AchievementVaultScreen extends ConsumerWidget {
  const AchievementVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(achievementVaultControllerProvider);

    return KnightPageScaffold(
      title: 'Achievement Vault',
      showBackButton: true,
      body: stateAsync.when(
        data: (state) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ExplainableInsightCard(
                      title: 'Vault Intelligence',
                      recommendation: 'Your certification frequency has increased by 40%.',
                      evidenceSummary: 'Based on 4 new verified credentials in the last 6 months.',
                      reasoning: 'Consistent learning spikes are highly correlated with successful senior-to-lead transitions.',
                      confidence: 0.91,
                      suggestedAction: 'Export your verified portfolio for review.',
                    ),
                    const SizedBox(height: 32),
                    _buildSearchBar(ref, state),
                  ],
                ),
              ),
            ),
            if (state.achievements.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text('No verified achievements yet.', style: TextStyle(color: DesignColors.secondary)),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _AchievementCard(achievement: state.achievements[index]),
                    childCount: state.achievements.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref, AchievementVaultState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.white10),
      ),
      child: TextField(
        onChanged: (v) => ref.read(achievementVaultControllerProvider.notifier).search(v),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          icon: Icon(Icons.search_rounded, color: DesignColors.secondary, size: 20),
          hintText: 'Search the vault...',
          hintStyle: TextStyle(color: DesignColors.secondary),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});
  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryIcon(),
          const Spacer(),
          Text(
            achievement.title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMMM yyyy').format(achievement.date).toUpperCase(),
            style: const TextStyle(color: DesignColors.secondary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.verified_rounded, size: 12, color: DesignColors.success),
              const SizedBox(width: 4),
              const Text('IMMUTABLE', style: TextStyle(color: DesignColors.success, fontSize: 8, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.link_rounded, size: 12, color: DesignColors.white20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData icon;
    Color color;
    switch (achievement.category) {
      case 'certification': 
        icon = Icons.verified_user_rounded; 
        color = DesignColors.success;
        break;
      case 'award': 
        icon = Icons.emoji_events_rounded; 
        color = DesignColors.warning;
        break;
      case 'project_success': 
        icon = Icons.rocket_launch_rounded; 
        color = DesignColors.accentCyan;
        break;
      default: 
        icon = Icons.flag_rounded; 
        color = DesignColors.career;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
