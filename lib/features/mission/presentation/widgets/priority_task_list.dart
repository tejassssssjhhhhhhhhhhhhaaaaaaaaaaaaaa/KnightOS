import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/memory_category.dart';
import '../../../../core/intelligence/domain/mission_models.dart';

class PriorityTaskList extends ConsumerWidget {
  const PriorityTaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrieval = ref.watch(memoryRetrievalEngineProvider);

    return FutureBuilder<List<Task>>(
      future: _fetchTasks(retrieval),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final tasks = snapshot.data!;
        if (tasks.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No high-priority tasks for today.',
                style: TextStyle(color: Colors.white24),
              ),
            ),
          );
        }

        return Column(
          children: tasks.map((t) => _buildTaskTile(context, t)).toList(),
        );
      },
    );
  }

  Future<List<Task>> _fetchTasks(dynamic retrieval) async {
    final memories = await retrieval.getByCategory(BookCategory.ambitions);
    return memories
        .where((m) => m.content['missionDataType'] == 'task')
        .map((m) => Task.fromJson(m.content))
        .toList();
  }

  Widget _buildTaskTile(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(value: task.isCompleted, onChanged: (_) {}),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          'Priority: ${task.priority.name.toUpperCase()}',
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.0,
            color: Colors.white24,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: Colors.white10,
        ),
      ),
    );
  }
}
