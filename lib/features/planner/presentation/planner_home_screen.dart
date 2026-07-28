import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/knight_background.dart';
import '../../../core/design_system/widgets/knight_layout.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import '../../../core/design_system/widgets/knight_states.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../domain/planner_models.dart';
import 'widgets/planner_hero.dart';
import 'widgets/calendar_strip.dart';
import 'widgets/task_card.dart';
import 'widgets/goal_card.dart';
import 'widgets/habit_card.dart';
import 'widgets/quick_add_menu.dart';

class PlannerHomeScreen extends ConsumerStatefulWidget {
  const PlannerHomeScreen({super.key});

  @override
  ConsumerState<PlannerHomeScreen> createState() => _PlannerHomeScreenState();
}

class _PlannerHomeScreenState extends ConsumerState<PlannerHomeScreen> {
  final List<PlannerTask> _tasks = PlannerTask.samples;
  final List<PlannerGoal> _goals = PlannerGoal.samples;
  final List<PlannerHabit> _habits = PlannerHabit.samples;

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      floatingActionButton: EntranceFader(
        delay: const Duration(milliseconds: 800),
        child: FloatingActionButton.extended(
          onPressed: () => QuickAddMenu.show(context),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: const Icon(Icons.add_task_rounded),
          label: const Text('New Mission'),
        ),
      ),
      body: KnightBackground(
        child: CustomScrollView(
          clipBehavior: Clip.none,
          slivers: [
            // 1. HERO
            SliverToBoxAdapter(
              child: EntranceFader(
                child: const PlannerHero(
                  mainFocus: 'Finalize Phase 5',
                  completionPercentage: 0.65,
                ),
              ),
            ),

            // 2. CALENDAR
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 100),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: DesignSpacing.l),
                  child: CalendarStrip(),
                ),
              ),
            ),

            // 3. ACTIVE GOALS
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 200),
                child: const KnightSectionHeader(
                  title: 'Core Goals',
                  actionLabel: 'See All',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 250),
                child: SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSpacing.m,
                    ),
                    itemCount: _goals.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: PlannerGoalCard(goal: _goals[i]),
                    ),
                  ),
                ),
              ),
            ),

            // 4. TODAY'S TASKS
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 300),
                child: const KnightSectionHeader(title: 'Immediate Objectives'),
              ),
            ),
            if (_tasks.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: KnightEmptyState(
                  title: 'Clear Horizon',
                  message: 'No immediate tasks found for today.',
                  icon: Icons.done_all_rounded,
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => EntranceFader(
                    delay: Duration(milliseconds: 400 + (i * 50)),
                    child: PlannerTaskCard(
                      task: _tasks[i],
                      onChanged: (val) {
                        // UI Only update
                      },
                    ),
                  ),
                  childCount: _tasks.length,
                ),
              ),

            // 5. HABITS
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 500),
                child: const KnightSectionHeader(title: 'System Routines'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => EntranceFader(
                    delay: Duration(milliseconds: 600 + (i * 50)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PlannerHabitCard(habit: _habits[i]),
                    ),
                  ),
                  childCount: _habits.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}
