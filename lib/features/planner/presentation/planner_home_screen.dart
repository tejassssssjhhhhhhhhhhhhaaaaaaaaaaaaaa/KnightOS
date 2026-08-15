import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/knight_context_provider.dart';
import '../../../core/intelligence/knight_context_models.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/router/app_routes.dart';

class PlannerHomeScreen extends ConsumerWidget {
  const PlannerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);
    final db = ref.watch(knightDatabaseProvider);

    return KnightPageScaffold(
      title: 'Planner',
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.auto_awesome_rounded, size: 20, color: DesignColors.accentBlue),
          onPressed: () => _optimizeSchedule(context, ref),
          tooltip: 'Optimize Schedule',
        ),
      ],
      body: contextAsync.when(
        data: (knightContext) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDailyOverview(knightContext),
              const SizedBox(height: 32),
              
              _GoalDecompositionCard(),
              
              const SizedBox(height: 40),
              const Text('UPCOMING COMMITMENTS', style: KnightTokens.label),
              const SizedBox(height: 16),
              _buildCommitments(knightContext),
              
              const SizedBox(height: 40),
              const Text('ACTIVE TASKS', style: KnightTokens.label),
              const SizedBox(height: 16),
              _buildTasks(db),
              const SizedBox(height: 140),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _optimizeSchedule(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Knight is calculating optimal paths...')),
    );
    
    final service = ref.read(planningServiceProvider);
    final result = await service.generateDailyPlan(featureModules: []);
    
    if (context.mounted) {
       showDialog(
         context: context,
         builder: (context) => AlertDialog(
           backgroundColor: DesignColors.surfaceHigh,
           title: const Text('Optimization Result'),
           content: Text('Knight suggests adding ${result.suggestedTasks.length} tasks to improve your current momentum.'),
           actions: [
             TextButton(onPressed: () => Navigator.pop(context), child: const Text('DISMISS')),
             FilledButton(
               onPressed: () {
                 Navigator.pop(context);
                 context.push(AppRoutes.knight);
               }, 
               child: const Text('DISCUSS'),
             ),
           ],
         ),
       );
    }
  }

  Widget _buildDailyOverview(KnightContext context) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.accentBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.accentBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny_rounded, color: Colors.amberAccent, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('EEEE, MMM dd').format(now), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text(
                  context.upcomingEvents.isNotEmpty 
                      ? '${context.upcomingEvents.length} items scheduled.' 
                      : 'Schedule is clear. Ready for deep work.', 
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommitments(KnightContext context) {
    if (context.worldState.calendarEvents.isEmpty) {
      return _buildEmptyState('No upcoming events found.');
    }

    return Column(
      children: context.worldState.calendarEvents.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: const Icon(Icons.calendar_today_rounded, color: DesignColors.accentBlue, size: 18),
          title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          trailing: Text(DateFormat('HH:mm').format(e.startTime), style: const TextStyle(color: Colors.white10, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      )).toList(),
    );
  }

  Widget _buildTasks(KnightDatabase db) {
     return FutureBuilder<List<TaskData>>(
       future: db.select(db.taskTable).get(),
       builder: (context, snapshot) {
         if (!snapshot.hasData || snapshot.data!.isEmpty) {
           return _buildEmptyState('No active missions.');
         }
         return Column(
           children: snapshot.data!.map((t) => Container(
             margin: const EdgeInsets.only(bottom: 12),
             decoration: BoxDecoration(
               color: Colors.white.withValues(alpha: 0.02),
               borderRadius: BorderRadius.circular(16),
               border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
             ),
             child: ListTile(
               leading: Icon(t.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, 
                 color: t.isCompleted ? DesignColors.success : Colors.white10, size: 20),
               title: Text(t.title, style: TextStyle(
                 fontSize: 14,
                 decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                 color: t.isCompleted ? Colors.white24 : Colors.white70,
               )),
             ),
           )).toList(),
         );
       },
     );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Icon(Icons.event_note_rounded, size: 40, color: DesignColors.white10),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.white12, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _GoalDecompositionCard extends StatefulWidget {
  @override
  State<_GoalDecompositionCard> createState() => _GoalDecompositionCardState();
}

class _GoalDecompositionCardState extends State<_GoalDecompositionCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Colors.amberAccent, size: 16),
              const SizedBox(width: 8),
              Text('GOAL DECOMPOSITION', style: KnightTokens.label.copyWith(color: Colors.amberAccent)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('What is your high-level objective?', style: TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'e.g. Plan a 2-week trip to Japan',
              hintStyle: const TextStyle(color: Colors.white10),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Consumer(
              builder: (context, ref, _) => FilledButton(
                onPressed: _isProcessing ? null : () => _decompose(ref),
                child: _isProcessing 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : const Text('DECOMPOSE WITH AI'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _decompose(WidgetRef ref) async {
    if (_controller.text.isEmpty) return;
    
    setState(() => _isProcessing = true);
    HapticFeedback.selectionClick();
    
    try {
      final service = ref.read(planningServiceProvider);
      final plan = await service.createStrategicPlan(_controller.text);
      
      if (mounted) {
        _controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generated "${plan.title}" with ${plan.tasks.length} sub-tasks.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
