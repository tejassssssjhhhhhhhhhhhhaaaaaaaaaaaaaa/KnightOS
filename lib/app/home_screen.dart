import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:knight_os/core/router/app_routes.dart';
import 'package:knight_os/core/design_system/knight_tokens.dart';
import 'package:knight_os/core/design_system/design_constants.dart';
import 'package:knight_os/core/design_system/widgets/entrance_fader.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/knight_context_provider.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'package:knight_os/core/intelligence/services/priority_engine.dart';
import 'package:knight_os/core/design_system/widgets/usage_transparency_widget.dart';
import 'package:knight_os/core/design_system/widgets/logo_entrance_animation.dart';
import 'package:knight_os/core/intelligence/domain/notification_models.dart';
import 'package:knight_os/core/internal/services/greeting_service.dart';
import 'package:knight_os/core/theme/knight_theme_provider.dart';
import 'package:knight_os/core/providers/focus_mode_provider.dart';
import 'package:knight_os/app/widgets/knight_page_scaffold.dart';
import 'package:knight_os/app/widgets/knight_skeleton.dart';
import 'package:knight_os/app/widgets/home/perception_widget.dart';
import 'package:knight_os/app/widgets/home/world_widget.dart';
import 'package:knight_os/features/search/presentation/universal_search_overlay.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      hideLeadingLogo: true,
      body: contextAsync.when(
        data: (knightContext) => _HomeScreenContent(knightContext: knightContext),
        loading: () => const _HomeLoadingState(),
        error: (e, s) => Center(child: Text('Context Error: $e')),
      ),
    );
  }
}

class _HomeLoadingState extends StatelessWidget {
  const _HomeLoadingState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          const Center(child: KnightSkeleton(width: 64, height: 64, borderRadius: 20)),
          const SizedBox(height: 48),
          const KnightSkeleton(width: double.infinity, height: 56, borderRadius: 28),
          const SizedBox(height: 32),
          const KnightSkeleton(width: 120, height: 20),
          const SizedBox(height: 32),
          const KnightCardSkeleton(),
          const SizedBox(height: 32),
          const KnightCardSkeleton(),
        ],
      ),
    );
  }
}

class _HomeScreenContent extends ConsumerWidget {
  const _HomeScreenContent({required this.knightContext});
  final KnightContext knightContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorities = ref.watch(priorityEngineProvider).calculatePriorities(knightContext);
    final usageCount = ref.watch(aiUsageProvider);
    final notifications = ref.watch(activeNotificationsProvider);

