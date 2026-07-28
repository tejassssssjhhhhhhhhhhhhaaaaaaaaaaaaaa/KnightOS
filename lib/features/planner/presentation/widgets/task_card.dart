import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../domain/planner_models.dart';

class PlannerTaskCard extends StatelessWidget {
  const PlannerTaskCard({required this.task, this.onChanged, super.key});

  final PlannerTask task;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignSpacing.m,
        vertical: DesignSpacing.s,
      ),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged?.call(!isCompleted),
          borderRadius: BorderRadius.circular(DesignRadius.l),
          child: Padding(
            padding: const EdgeInsets.all(DesignSpacing.m),
            child: Row(
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: onChanged,
                  activeColor: DesignColors.focus,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: DesignSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted ? Colors.white24 : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: Colors.white24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat.Hm().format(task.dueTime),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildPriorityBadge(task.priority),
                        ],
                      ),
                    ],
                  ),
                ),
                if (task.hasNotes)
                  const Icon(
                    Icons.notes_rounded,
                    size: 14,
                    color: Colors.white24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    if (priority == TaskPriority.low) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.label.toUpperCase(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: priority.color,
        ),
      ),
    );
  }
}
