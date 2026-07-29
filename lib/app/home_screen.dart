import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/design_constants.dart';
import '../core/design_system/widgets/entrance_fader.dart';
import '../core/intelligence/knight_context_models.dart';
import '../core/intelligence/knight_context_provider.dart';
import '../core/intelligence/domain/world_models.dart';
import '../core/router/app_routes.dart';
import 'widgets/knight_page_scaffold.dart';
import 'widgets/home/mission_control_hero.dart';
import 'widgets/home/intelligence_feed.dart';
import 'widgets/home/quick_actions.dart';
import 'widgets/home/ambient_voice_overlay.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => ref.read(currentContextNotifierProvider.notifier).refresh(),
            color: DesignColors.accentBlue,
            backgroundColor: DesignColors.surfaceHigh,
            child: contextAsync.when(
              data: (knightContext) => _HomeScreenContent(knightContext: knightContext),
              loading: () => const _HomeScreenLoading(),
              error: (e, s) => _HomeScreenError(error: e.toString()),
            ),
          ),
          const AmbientVoiceOverlay(),
        ],
      ),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(DesignSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // 1. Hero Greeting
          EntranceFader(
            child: MissionControlHero(
              name: 'Tejas',
              greeting: knightContext.greeting,
              quote: '"Discipline Today, Freedom Tomorrow."',
            ),
          ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 2. Intelligence Feed (Rule-based insights)
          if (knightContext.reasoning != null)
            EntranceFader(
              delay: const Duration(milliseconds: 200),
              child: IntelligenceFeedList(reasoning: knightContext.reasoning!),
            ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 3. Operational Command Summary
          EntranceFader(
            delay: const Duration(milliseconds: 400),
            child: _OperationalCommandCard(knightContext: knightContext),
          ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 4. Focus & Vitality
          EntranceFader(
            delay: const Duration(milliseconds: 600),
            child: _FocusAndVitalityRow(knightContext: knightContext),
          ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 5. Next Planned Action
          EntranceFader(
            delay: const Duration(milliseconds: 800),
            child: _NextActionCard(knightContext: knightContext),
          ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 6. Quick Actions
          EntranceFader(
            delay: const Duration(milliseconds: 1000),
            child: const QuickActionsPanel(),
          ),

          const SizedBox(height: DesignSpacing.l),
          
          // 7. At a Glance (World Perception)
          EntranceFader(
            delay: const Duration(milliseconds: 1200),
            child: _AtAGlanceStats(knightContext: knightContext),
          ),
          
          if (knightContext.worldState.emailThreads.isNotEmpty) ...[
            const SizedBox(height: DesignSpacing.l),
            EntranceFader(
              delay: const Duration(milliseconds: 1400),
              child: _RecentEmailsCard(threads: knightContext.worldState.emailThreads),
            ),
          ],
          
          const SizedBox(height: 140),
        ],
      ),
    );
  }
}

class _OperationalCommandCard extends StatelessWidget {
  const _OperationalCommandCard({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(AppRoutes.myPlace),
      borderRadius: DesignRadius.card,
      child: Card(
        color: DesignColors.surfaceHigh,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OPERATIONAL COMMAND',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 2.0),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('${knightContext.planning?.dailyPlan.tasks.length ?? 0}', 'Tasks'),
                  _buildStat('${knightContext.registeredModules.length}', 'Hubs'),
                  _buildStat('${knightContext.recentMemoriesCount}', 'Memories'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
      ],
    );
  }
}

class _FocusAndVitalityRow extends StatelessWidget {
  const _FocusAndVitalityRow({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('FOCUS SCORE', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: knightContext.focusScore,
                          strokeWidth: 8,
                          backgroundColor: DesignColors.white05,
                          color: DesignColors.accentBlue,
                        ),
                      ),
                      Column(
                        children: [
                          Text('${(knightContext.focusScore * 100).toInt()}%', style: Theme.of(context).textTheme.headlineLarge),
                          Text(knightContext.focusScore > 0.8 ? 'Excellent ↑' : 'Stable', style: const TextStyle(fontSize: 10, color: DesignColors.success)),
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
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildVitalityTile(Icons.bedtime_rounded, 'Sleep', knightContext.sleepStatus.split(' ').first),
              const SizedBox(height: 12),
              _buildVitalityTile(Icons.bolt_rounded, 'Energy', knightContext.energyLevel),
              const SizedBox(height: 12),
              _buildVitalityTile(Icons.mood_rounded, 'Mood', knightContext.mood),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalityTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: DesignColors.accentBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.white24)),
                Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextActionCard extends StatelessWidget {
  const _NextActionCard({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context) {
    final dailyPlan = knightContext.planning?.dailyPlan;
    final nextTask = dailyPlan?.tasks.firstWhere((t) => !t.isCompleted, orElse: () => dailyPlan.tasks.first);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NEXT PLANNED ACTION', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.radio_button_unchecked_rounded, color: DesignColors.accentBlue),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    nextTask?.title ?? 'No scheduled actions',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.play_circle_outline_rounded, color: Colors.white24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AtAGlanceStats extends StatelessWidget {
  const _AtAGlanceStats({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGlanceItem(Icons.directions_run_rounded, 'Steps', knightContext.steps.toString()),
        _buildGlanceItem(Icons.water_drop_rounded, 'Water', '${knightContext.waterIntake}L'),
        _buildGlanceItem(Icons.local_fire_department_rounded, 'Calories', knightContext.calories.toString()),
        _buildGlanceItem(Icons.wb_sunny_rounded, 'Weather', knightContext.weather),
      ],
    );
  }

  Widget _buildGlanceItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.white24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white24)),
      ],
    );
  }
}

class _RecentEmailsCard extends StatelessWidget {
  const _RecentEmailsCard({required this.threads});
  final List<EmailThread> threads;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RECENT INTELLIGENCE (MAIL)', style: Theme.of(context).textTheme.labelLarge),
                const Icon(Icons.mail_outline_rounded, color: DesignColors.accentBlue, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            ...threads.take(2).map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: t.isUnread ? DesignColors.accentBlue : Colors.white10,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.subject,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${t.sender} • ${t.snippet}',
                          style: const TextStyle(fontSize: 11, color: Colors.white38),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenLoading extends StatelessWidget {
  const _HomeScreenLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: DesignColors.accentBlue));
  }
}

class _HomeScreenError extends StatelessWidget {
  const _HomeScreenError({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: DesignColors.error, size: 48),
            const SizedBox(height: 16),
            Text('Perception Error', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}
