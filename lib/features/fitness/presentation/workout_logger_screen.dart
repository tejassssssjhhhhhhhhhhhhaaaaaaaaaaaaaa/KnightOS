import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/internal/storage/drift/knight_database.dart';

class WorkoutLoggerScreen extends ConsumerStatefulWidget {
  const WorkoutLoggerScreen({this.sessionId, super.key});
  final String? sessionId;

  @override
  ConsumerState<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends ConsumerState<WorkoutLoggerScreen> {
  final _uuid = const Uuid();
  String? _currentSessionId;
  String _workoutType = 'Strength';
  final List<WorkoutSetTableCompanion> _stagedSets = [];
  bool _isSaving = false;

  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSessionId = widget.sessionId ?? _uuid.v4();
    if (widget.sessionId != null) {
      _loadExistingSession();
    }
  }

  Future<void> _loadExistingSession() async {
    // Future: Load sets for existing session
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _addSet() {
    if (_exerciseController.text.isEmpty) return;
    
    setState(() {
      _stagedSets.add(WorkoutSetTableCompanion.insert(
        id: _uuid.v4(),
        sessionId: _currentSessionId!,
        exerciseName: _exerciseController.text.trim(),
        weight: drift.Value(double.tryParse(_weightController.text) ?? 0.0),
        reps: drift.Value(int.tryParse(_repsController.text) ?? 0),
        setOrder: _stagedSets.length + 1,
      ));
      
      // Clear inputs but keep exercise name for convenience
      _weightController.clear();
      _repsController.clear();
    });
  }

  Future<void> _finishWorkout() async {
    if (_stagedSets.isEmpty && widget.sessionId == null) {
      context.pop();
      return;
    }

    setState(() => _isSaving = true);
    final db = ref.read(knightDatabaseProvider);

    try {
      if (widget.sessionId == null) {
        await db.workoutFoundationDao.logWorkout(WorkoutSessionTableCompanion.insert(
          id: _currentSessionId!,
          workoutType: _workoutType,
          startTime: DateTime.now(),
          isComplete: const drift.Value(true),
          endTime: drift.Value(DateTime.now()),
        ));
      }

      for (final set in _stagedSets) {
        await db.workoutFoundationDao.logSet(set);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout secured.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: widget.sessionId == null ? 'New Workout' : 'Edit Workout',
      showBackButton: true,
      actions: [
        if (!_isSaving)
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('FINISH', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          )
        else
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          ),
      ],
      body: Column(
        children: [
          _buildSessionHeader(),
          _buildInputSection(),
          const Divider(height: 1, color: Colors.white10),
          Expanded(child: _buildSetsList()),
        ],
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white.withValues(alpha: 0.02),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: Colors.white38),
          const SizedBox(width: 12),
          Text(
            DateFormat('MMMM d, HH:mm').format(DateTime.now()),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: _workoutType,
            dropdownColor: Colors.grey[900],
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold),
            items: ['Strength', 'Cardio', 'Mobility', 'Recovery'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toUpperCase()),
              );
            }).toList(),
            onChanged: (val) => setState(() => _workoutType = val!),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            controller: _exerciseController,
            decoration: KnightTokens.inputDecoration(label: 'Exercise Name', hint: 'e.g. Bench Press'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: KnightTokens.inputDecoration(label: 'Weight', hint: 'kg'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  decoration: KnightTokens.inputDecoration(label: 'Reps', hint: 'count'),
                ),
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                onPressed: _addSet,
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(backgroundColor: Colors.white10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetsList() {
    if (_stagedSets.isEmpty) {
      return const Center(
        child: Text('No sets recorded yet.', style: TextStyle(color: Colors.white10)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: _stagedSets.length,
      itemBuilder: (context, index) {
        final set = _stagedSets[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Text('#${set.setOrder.value}', style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  set.exerciseName.value,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${set.weight.value} kg × ${set.reps.value}',
                style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => setState(() => _stagedSets.removeAt(index)),
                child: const Icon(Icons.close_rounded, size: 16, color: Colors.white12),
              ),
            ],
          ),
        );
      },
    );
  }
}
