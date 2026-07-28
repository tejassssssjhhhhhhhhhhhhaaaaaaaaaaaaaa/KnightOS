import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';

class MissionDashboardScreen extends ConsumerWidget {
  const MissionDashboardScreen({super.key});

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
            _buildCurrentRole(context),
            const SizedBox(height: 32),
            _buildPerformance(context),
            const SizedBox(height: 32),
            _buildSkills(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text('Career', style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['Overview', 'Goals', 'Skills', 'Performance'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab == 'Overview';
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

  Widget _buildCurrentRole(BuildContext context) {
    return Card(
      color: DesignColors.surfaceHigh,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CURRENT ROLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
                  const SizedBox(height: 12),
                  const Text('Specialist', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text('Technical Support', style: TextStyle(fontSize: 14, color: Colors.white38)),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 6,
                    backgroundColor: DesignColors.white05,
                    color: DesignColors.accentBlue,
                  ),
                ),
                const Column(
                  children: [
                    Text('75%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    Text('Growth', style: TextStyle(fontSize: 8, color: Colors.white38)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformance(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('THIS WEEK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        _buildPerfRow('Tasks Completed', '18 / 25', 0.72, DesignColors.accentBlue),
        const SizedBox(height: 20),
        _buildPerfRow('Calls Handled', '12', 0.5, DesignColors.success),
        const SizedBox(height: 20),
        _buildPerfRow('Chats Handled', '26', 0.8, DesignColors.accentPurple),
      ],
    );
  }

  Widget _buildPerfRow(String label, String value, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: DesignColors.white05,
          color: color,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Widget _buildSkills(BuildContext context) {
    final skills = ['Technical Support', 'Networking', 'Troubleshooting', 'Customer Service'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SKILLS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: [
            ...skills.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: DesignColors.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DesignColors.white05),
              ),
              child: Text(s, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10, style: BorderStyle.solid),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 14, color: Colors.white24),
                  SizedBox(width: 4),
                  Text('Add Skill', style: TextStyle(fontSize: 12, color: Colors.white24)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