    Widget modeContent;
    if (knightContext.isFocusMode) {
      modeContent = _buildFocusLayout(context, ref, priorities, notifications);
    } else if (knightContext.isRelaxationMode) {
      modeContent = _buildRelaxationLayout(context, ref, priorities, notifications);
    } else {
      switch (knightContext.period) {
        case KnightDayPeriod.morning:
          modeContent = _buildMorningLayout(context, ref, priorities, notifications);
          break;
        case KnightDayPeriod.day:
          modeContent = _buildDayLayout(context, ref, priorities, notifications);
          break;
        case KnightDayPeriod.afternoon:
          modeContent = _buildAfternoonLayout(context, ref, priorities, notifications);
          break;
        case KnightDayPeriod.evening:
          modeContent = _buildEveningLayout(context, ref, priorities, notifications);
          break;
        case KnightDayPeriod.night:
          modeContent = _buildNightLayout(context, ref, priorities, notifications);
          break;
        case KnightDayPeriod.lateNight:
          modeContent = _buildLateNightLayout(context, ref, priorities, notifications);
          break;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          
          Center(
            child: LogoEntranceAnimation(
              period: knightContext.period,
              size: 64,
            ),
          ),
          
          const SizedBox(height: 48),
          
          const _UniversalSearchBar(),
          
          const SizedBox(height: 24),
          const Center(child: WorldWidget()),
          
          const SizedBox(height: 32),
          const PerceptionWidget(),
          
          modeContent,
          
          const SizedBox(height: 64),
          
          // Usage Transparency
          EntranceFader(
            delay: const Duration(milliseconds: 800),
            child: UsageTransparencyWidget(
              resourceName: 'Neural Core',
              used: usageCount.toDouble(),
              total: 1000,
            ),
          ),
          
          if (kDebugMode) ...[
            const SizedBox(height: 48),
            _DebugModeSwitcher(),
          ],

          const SizedBox(height: 240),
        ],
      ),
    );
  }

  Widget _buildMorningLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    final topPriority = priorities.isNotEmpty ? priorities.first : null;
    final otherPriorities = priorities.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EntranceFader(
          delay: const Duration(milliseconds: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                knightContext.greeting,
                style: KnightTokens.headline.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()).toUpperCase(),
                style: KnightTokens.label.copyWith(color: Colors.white38),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        if (notifications.isNotEmpty) ...[
          _NotificationStrip(notifications: notifications),
          const SizedBox(height: 40),
        ],
        if (topPriority != null) ...[
          const Text('PRIORITY FOCUS', style: KnightTokens.label),
          const SizedBox(height: 16),
          EntranceFader(
            delay: const Duration(milliseconds: 200),
            child: _PrimaryFocusCard(item: topPriority),
          ),
        ],
        if (otherPriorities.isNotEmpty) ...[
          const SizedBox(height: 40),
          const Text('MORNING INSIGHTS', style: KnightTokens.label),
          const SizedBox(height: 16),
          _buildInsightsGrid(otherPriorities.take(2).toList()),
        ],
        const SizedBox(height: 48),
        const Text('QUICK ACTIONS', style: KnightTokens.label),
        const SizedBox(height: 16),
        const _QuickActionsRow(),
      ],
    );
  }

  Widget _buildDayLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    final topPriority = priorities.isNotEmpty ? priorities.first : null;
    final otherPriorities = priorities.skip(1).take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EntranceFader(
          delay: const Duration(milliseconds: 100),
          child: Text(
            knightContext.greeting,
            style: KnightTokens.headline.copyWith(fontSize: 28),
          ),
        ),
        const SizedBox(height: 40),
        if (notifications.isNotEmpty) ...[
          _NotificationStrip(notifications: notifications),
          const SizedBox(height: 40),
        ],
        if (topPriority != null)
          _PrimaryFocusCard(item: topPriority),
        const SizedBox(height: 48),
        if (otherPriorities.isNotEmpty) ...[
          const Text('SITUATIONAL AWARENESS', style: KnightTokens.label),
          const SizedBox(height: 16),
          _buildInsightsGrid(otherPriorities),
        ],
        const SizedBox(height: 48),
        const Text('QUICK ACTIONS', style: KnightTokens.label),
        const SizedBox(height: 16),
        const _QuickActionsRow(),
      ],
    );
  }

  Widget _buildAfternoonLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    final topPriority = priorities.isNotEmpty ? priorities.first : null;
    final otherPriorities = priorities.skip(1).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          knightContext.greeting,
          style: KnightTokens.headline.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 40),
        if (notifications.isNotEmpty) ...[
          _NotificationStrip(notifications: notifications),
          const SizedBox(height: 40),
        ],
        if (topPriority != null)
           _PrimaryFocusCard(item: topPriority),
        const SizedBox(height: 40),
        if (otherPriorities.isNotEmpty) ...[
          const Text('MIDDAY MOMENTUM', style: KnightTokens.label),
          const SizedBox(height: 16),
          _buildInsightsGrid(otherPriorities),
        ],
        const SizedBox(height: 48),
        const Text('QUICK ACTIONS', style: KnightTokens.label),
        const SizedBox(height: 16),
        const _QuickActionsRow(),
      ],
    );
  }

  Widget _buildEveningLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    final topPriority = priorities.isNotEmpty ? priorities.first : null;
    final otherPriorities = priorities.skip(1).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          knightContext.greeting,
          style: KnightTokens.headline.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 40),
        if (notifications.isNotEmpty) ...[
          _NotificationStrip(notifications: notifications),
          const SizedBox(height: 40),
        ],
        if (topPriority != null)
           _PrimaryFocusCard(item: topPriority),
        const SizedBox(height: 40),
        if (otherPriorities.isNotEmpty) ...[
          const Text('EVENING BRIEFING', style: KnightTokens.label),
          const SizedBox(height: 16),
          _buildInsightsGrid(otherPriorities),
        ],
        const SizedBox(height: 48),
        const Text('QUICK ACTIONS', style: KnightTokens.label),
        const SizedBox(height: 16),
        const _QuickActionsRow(),
      ],
    );
  }

  Widget _buildNightLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    final topPriority = priorities.isNotEmpty ? priorities.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          knightContext.greeting,
          style: KnightTokens.headline.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 60),
        if (notifications.isNotEmpty) ...[
          _NotificationStrip(notifications: notifications),
          const SizedBox(height: 40),
        ],
        if (topPriority != null) ...[
          const Text('REST & RECOVER', style: KnightTokens.label),
          const SizedBox(height: 16),
          _PrimaryFocusCard(item: topPriority),
        ],
        const SizedBox(height: 48),
        const Text('QUICK ACTIONS', style: KnightTokens.label),
        const SizedBox(height: 16),
        const _QuickActionsRow(),
      ],
    );
  }

  Widget _buildLateNightLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    final topPriority = priorities.isNotEmpty ? priorities.first : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Text(
          knightContext.greeting,
          textAlign: TextAlign.center,
          style: KnightTokens.headline.copyWith(fontSize: 24, color: Colors.white24),
        ),
        const SizedBox(height: 120),
        const Text('ONLY ESSENTIALS', style: KnightTokens.label),
        const SizedBox(height: 24),
        if (topPriority != null)
          _PrimaryFocusCard(item: topPriority)
        else
          const Text('The shift is quiet.', style: TextStyle(color: Colors.white10)),
        const SizedBox(height: 64),
        const _QuickActionsRow(),
      ],
    );
  }

  Widget _buildRelaxationLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.nightlight_round, size: 48, color: Colors.blueAccent),
        const SizedBox(height: 24),
        Text(
          'RELAXATION MODE ACTIVE',
          style: KnightTokens.label.copyWith(color: Colors.blueAccent),
        ),
        const SizedBox(height: 40),
        const Text(
          'Knight is handling the shift.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        const Text(
          'Work notifications and surfaces are paused.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white24, fontSize: 13),
        ),
        const SizedBox(height: 48),
        _buildSimpleKnightSuggestion('System is performing deep synchronization and relationship maintenance.'),
        const SizedBox(height: 48),
        OutlinedButton(
          onPressed: () => context.push(AppRoutes.relaxation),
          child: const Text('CONTROL CENTER'),
        ),
      ],
    );
  }

  Widget _buildFocusLayout(BuildContext context, WidgetRef ref, List<PriorityItem> priorities, List<KnightNotification> notifications) {
    final topPriority = priorities.isNotEmpty ? priorities.first : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'FOCUS MODE',
            style: KnightTokens.label,
          ),
        ),
        const SizedBox(height: 60),
        if (topPriority != null)
          Center(
            child: Column(
              children: [
                const Text('CURRENT FOCUS', style: KnightTokens.label),
                const SizedBox(height: 24),
                Text(
                  topPriority.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.check_circle_rounded,
                      label: 'Complete',
                      onTap: () {
                        // Mark task as done logic (omitted as per scope, but we can exit mode)
                        ref.read(focusModeProvider.notifier).set(false);
                      },
                    ),
                    const SizedBox(width: 48),
                    _ActionButton(
                      icon: Icons.close_rounded,
                      label: 'Exit',
                      onTap: () => ref.read(focusModeProvider.notifier).set(false),
                    ),
                  ],
                ),
              ],
            ),
          )
        else
          const Center(child: Text('No active tasks.', style: TextStyle(color: Colors.white38))),
      ],
    );
  }

  Widget _buildInsightsGrid(List<PriorityItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => EntranceFader(
        delay: Duration(milliseconds: 100 + (index * 100)),
        child: _InsightCard(item: items[index]),
      ),
    );
  }

  Widget _buildSimpleKnightSuggestion(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white60, fontSize: 15, height: 1.6),
      ),
    );
  }
}

