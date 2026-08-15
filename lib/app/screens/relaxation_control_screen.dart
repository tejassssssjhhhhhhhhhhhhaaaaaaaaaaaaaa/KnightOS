import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:knight_os/core/intelligence/services/sync_task_service.dart';
import 'package:drift/drift.dart' hide Column;
import '../../core/design_system/knight_tokens.dart';
import '../../core/providers/relaxation_mode_provider.dart';
import '../../core/providers/database_provider.dart';
import '../../core/internal/storage/drift/knight_database.dart';
import '../../core/intelligence/services/background_orchestrator.dart';
import '../widgets/knight_page_scaffold.dart';

class RelaxationControlScreen extends ConsumerWidget {
  const RelaxationControlScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRelaxed = ref.watch(relaxationModeProvider);
    final workerState = ref.watch(syncTaskServiceProvider);

    return KnightPageScaffold(
      title: 'Relaxation Mode',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(context, ref, isRelaxed, workerState),
            const SizedBox(height: 40),
            if (isRelaxed) ...[
              _buildQueueVisualization(ref),
              const SizedBox(height: 32),
              _buildLastCycleInfo(ref),
              const SizedBox(height: 40),
              _buildSafeBoundariesCard(),
            ] else 
              _buildReadyToRestCard(context, ref),
            
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, WidgetRef ref, bool isRelaxed, WorkerState workerState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isRelaxed ? Colors.blueAccent.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isRelaxed ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isRelaxed ? Icons.nightlight_round : Icons.wb_sunny_rounded,
            size: 48,
            color: isRelaxed ? Colors.blueAccent : Colors.amberAccent,
          ),
          const SizedBox(height: 24),
          Text(
            isRelaxed ? 'RELAXATION MODE ACTIVE' : 'RELAXATION MODE INACTIVE',
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            isRelaxed 
              ? 'Knight OS is handling safe maintenance while you rest.' 
              : 'Activate to allow safe background processing.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 32),
          Switch(
            value: isRelaxed, 
            onChanged: (val) => _handleToggle(ref, val),
            activeColor: Colors.blueAccent,
          ),
          if (isRelaxed) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: workerState == WorkerState.processing ? Colors.greenAccent : Colors.white10,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  workerState == WorkerState.processing ? 'ENGINE RUNNING' : 'ENGINE IDLE',
                  style: TextStyle(
                    fontSize: 10, 
                    fontWeight: FontWeight.bold, 
                    color: workerState == WorkerState.processing ? Colors.greenAccent : Colors.white10,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleToggle(WidgetRef ref, bool value) async {
    HapticFeedback.mediumImpact();
    await ref.read(relaxationModeProvider.notifier).set(value);
    
    if (value) {
      // Trigger a maintenance cycle immediately when entering relaxation mode
      await BackgroundOrchestrator.runMaintenance();
    }
  }

  Widget _buildQueueVisualization(WidgetRef ref) {
    final tasksAsync = ref.watch(_recentTasksProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AUTONOMOUS WORK QUEUE', style: KnightTokens.label),
        const SizedBox(height: 16),
        tasksAsync.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No pending tasks found.', style: TextStyle(color: Colors.white10)),
              );
            }
            return Column(
              children: tasks.map((t) => _TaskTile(task: t)).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('Error loading queue: $e', style: const TextStyle(color: Colors.redAccent)),
        ),
      ],
    );
  }

  Widget _buildLastCycleInfo(WidgetRef ref) {
    final lastTaskAsync = ref.watch(_lastCompletedTaskProvider);

    return lastTaskAsync.when(
      data: (task) {
        if (task == null) return const SizedBox.shrink();
        final time = DateFormat('MMM dd, HH:mm').format(task.updatedAt);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'LAST OPTIMIZATION CYCLE: $time',
            style: const TextStyle(fontSize: 9, color: Colors.white12, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSafeBoundariesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SAFETY BOUNDARIES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          SizedBox(height: 16),
          _SafetyItem(label: 'NO external messages will be sent.'),
          _SafetyItem(label: 'NO financial transfers will occur.'),
          _SafetyItem(label: 'NO user data will be deleted.'),
          _SafetyItem(label: 'Critical alerts will still notify you.'),
        ],
      ),
    );
  }

  Widget _buildReadyToRestCard(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text('PREPARE FOR REST', style: KnightTokens.label),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _handleToggle(ref, true),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: KnightTokens.glass(accentColor: Colors.blueAccent),
            child: const Row(
              children: [
                Icon(Icons.king_bed_rounded, color: Colors.blueAccent),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Activate Sleep Shift', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Silences work surfaces and begins deep sync.', style: TextStyle(fontSize: 11, color: Colors.white38)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.white10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});
  final SyncTask task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.01),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _getStatusIcon(task.status),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.taskType.replaceAll('_', ' ').toUpperCase(), 
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                Text(task.providerId, style: const TextStyle(fontSize: 9, color: Colors.white10)),
              ],
            ),
          ),
          Text(
            DateFormat('HH:mm').format(task.updatedAt),
            style: const TextStyle(fontSize: 9, color: Colors.white10),
          ),
        ],
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'completed': return const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 14);
      case 'processing': return const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1));
      case 'failed': return const Icon(Icons.error_rounded, color: Colors.redAccent, size: 14);
      default: return const Icon(Icons.schedule_rounded, color: Colors.white10, size: 14);
    }
  }
}

class _SafetyItem extends StatelessWidget {
  const _SafetyItem({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.shield_rounded, size: 12, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60)),
        ],
      ),
    );
  }
}

final _recentTasksProvider = FutureProvider<List<SyncTask>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  return (db.select(db.syncTaskQueueTable)
    ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
    ..limit(20)).get();
});

final _lastCompletedTaskProvider = FutureProvider<SyncTask?>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  return (db.select(db.syncTaskQueueTable)
    ..where((t) => t.status.equals('completed'))
    ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
    ..limit(1)).getSingleOrNull();
});
