import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class QuickAddMenu extends StatelessWidget {
  const QuickAddMenu({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: DesignColors.background,
      shape: RoundedRectangleBorder(borderRadius: DesignRadius.sheet),
      builder: (context) => const QuickAddMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(DesignSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Mission',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Define a new objective or routine for your system.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: DesignSpacing.xl),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: DesignSpacing.m,
              crossAxisSpacing: DesignSpacing.m,
              childAspectRatio: 2.2,
              children: [
                _buildOption(
                  context,
                  'New Task',
                  Icons.task_alt_rounded,
                  DesignColors.travel,
                ),
                _buildOption(
                  context,
                  'Core Goal',
                  Icons.flag_rounded,
                  DesignColors.focus,
                ),
                _buildOption(
                  context,
                  'Habit',
                  Icons.repeat_rounded,
                  DesignColors.achievements,
                ),
                _buildOption(
                  context,
                  'Reminder',
                  Icons.notification_important_rounded,
                  DesignColors.health,
                ),
                _buildOption(
                  context,
                  'Event',
                  Icons.calendar_today_rounded,
                  DesignColors.knowledge,
                ),
                _buildOption(
                  context,
                  'Meeting',
                  Icons.videocam_rounded,
                  DesignColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: DesignSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(DesignRadius.l),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: DesignSpacing.m),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