class _DebugModeSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(simulatedHourProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DEBUG: TIME OVERRIDE', style: KnightTokens.label),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _DebugButton(label: 'Auto', active: current == null, onTap: () => ref.read(simulatedHourProvider.notifier).set(null)),
              _DebugButton(label: '8 AM', active: current == 8, onTap: () => ref.read(simulatedHourProvider.notifier).set(8)),
              _DebugButton(label: '12 PM', active: current == 12, onTap: () => ref.read(simulatedHourProvider.notifier).set(12)),
              _DebugButton(label: '3 PM', active: current == 15, onTap: () => ref.read(simulatedHourProvider.notifier).set(15)),
              _DebugButton(label: '7 PM', active: current == 19, onTap: () => ref.read(simulatedHourProvider.notifier).set(19)),
              _DebugButton(label: '10 PM', active: current == 22, onTap: () => ref.read(simulatedHourProvider.notifier).set(22)),
              _DebugButton(label: '3 AM', active: current == 3, onTap: () => ref.read(simulatedHourProvider.notifier).set(3)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _DebugButton(
          label: ref.watch(focusModeProvider) ? 'Exit Focus' : 'Enter Focus',
          active: ref.watch(focusModeProvider),
          onTap: () => ref.read(focusModeProvider.notifier).toggle(),
        ),
      ],
    );
  }
}

