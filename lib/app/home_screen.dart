import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/design_constants.dart';
import '../core/design_system/widgets/entrance_fader.dart';
import '../core/intelligence/knight_context_models.dart';
import '../core/intelligence/knight_context_provider.dart';
import '../core/intelligence/domain/world_models.dart';
import '../core/internal/utils/knight_logger.dart';
import '../core/providers/storage_providers.dart';
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
    try {
      final contextAsync = ref.watch(currentContextNotifierProvider);
      final sessionAsync = ref.watch(authSessionProvider);

      final result = KnightPageScaffold(
        body: Stack(
          children: [
            contextAsync.when(
              data: (knightContext) {
                return RefreshIndicator(
                  onRefresh: () => ref.read(currentContextNotifierProvider.notifier).refresh(),
                  color: DesignColors.accentBlue,
                  backgroundColor: DesignColors.surfaceHigh,
                  child: sessionAsync.when(
                    data: (session) {
                      final isAuthenticated = session?.isAuthenticated ?? false;
                      try {
                        return _HomeScreenContent(
                          knightContext: knightContext,
                          isAuthenticated: isAuthenticated,
                          displayName: session?.displayName ?? 'Guest',
                        );
                      } catch (e, s) {
                        KnightLogger.error('[UI] _HomeScreenContent crash', error: e, stackTrace: s, category: KnightLogCategory.ui);
                        return _HomeScreenError(error: 'Content crash: $e');
                      }
                    },
                    loading: () {
                      return const _HomeScreenLoading();
                    },
                    error: (e, s) {
                      KnightLogger.error('[UI] sessionAsync: ERROR', error: e, stackTrace: s, category: KnightLogCategory.ui);
                      return _HomeScreenError(error: 'Auth status unavailable');
                    },
                  ),
                );
              },
              loading: () {
                return const _HomeScreenLoading();
              },
              error: (e, s) {
                KnightLogger.error('[UI] contextAsync: ERROR', error: e, stackTrace: s, category: KnightLogCategory.ui);
                return _HomeScreenError(error: e.toString());
              },
            ),
            const AmbientVoiceOverlay(),
          ],
        ),
      );
      return result;
    } catch (e, s) {
      KnightLogger.error('[UI] HomeScreen build FATAL', error: e, stackTrace: s, category: KnightLogCategory.ui);
      return Material(
        color: Colors.red,
        child: Center(child: Text('FATAL UI ERROR: $e', style: const TextStyle(color: Colors.white))),
      );
    }
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent({
    required this.knightContext,
    required this.isAuthenticated,
    required this.displayName,
  });

  final KnightContext knightContext;
  final bool isAuthenticated;
  final String displayName;

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
              name: isAuthenticated ? displayName : 'Guest',
              greeting: knightContext.greeting,
              quote: '"Discipline Today, Freedom Tomorrow."',
            ),
          ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 2. Intelligence Feed (Rule-based insights)
          if (isAuthenticated && knightContext.reasoning != null)
            EntranceFader(
              delay: const Duration(milliseconds: 200),
              child: IntelligenceFeedList(reasoning: knightContext.reasoning!),
            )
          else if (!isAuthenticated)
            const EntranceFader(
              delay: Duration(milliseconds: 200),
              child: _GuestPlaceholder(featureName: 'Intelligence Feed'),
            ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 3. Operational Command Summary
          EntranceFader(
            delay: const Duration(milliseconds: 400),
            child: _OperationalCommandCard(
              knightContext: knightContext,
              isAuthenticated: isAuthenticated,
            ),
          ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 4. Focus & Vitality
          EntranceFader(
            delay: const Duration(milliseconds: 600),
            child: _FocusAndVitalityRow(
              knightContext: knightContext,
              isAuthenticated: isAuthenticated,
            ),
          ),
          
          const SizedBox(height: DesignSpacing.l),
          
          // 5. Next Planned Action
          if (isAuthenticated)
            EntranceFader(
              delay: const Duration(milliseconds: 800),
              child: _NextActionCard(knightContext: knightContext),
            )
          else
            const EntranceFader(
              delay: Duration(milliseconds: 800),
              child: _GuestPlaceholder(featureName: 'Daily Planning'),
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
            child: _AtAGlanceStats(
              knightContext: knightContext,
              isAuthenticated: isAuthenticated,
            ),
          ),
          
          if (isAuthenticated && knightContext.worldState.emailThreads.isNotEmpty) ...[
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

class _GuestPlaceholder extends StatelessWidget {
  const _GuestPlaceholder({required this.featureName});
  final String featureName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: DesignRadius.card,
        border: Border.all(color: DesignColors.white05),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded, color: Colors.white24, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  featureName.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white24),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to enable this feature.',
                  style: TextStyle(fontSize: 13, color: Colors.white38),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.auth),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

class _OperationalCommandCard extends StatelessWidget {
  const _OperationalCommandCard({
    required this.knightContext,
    required this.isAuthenticated,
  });
  final KnightContext knightContext;
  final bool isAuthenticated;

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
                  _buildStat(isAuthenticated ? '${knightContext.planning?.dailyPlan.tasks.length ?? 0}' : '-', 'Tasks'),
                  _buildStat(isAuthenticated ? '${knightContext.registeredModules.length}' : '-', 'Hubs'),
                  _buildStat(isAuthenticated ? '${knightContext.recentMemoriesCount}' : '-', 'Memories'),
                ],
              ),
              if (!isAuthenticated) ...[
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Sign in to sync your command center',
                    style: TextStyle(fontSize: 11, color: Colors.white24),
                  ),
                ),
              ],
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
  const _FocusAndVitalityRow({
    required this.knightContext,
    required this.isAuthenticated,
  });
  final KnightContext knightContext;
  final bool isAuthenticated;

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
                          value: isAuthenticated ? knightContext.focusScore : 0,
                          strokeWidth: 8,
                          backgroundColor: DesignColors.white05,
                          color: isAuthenticated ? DesignColors.accentBlue : Colors.white10,
                        ),
                      ),
                      Column(
                        children: [
                          Text(isAuthenticated ? '${(knightContext.focusScore * 100).toInt()}%' : '--', style: Theme.of(context).textTheme.headlineLarge),
                          if (isAuthenticated)
                            Text(knightContext.focusScore > 0.8 ? 'Excellent ↑' : 'Stable', style: const TextStyle(fontSize: 10, color: DesignColors.success))
                          else
                            const Text('Sign In', style: TextStyle(fontSize: 10, color: Colors.white24)),
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
              _buildVitalityTile(Icons.bedtime_rounded, 'Sleep', isAuthenticated ? knightContext.sleepStatus.split(' ').first : '--'),
              const SizedBox(height: 12),
              _buildVitalityTile(Icons.bolt_rounded, 'Energy', isAuthenticated ? knightContext.energyLevel : '--'),
              const SizedBox(height: 12),
              _buildVitalityTile(Icons.mood_rounded, 'Mood', isAuthenticated ? knightContext.mood : '--'),
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
          Icon(icon, size: 16, color: isAuthenticated ? DesignColors.accentBlue : Colors.white24),
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
    if (dailyPlan == null || dailyPlan.tasks.isEmpty) {
      return const SizedBox.shrink();
    }
    final nextTask = dailyPlan.tasks.firstWhere((t) => !t.isCompleted, orElse: () => dailyPlan.tasks.first);

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
                    nextTask.title,
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
  const _AtAGlanceStats({
    required this.knightContext,
    required this.isAuthenticated,
  });
  final KnightContext knightContext;
  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGlanceItem(Icons.directions_run_rounded, 'Steps', isAuthenticated ? knightContext.steps.toString() : '--'),
        _buildGlanceItem(Icons.water_drop_rounded, 'Water', isAuthenticated ? '${knightContext.waterIntake}L' : '--'),
        _buildGlanceItem(Icons.local_fire_department_rounded, 'Calories', isAuthenticated ? knightContext.calories.toString() : '--'),
        _buildGlanceItem(Icons.wb_sunny_rounded, 'Weather', knightContext.weather),
      ],
    );
  }

  Widget _buildGlanceItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: isAuthenticated ? Colors.white24 : Colors.white10),
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 500,
        child: Center(child: CircularProgressIndicator(color: DesignColors.accentBlue)),
      ),
    );
  }
}

class _HomeScreenError extends StatelessWidget {
  const _HomeScreenError({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 500,
        child: Center(
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
        ),
      ),
    );
  }
}
