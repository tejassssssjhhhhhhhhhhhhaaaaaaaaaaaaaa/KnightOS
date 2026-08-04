import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/router/app_routes.dart';

class QuickActionsPanel extends StatefulWidget {
  const QuickActionsPanel({super.key});

  @override
  State<QuickActionsPanel> createState() => _QuickActionsPanelState();
}

class _QuickActionsPanelState extends State<QuickActionsPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'QUICK ACTIONS',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 2.0,
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              icon: Icon(
                _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: Colors.white24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          firstChild: _buildGrid(context, 4),
          secondChild: _buildGrid(context, 8),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: DesignAnimations.standard,
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, int count) {
    final actions = [
      _ActionItem(Icons.psychology_rounded, 'Memory', AppRoutes.memory, DesignColors.knowledge),
      _ActionItem(Icons.task_alt_rounded, 'Task', AppRoutes.planner, DesignColors.focus),
      _ActionItem(Icons.business_center_rounded, 'Career', AppRoutes.career, DesignColors.career),
      _ActionItem(Icons.timer_outlined, 'Focus', AppRoutes.work, DesignColors.accentBlue),
      _ActionItem(Icons.account_balance_wallet_rounded, 'Finance', AppRoutes.finance, DesignColors.finance),
      _ActionItem(Icons.favorite_rounded, 'Health', AppRoutes.health, DesignColors.health),
      _ActionItem(Icons.explore_rounded, 'Atlas', AppRoutes.lifeAtlas, DesignColors.travel),
      _ActionItem(Icons.auto_awesome_rounded, 'Intelligence', AppRoutes.intelligence, DesignColors.accentPurple),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: count.clamp(0, actions.length),
      itemBuilder: (context, i) => _buildActionCard(context, actions[i]),
    );
  }

  Widget _buildActionCard(BuildContext context, _ActionItem action) {
    return InkWell(
      onTap: () {
        if (action.route != null) {
          context.go(action.route!);
        } else {
          // Placeholder for "Ask Knight"
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI Copilot arriving in Sprint 6.6')),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: action.color.withValues(alpha: 0.2)),
            ),
            child: Icon(action.icon, color: action.color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String? route;
  final Color color;

  const _ActionItem(this.icon, this.label, this.route, this.color);
}
