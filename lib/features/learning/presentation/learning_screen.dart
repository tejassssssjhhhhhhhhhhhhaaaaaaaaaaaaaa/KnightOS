import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../learning_models.dart';
import '../learning_repository.dart';

class LearningScreen extends ConsumerStatefulWidget {
  const LearningScreen({super.key});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
  final _titleController = TextEditingController();
  final _reasonController = TextEditingController();
  late final LearningRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = LearningRepository();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    final title = _titleController.text.trim();
    final reason = _reasonController.text.trim();
    if (title.isEmpty || reason.isEmpty) return;

    final goal = LearningGoal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      reason: reason,
      createdAt: DateTime.now(),
      level: 'beginner',
      style: 'guided',
    );

    await _repository.saveGoal(goal);
    HapticFeedback.selectionClick();
    if (!mounted) return;
    _titleController.clear();
    _reasonController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'GuruKool',
      showBackButton: true,
      body: FutureBuilder<List<LearningGoal>>(
        future: _repository.loadGoals(),
        builder: (context, snapshot) {
          final goals = snapshot.data ?? const <LearningGoal>[];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildGoalInput(),
                const SizedBox(height: 40),
                const Text('ACTIVE LEARNING MISSIONS', style: KnightTokens.label),
                const SizedBox(height: 16),
                if (goals.isEmpty)
                   _buildEmptyState()
                else
                  ...goals.map((g) => _LearningGoalTile(goal: g)),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mastery & Purpose', style: KnightTokens.headline.copyWith(fontSize: 28)),
        const SizedBox(height: 8),
        const Text('Evolving your capabilities through intentional study.', style: KnightTokens.subheadline),
      ],
    );
  }

  Widget _buildGoalInput() {
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
          const Text('New Study Objective', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'What skill are you targeting?'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(hintText: 'Why does this matter now?'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saveGoal,
              child: const Text('INITIATE MISSION'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.school_outlined, size: 48, color: Colors.white10),
          SizedBox(height: 16),
          Text('No active study goals.', style: TextStyle(color: Colors.white24, fontSize: 13)),
        ],
      ),
    );
  }
}

class _LearningGoalTile extends StatelessWidget {
  const _LearningGoalTile({required this.goal});
  final LearningGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: const CircleAvatar(
          backgroundColor: DesignColors.white05,
          child: Icon(Icons.bolt_rounded, color: Colors.amberAccent, size: 18),
        ),
        title: Text(goal.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(goal.reason, style: const TextStyle(fontSize: 11, color: Colors.white38)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
        onTap: () => context.push(AppRoutes.knight),
      ),
    );
  }
}
