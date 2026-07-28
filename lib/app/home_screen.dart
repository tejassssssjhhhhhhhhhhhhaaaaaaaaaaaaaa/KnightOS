import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/design_constants.dart';
import '../core/design_system/widgets/entrance_fader.dart';
import '../core/intelligence/providers/intelligence_providers.dart';
import '../core/intelligence/domain/memory_category.dart';
import '../core/intelligence/engines/memory_retrieval_engine.dart';
import '../core/router/app_routes.dart';
import 'widgets/knight_page_scaffold.dart';
import 'widgets/home/mission_control_hero.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrieval = ref.watch(memoryRetrievalEngineProvider);

    return KnightPageScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // 1. Hero Greeting
            EntranceFader(
              child: MissionControlHero(
                name: 'Tejas',
                quote: '"Discipline Today, Freedom Tomorrow."',
              ),
            ),
            
            const SizedBox(height: DesignSpacing.l),
            
            // 2. Operational Command Summary
            EntranceFader(
              delay: const Duration(milliseconds: 200),
              child: _OperationalCommandCard(retrieval: retrieval),
            ),
            
            const SizedBox(height: DesignSpacing.l),
            
            // 3. Focus Score & Vitality
            EntranceFader(
              delay: const Duration(milliseconds: 400),
              child: const _FocusAndVitalityRow(),
            ),
            
            const SizedBox(height: DesignSpacing.l),
            
            // 4. Today's Priority
            EntranceFader(
              delay: const Duration(milliseconds: 600),
              child: _PriorityCard(retrieval: retrieval),
            ),
            
            const SizedBox(height: DesignSpacing.l),
            
            // 5. At a Glance Stats
            EntranceFader(
              delay: const Duration(milliseconds: 800),
              child: const _AtAGlanceStats(),
            ),
            
            const SizedBox(height: 140), // Navigation Spacing
          ],
        ),
      ),
    );
  }
}

class _OperationalCommandCard extends StatelessWidget {
  const _OperationalCommandCard({required this.retrieval});
  final MemoryRetrievalEngine retrieval;

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
                  _buildStat(BookCategory.ambitions, 'Tasks'),
                  _buildStat(null, 'Questions', isTotal: true),
                  _buildStat(BookCategory.history, 'Events'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(BookCategory? category, String label, {bool isTotal = false}) {
    final Future<int> countFuture = isTotal 
      ? retrieval.search('').then((list) => list.length)
      : retrieval.getByCategory(category!).then((list) => list.length);

    return FutureBuilder<int>(
      future: countFuture,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Column(
          children: [
            Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
          ],
        );
      },
    );
  }
}

class _FocusAndVitalityRow extends StatelessWidget {
  const _FocusAndVitalityRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Focus Score (Large)
        Expanded(
          flex: 4,
          child: InkWell(
            onTap: () => context.go(AppRoutes.work),
            borderRadius: DesignRadius.card,
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
                        const SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: 0.87,
                            strokeWidth: 8,
                            backgroundColor: DesignColors.white05,
                            color: DesignColors.accentBlue,
                          ),
                        ),
                        Column(
                          children: [
                            Text('87%', style: Theme.of(context).textTheme.headlineLarge),
                            const Text('Excellent ↑', style: TextStyle(fontSize: 10, color: DesignColors.success)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Vitality Stats (Small Column)
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildVitalityTile(context, Icons.bedtime_rounded, 'Sleep', '6h 45m', AppRoutes.health),
              const SizedBox(height: 12),
              _buildVitalityTile(context, Icons.bolt_rounded, 'Energy', 'High', AppRoutes.health),
              const SizedBox(height: 12),
              _buildVitalityTile(context, Icons.mood_rounded, 'Mood', 'Focused', AppRoutes.health),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalityTile(BuildContext context, IconData icon, String label, String value, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
      ),
    );
  }
}

class _PriorityCard extends StatelessWidget {
  const _PriorityCard({required this.retrieval});
  final dynamic retrieval;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(AppRoutes.mission),
      borderRadius: DesignRadius.card,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TODAY\'S PRIORITY', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FutureBuilder<List>(
                      future: retrieval.getByCategory(BookCategory.ambitions),
                      builder: (context, snapshot) {
                        final items = snapshot.data ?? [];
                        final priority = items.isNotEmpty ? items.first.summary : 'Define your next mission';
                        return Text(
                          priority,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        );
                      }
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AtAGlanceStats extends StatelessWidget {
  const _AtAGlanceStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGlanceItem(context, Icons.directions_run_rounded, 'Steps', '8,432', AppRoutes.health),
        _buildGlanceItem(context, Icons.water_drop_rounded, 'Water', '1.8 L', AppRoutes.health),
        _buildGlanceItem(context, Icons.local_fire_department_rounded, 'Calories', '1,200', AppRoutes.health),
        _buildGlanceItem(context, Icons.menu_book_rounded, 'Study', '1h 20m', AppRoutes.work),
      ],
    );
  }

  Widget _buildGlanceItem(BuildContext context, IconData icon, String label, String value, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.white24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white24)),
        ],
      ),
    );
  }
}
