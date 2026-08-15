import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/intelligence/knight_context_provider.dart';
import '../work_tracker_controller.dart';
import '../domain/work_profile.dart';

class WorkTrackerScreen extends ConsumerWidget {
  const WorkTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);
    final sessionsAsync = ref.watch(workSessionsProvider);
    final moduleStateAsync = ref.watch(workModuleStateProvider);

    return KnightPageScaffold(
      title: 'Career',
      showBackButton: true,
      body: contextAsync.when(
        data: (knightContext) => _buildContent(context, ref, sessionsAsync, moduleStateAsync),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AsyncValue<List<dynamic>> sessions, AsyncValue<dynamic> moduleState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCareerScore(),
          const SizedBox(height: 32),
          const Text('WORK ENGINE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
          const SizedBox(height: 16),
          moduleState.when(
            data: (state) => state.profile == null 
              ? _buildInitializationState(context, ref)
              : _buildWorkControl(context, ref, state),
            loading: () => const LinearProgressIndicator(),
            error: (e, s) => Text('Error: $e'),
          ),
          const SizedBox(height: 32),
          const Text('RECENT SESSIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
          const SizedBox(height: 16),
          sessions.when(
            data: (list) => list.isEmpty ? _buildNoSessions() : _buildSessionList(list),
            loading: () => const LinearProgressIndicator(),
            error: (e, s) => Text('Error: $e'),
          ),
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildInitializationState(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: KnightTokens.glass(accentColor: Colors.blueAccent),
      child: Column(
        children: [
          const Icon(Icons.work_history_outlined, size: 48, color: Colors.white10),
          const SizedBox(height: 16),
          const Text('Professional profile not initialized.', style: TextStyle(color: Colors.white24)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _initializeTracker(context, ref), 
            child: const Text('Initialize Work Tracker')
          ),
        ],
      ),
    );
  }

  Widget _buildWorkControl(BuildContext context, WidgetRef ref, dynamic state) {
    final isWorking = state.isWorking ?? false;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: DesignColors.career),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.rocket_launch_rounded, color: DesignColors.career),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.profile.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(state.profile.companyName, style: const TextStyle(fontSize: 11, color: Colors.white38)),
                  ],
                ),
              ),
              if (isWorking)
                _ActiveTimer(startTime: state.activeSessionStartTime),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => isWorking ? _stopWorkSession(context, ref) : _startWorkSession(context, ref),
            icon: Icon(isWorking ? Icons.stop_rounded : Icons.play_arrow_rounded),
            label: Text(isWorking ? 'STOP WORK SESSION' : 'START WORK SESSION'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: isWorking ? DesignColors.error : DesignColors.career,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSessions() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Text('No historical sessions found.', style: TextStyle(color: Colors.white10)),
      ),
    );
  }

  Future<void> _startWorkSession(BuildContext context, WidgetRef ref) async {
    await ref.read(workModuleStateProvider.notifier).startSession();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session started.')));
    }
  }

  Future<void> _stopWorkSession(BuildContext context, WidgetRef ref) async {
    await ref.read(workModuleStateProvider.notifier).stopSession();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session saved to Career history.')));
    }
  }

  Widget _buildSessionList(List<dynamic> list) {
    return Column(
      children: list.map((s) => Card(
        color: DesignColors.surface,
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text('${s.shiftType} Session'),
          subtitle: Text('${(s.totalHours * 60).toInt()} minutes'),
        ),
      )).toList(),
    );
  }

  Widget _buildCareerScore() {
    return Card(
      color: DesignColors.surfaceHigh,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PROFESSIONAL MOMENTUM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
                Icon(Icons.trending_up_rounded, color: DesignColors.success, size: 16),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniStat(label: 'Focus', value: '8.2'),
                _MiniStat(label: 'Output', value: 'High'),
                _MiniStat(label: 'Skills', value: '12'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeTracker(BuildContext context, WidgetRef ref) async {
    // Milestone 10 logic: Setup career profile
    final profile = WorkProfile(
      companyName: 'KnightOS',
      jobTitle: 'Systems Architect',
      employmentType: 'Full-time',
      joiningDate: DateTime.now().toIso8601String(),
      workLocation: 'Remote',
      shiftType: 'Day',
    );
    await ref.read(workModuleStateProvider.notifier).saveProfile(profile);
    if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Work Tracker Initialized.')));
    }
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white24)),
      ],
    );
  }
}

class _ActiveTimer extends StatefulWidget {
  const _ActiveTimer({required this.startTime});
  final DateTime? startTime;

  @override
  State<_ActiveTimer> createState() => _ActiveTimerState();
}

class _ActiveTimerState extends State<_ActiveTimer> {
  late Timer _timer;
  String _elapsed = '00:00';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    if (widget.startTime == null) return;
    final diff = DateTime.now().difference(widget.startTime!);
    setState(() {
      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);
      final seconds = diff.inSeconds.remainder(60);
      _elapsed = '${hours > 0 ? "$hours:" : ""}${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DesignColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _elapsed,
        style: const TextStyle(color: DesignColors.error, fontWeight: FontWeight.bold, fontSize: 12, fontFeatures: [FontFeature.tabularFigures()]),
      ),
    );
  }
}