class _DebugButton extends StatelessWidget {
  const _DebugButton({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: active ? Colors.blue : Colors.white10),
          backgroundColor: active ? Colors.blue.withValues(alpha: 0.1) : null,
        ),
        child: Text(label, style: TextStyle(color: active ? Colors.blue : Colors.white24, fontSize: 11)),
      ),
    );
  }
}

class _NotificationStrip extends StatelessWidget {
  const _NotificationStrip({required this.notifications});
  final List<KnightNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PRIORITY ALERTS', style: KnightTokens.label),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getColor(n.priority).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _getColor(n.priority).withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(_getIcon(n.category), color: _getColor(n.priority), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(n.body, style: const TextStyle(color: Colors.white38, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getColor(NotificationPriority p) {
    if (p == NotificationPriority.critical) return DesignColors.error;
    if (p == NotificationPriority.high) return DesignColors.warning;
    return DesignColors.accentBlue;
  }

  IconData _getIcon(NotificationCategory c) {
    if (c == NotificationCategory.health) return Icons.favorite_rounded;
    if (c == NotificationCategory.finance) return Icons.account_balance_wallet_rounded;
    return Icons.notifications_active_rounded;
  }
}

class _UniversalSearchBar extends StatelessWidget {
  const _UniversalSearchBar();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => UniversalSearchOverlay.show(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: const Row(
          children: [
            Icon(Icons.search_rounded, color: Colors.white38, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text('Search your life...', style: TextStyle(color: Colors.white24, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryFocusCard extends StatelessWidget {
  const _PrimaryFocusCard({required this.item});
  final PriorityItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Focus Card: ${item.title}. ${item.description}',
      button: true,
      onTapHint: 'View details for this priority',
      child: GestureDetector(
        onTap: () => _handleAction(context, item),
        child: Container(
          padding: const EdgeInsets.all(32),
          width: double.infinity,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.08),
            borderRadius: KnightTokens.radiusCard,
            border: Border.all(color: item.color.withValues(alpha: 0.15), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item.icon, color: item.color, size: 18),
                  const SizedBox(width: 10),
                  Text(item.title.toUpperCase(), style: KnightTokens.label.copyWith(color: item.color, fontSize: 9)),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                item.description, 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: Colors.white),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Text(
                    'TAKE ACTION',
                    style: theme.textTheme.labelLarge?.copyWith(color: item.color, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: item.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, PriorityItem item) {
    if (item.title == 'Action Required') {
      context.push(AppRoutes.planner);
    } else if (item.title == 'Coming Up') {
      context.push(AppRoutes.lifeAtlas);
    } else if (item.title == 'Move Momentum') {
      context.push(AppRoutes.health);
    } else if (item.title == 'Finance Review') {
      context.push(AppRoutes.finance);
    } else if (item.title == 'System Warning') {
      context.push(AppRoutes.integrations);
    } else if (item.title == 'Travel') {
      context.push(AppRoutes.travelHome);
    } else {
      context.push(AppRoutes.knight);
    }
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.item});
  final PriorityItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Insight: ${item.title}. ${item.description}',
      button: true,
      child: GestureDetector(
        onTap: () => _handleAction(context, item),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, color: item.color.withValues(alpha: 0.5), size: 16),
              const Spacer(),
              Text(
                item.title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, PriorityItem item) {
    if (item.title == 'Action Required') {
      context.push(AppRoutes.planner);
    } else if (item.title == 'Coming Up') {
      context.push(AppRoutes.lifeAtlas);
    } else if (item.title == 'Move Momentum') {
      context.push(AppRoutes.health);
    } else if (item.title == 'Finance Review') {
      context.push(AppRoutes.finance);
    } else if (item.title == 'System Warning') {
      context.push(AppRoutes.integrations);
    } else if (item.title == 'Travel') {
      context.push(AppRoutes.travelHome);
    } else {
      context.push(AppRoutes.knight);
    }
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionButton(icon: Icons.add_task_rounded, label: 'Task', onTap: () => context.push(AppRoutes.planner)),
        _ActionButton(icon: Icons.account_balance_wallet_rounded, label: 'Finance', onTap: () => context.push(AppRoutes.finance)),
        _ActionButton(icon: Icons.favorite_rounded, label: 'Health', onTap: () => context.push(AppRoutes.health)),
        _ActionButton(icon: Icons.nightlight_round, label: 'Rest', onTap: () => context.push(AppRoutes.relaxation)),
        _ActionButton(icon: Icons.hub_rounded, label: 'Sync', onTap: () => context.push(AppRoutes.importCenter)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label Action',
      button: true,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Icon(icon, color: Colors.white70, size: 24),
            ),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
