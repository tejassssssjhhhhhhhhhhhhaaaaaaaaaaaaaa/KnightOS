import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../domain/planner_models.dart';

class PlannerGoalCard extends StatelessWidget {
  const PlannerGoalCard({required this.goal, super.key});

  final PlannerGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  goal.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: goal.color,
                  ),
                ),
              ),
              Text(
                '${(goal.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: goal.color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            goal.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignSpacing.m),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 4,
              backgroundColor: Colors.white10,
              color: goal.color,
            ),
          ),
        ],
      ),
    );
  }
}
