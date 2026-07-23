import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/dashboard/dashboard_controller.dart';
import '../../features/dashboard/dashboard_models.dart';
import '../../features/onboarding/domain/onboarding_profile.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/knight_page_scaffold.dart';
import '../widgets/mission_card.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/quick_actions.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return KnightPageScaffold(
      title: 'Dashboard',
      actions: [
        IconButton(
          onPressed: () => ref.invalidate(dashboardProvider),
          icon: const Icon(Icons.refresh_outlined),
          tooltip: 'Refresh dashboard',
        ),
      ],
      body: dashboardAsync.when(
        data: (dashboard) => _DashboardView(
          dashboard: dashboard,
          onRefresh: () async => ref.invalidate(dashboardProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load dashboard: $error'),
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({
    required this.dashboard,
    required this.onRefresh,
  });

  final DashboardData dashboard;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final profile = dashboard.resolvedProfile;
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(
              greeting: greetingForNow(),
              name: displayName(profile),
              dateLabel: formatDate(DateTime.now()),
              score: '78/100',
            ),
            const SizedBox(height: 20),
            if (dashboard.profile == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'No onboarding profile was found yet. The dashboard is using a clean default view until the profile is saved.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const MissionCard(
              mission: 'Complete your planned work.',
              streak: '5 Days',
              message: 'You are building momentum.',
            ),
            const SizedBox(height: 20),
            DashboardSection(
              title: 'Health Summary',
              subtitle: 'Daily recovery, hydration, and activity goals.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _DashboardStatCard(
                    label: 'Sleep Goal',
                    value: valueOrFallback(profile.sleepGoal, 'Not set'),
                    icon: Icons.bed_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Sleep Summary',
                    value: dashboard.sleepSessions.isEmpty
                        ? 'No logs yet'
                        : '${dashboard.averageSleep.toStringAsFixed(1)}h avg',
                    icon: Icons.nights_stay_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Water Goal',
                    value: valueOrFallback(profile.waterGoal, 'Not set'),
                    icon: Icons.water_drop_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Exercise Frequency',
                    value: valueOrFallback(profile.exerciseFrequency, 'Not set'),
                    icon: Icons.fitness_center_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Fitness Level',
                    value: valueOrFallback(profile.fitnessLevel, 'Not set'),
                    icon: Icons.self_improvement_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardSection(
              title: 'Fitness Summary',
              subtitle: 'Today’s workout focus and consistency.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _DashboardStatCard(
                    label: 'Today’s Workout',
                    value: dashboard.workoutSessions.isEmpty
                        ? 'No log yet'
                        : dashboard.workoutSessions.first.workoutType,
                    icon: Icons.fitness_center_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Weekly Workouts',
                    value: dashboard.fitnessMetrics.weeklyWorkouts.toString(),
                    icon: Icons.calendar_view_week_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Current Streak',
                    value: '${dashboard.fitnessMetrics.workoutStreak} days',
                    icon: Icons.local_fire_department_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardSection(
              title: 'Finance Summary',
              subtitle: 'Income, budget, and savings priorities.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _DashboardStatCard(
                    label: 'Total Income',
                    value: dashboard.financeTransactions.isEmpty
                        ? 'No entries'
                        : dashboard.financeMetrics.totalIncome.toStringAsFixed(0),
                    icon: Icons.trending_up_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Total Expense',
                    value: dashboard.financeTransactions.isEmpty
                        ? 'No entries'
                        : dashboard.financeMetrics.totalExpense.toStringAsFixed(0),
                    icon: Icons.trending_down_outlined,
                  ),
                  _DashboardStatCard(
                    label: 'Current Balance',
                    value: dashboard.financeTransactions.isEmpty
                        ? 'No entries'
                        : dashboard.financeMetrics.netBalance.toStringAsFixed(0),
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardSection(
              title: 'Finance Details',
              subtitle: 'Income, budget, and savings priorities.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (hasValue(profile.currency))
                    _DashboardStatCard(
                      label: 'Currency',
                      value: profile.currency,
                      icon: Icons.currency_exchange_outlined,
                    ),
                  if (hasValue(profile.monthlyIncome))
                    _DashboardStatCard(
                      label: 'Monthly Income',
                      value: profile.monthlyIncome,
                      icon: Icons.attach_money_outlined,
                    ),
                  if (hasValue(profile.monthlyBudget))
                    _DashboardStatCard(
                      label: 'Monthly Budget',
                      value: profile.monthlyBudget,
                      icon: Icons.wallet_outlined,
                    ),
                  if (hasValue(profile.savingsGoal))
                    _DashboardStatCard(
                      label: 'Savings Goal',
                      value: profile.savingsGoal,
                      icon: Icons.savings_outlined,
                    ),
                  if (profile.financialPriorities.isNotEmpty)
                    _DashboardStatCard(
                      label: 'Financial Priority',
                      value: profile.financialPriorities.first,
                      icon: Icons.priority_high_outlined,
                    ),
                  if (!hasAnyFinanceValue(profile))
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'No finance details were provided yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardSection(
              title: 'Productivity Summary',
              subtitle: 'Main goals, focus areas, and reminders.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (hasValue(profile.lifeGoals))
                    _DashboardStatCard(
                      label: 'Main Life Goal',
                      value: profile.lifeGoals,
                      icon: Icons.flag_outlined,
                    ),
                  if (hasValue(profile.learningGoals))
                    _DashboardStatCard(
                      label: 'Learning Goal',
                      value: profile.learningGoals,
                      icon: Icons.school_outlined,
                    ),
                  if (hasValue(profile.focusAreas))
                    _DashboardStatCard(
                      label: 'Daily Focus Area',
                      value: profile.focusAreas,
                      icon: Icons.center_focus_strong_outlined,
                    ),
                  if (hasValue(profile.reminderPreference))
                    _DashboardStatCard(
                      label: 'Reminder Preference',
                      value: profile.reminderPreference,
                      icon: Icons.notifications_outlined,
                    ),
                  if (!hasAnyProductivityValue(profile))
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'No productivity preferences were captured yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DashboardSection(
              title: 'Profile Summary',
              subtitle: 'The essentials from your onboarding profile.',
              child: ProfileSummaryCard(
                items: [
                  ProfileSummaryItem(label: 'Work Type', value: valueOrFallback(profile.workType, '')),
                  ProfileSummaryItem(label: 'Shift Type', value: valueOrFallback(profile.shiftType, '')),
                  ProfileSummaryItem(label: 'Occupation', value: valueOrFallback(profile.occupation, '')),
                  ProfileSummaryItem(label: 'Fitness Goal', value: valueOrFallback(profile.healthGoal, '')),
                  ProfileSummaryItem(label: 'Monthly Budget', value: valueOrFallback(profile.monthlyBudget, '')),
                  ProfileSummaryItem(label: 'AI Personality', value: valueOrFallback(profile.aiPersonality, '')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AiInsightCard(profile: profile),
            const SizedBox(height: 20),
            DashboardSection(
              title: 'Quick Actions',
              subtitle: 'Jump to your next focus area.',
              child: const QuickActions(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  const _DashboardStatCard({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: DashboardStatCard(
        label: label,
        value: value,
        icon: icon,
      ),
    );
  }
}

String displayName(OnboardingProfile profile) {
  if (profile.preferredName.trim().isNotEmpty) {
    return profile.preferredName;
  }
  if (profile.fullName.trim().isNotEmpty) {
    return profile.fullName;
  }
  return 'Knight';
}

String greetingForNow() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 18) {
    return 'Good Afternoon';
  }
  return 'Good Evening';
}

String formatDate(DateTime date) {
  const weekdays = <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  const months = <String>['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
}

String valueOrFallback(String value, String fallback) => value.trim().isEmpty ? fallback : value;

bool hasValue(String value) => value.trim().isNotEmpty;

bool hasAnyFinanceValue(OnboardingProfile profile) {
  return hasValue(profile.currency) ||
      hasValue(profile.monthlyIncome) ||
      hasValue(profile.monthlyBudget) ||
      hasValue(profile.savingsGoal) ||
      profile.financialPriorities.isNotEmpty;
}

bool hasAnyProductivityValue(OnboardingProfile profile) {
  return hasValue(profile.lifeGoals) ||
      hasValue(profile.learningGoals) ||
      hasValue(profile.focusAreas) ||
      hasValue(profile.reminderPreference);
}
