import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../domain/planner_models.dart';

class PlannerHabitCard extends StatelessWidget {
  const PlannerHabitCard({required this.habit, super.key});

  final PlannerHabit habit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSpacing.m),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSpacing.s),
            decoration: BoxDecoration(
              color: habit.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignRadius.m),
            ),
            child: Icon(habit.icon, color: habit.color, size: 20),
          ),
          const SizedBox(width: DesignSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${habit.streak} day streak',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _buildWeeklyDots(),
        ],
      ),
    );
  }

  Widget _buildWeeklyDots() {
    return Row(
      children: List.generate(7, (i) {
        final isCompleted = i < habit.weeklyCompletion;
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: isCompleted ? habit.color : Colors.white10,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
