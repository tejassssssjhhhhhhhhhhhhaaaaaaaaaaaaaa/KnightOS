import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/router/app_routes.dart';
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
  final _timeController = TextEditingController();
  final _levelController = TextEditingController(text: 'beginner');
  final _styleController = TextEditingController(text: 'guided');
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
    _timeController.dispose();
    _levelController.dispose();
    _styleController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    final title = _titleController.text.trim();
    final reason = _reasonController.text.trim();
    if (title.isEmpty || reason.isEmpty) {
      return;
    }

    final goal = LearningGoal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      reason: reason,
      createdAt: DateTime.now(),
      dailyTime: _timeController.text.trim().isEmpty ? null : _timeController.text.trim(),
      level: _levelController.text.trim().isEmpty ? 'beginner' : _levelController.text.trim(),
      style: _styleController.text.trim().isEmpty ? 'guided' : _styleController.text.trim(),
    );

    await _repository.saveGoal(goal);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Learning goal saved.')));
    _titleController.clear();
    _reasonController.clear();
    _timeController.clear();
    _levelController.text = 'beginner';
    _styleController.text = 'guided';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Learning',
      showBackButton: true,
      body: FutureBuilder<List<LearningGoal>>(
        future: _repository.loadGoals(),
        builder: (context, snapshot) {
          final goals = snapshot.data ?? const <LearningGoal>[];
          return ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('What do you want to learn?', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Create a learning goal, add your reason, and keep it linked to your own pace and preferences.', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Learning goal')),
                      const SizedBox(height: 12),
                      TextField(controller: _reasonController, maxLines: 3, decoration: const InputDecoration(labelText: 'Why does it matter?')),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: TextField(controller: _timeController, decoration: const InputDecoration(labelText: 'Daily time'))),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: _levelController, decoration: const InputDecoration(labelText: 'Level'))),
                      ]),
                      const SizedBox(height: 12),
                      TextField(controller: _styleController, decoration: const InputDecoration(labelText: 'Preferred style')),
                      const SizedBox(height: 16),
                      FilledButton.icon(onPressed: _saveGoal, icon: const Icon(Icons.school_rounded), label: const Text('Save learning goal')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (goals.isEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('No learning goals yet. Add one and Knight will keep it tied to your companion space and memory system.')))
              else ...[
                Text('Active learning goals', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...goals.map((goal) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(goal.title),
                    subtitle: Text(goal.reason),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.go(AppRoutes.memory),
                  ),
                )),
              ],
            ],
          );
        },
      ),
    );
  }
}
