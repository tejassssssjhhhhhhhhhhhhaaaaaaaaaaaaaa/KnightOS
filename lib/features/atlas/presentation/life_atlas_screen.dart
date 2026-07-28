import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';

class LifeAtlasScreen extends ConsumerWidget {
  const LifeAtlasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildTabs(context),
            const SizedBox(height: 32),
            _buildTimelineList(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: DesignColors.accentBlue,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Life Atlas', style: Theme.of(context).textTheme.headlineMedium),
                const Text('Your Life. Mapped.', style: TextStyle(fontSize: 12, color: Colors.white38)),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['Timeline', 'Events', 'Milestones', 'Map'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab == 'Timeline';
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateGroup(context, 'Today', [
          _TItem('Gym Workout', '6:00 PM', Icons.fitness_center_rounded, DesignColors.success),
          _TItem('Project Completed', '4:30 PM', Icons.check_circle_outline_rounded, DesignColors.accentPurple),
        ]),
        const SizedBox(height: 32),
        _buildDateGroup(context, 'Yesterday', [
          _TItem('Read 20 Pages', '9:15 PM', Icons.menu_book_rounded, DesignColors.knowledge),
          _TItem('Work Shift', '7 PM - 4 AM', Icons.work_outline_rounded, DesignColors.career),
        ]),
        const SizedBox(height: 32),
        _buildDateGroup(context, 'Jul 28, 2025', [
          _TItem('Met with Team', '3:00 PM', Icons.groups_outlined, DesignColors.accentCyan),
          _TItem('Dinner with Family', '8:30 PM', Icons.restaurant_rounded, DesignColors.health),
        ]),
      ],
    );
  }

  Widget _buildDateGroup(BuildContext context, String date, List<_TItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
        const SizedBox(height: 16),
        ...items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DesignColors.white05),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 20),
            ),
            title: Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            trailing: Text(item.time, style: const TextStyle(fontSize: 11, color: Colors.white24)),
            onTap: () {},
          ),
        )),
      ],
    );
  }
}

class _TItem {
  const _TItem(this.title, this.time, this.icon, this.color);
  final String title;
  final String time;
  final IconData icon;
  final Color color;
}
