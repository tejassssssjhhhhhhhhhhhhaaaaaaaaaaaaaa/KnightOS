import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/dashboard_section.dart';
import '../../../app/widgets/dashboard_stat_card.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../domain/work_profile.dart';
import '../domain/work_session.dart';
import '../work_tracker_controller.dart';

class WorkIntelligenceScreen extends ConsumerStatefulWidget {
  const WorkIntelligenceScreen({super.key});

  @override
  ConsumerState<WorkIntelligenceScreen> createState() =>
      _WorkIntelligenceScreenState();
}

class _WorkIntelligenceScreenState
    extends ConsumerState<WorkIntelligenceScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moduleStateAsync = ref.watch(workModuleStateProvider);
    return KnightPageScaffold(
      title: 'Work Intelligence',
      body: moduleStateAsync.when(
        data: (moduleState) {
          final sessions = moduleState.sessions;
          final filteredSessions = _searchQuery.isEmpty
              ? sessions
              : sessions
                    .where(
                      (session) =>
                          session.workDate.contains(_searchQuery) ||
                          session.shiftType.toLowerCase().contains(
                            _searchQuery,
                          ) ||
                          session.notes.toLowerCase().contains(_searchQuery),
                    )
                    .toList();
          final today = DateTime.now().toIso8601String().split('T').first;
          final todaySessions = filteredSessions
              .where((session) => session.workDate == today)
              .toList();
          final profile = moduleState.profile;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileOverview(context, profile),
                const SizedBox(height: 24),
                _buildSearchBar(context),
                const SizedBox(height: 24),
                _buildTodayWorkSection(context, todaySessions),
                const SizedBox(height: 24),
                _buildAnalyticsSection(context, filteredSessions),
                const SizedBox(height: 24),
                _buildQuickActionCards(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Unable to load work intelligence: $error')),
      ),
    );
  }

  Widget _buildProfileOverview(BuildContext context, WorkProfile profile) {
    final theme = Theme.of(context);
    return DashboardSection(
      title: 'Work Profile',
      subtitle: 'Your professional details and current role.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.companyName.isEmpty
                ? 'No company configured yet'
                : profile.companyName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile.jobTitle.isEmpty ? 'No job title set' : profile.jobTitle,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoChip(
                context,
                'Employment',
                profile.employmentType.isEmpty
                    ? 'Not set'
                    : profile.employmentType,
              ),
              _buildInfoChip(
                context,
                'Joined',
                profile.joiningDate.isEmpty ? 'Not set' : profile.joiningDate,
              ),
              _buildInfoChip(
                context,
                'Location',
                profile.workLocation.isEmpty ? 'Not set' : profile.workLocation,
              ),
              _buildInfoChip(
                context,
                'Shift',
                profile.shiftType.isEmpty ? 'Not set' : profile.shiftType,
              ),
            ],
          ),
          if (profile.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(profile.notes, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return DashboardSection(
      title: 'Search Work History',
      subtitle: 'Find sessions by date, shift, or notes.',
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search work sessions...',
          prefixIcon: const Icon(Icons.search_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
        ),
        onChanged: (value) =>
            setState(() => _searchQuery = value.trim().toLowerCase()),
      ),
    );
  }

  Widget _buildTodayWorkSection(
    BuildContext context,
    List<WorkSession> todaySessions,
  ) {
    return DashboardSection(
      title: 'Today\'s Work',
      subtitle: 'Track today\'s shift and performance at a glance.',
      child: todaySessions.isEmpty
          ? Center(
              child: Text(
                'No work session logged for today.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : Wrap(
              spacing: 16,
              runSpacing: 16,
              children: todaySessions.map((session) {
                return SizedBox(
                  width: 260,
                  child: DashboardStatCard(
                    label: '${session.startTime} — ${session.endTime}',
                    value:
                        '${session.totalHours.toStringAsFixed(1)}h • ${session.questionsCompleted} Q • ${session.callsHandled} C • ${session.chatsHandled} T',
                    icon: Icons.work_outline_rounded,
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildAnalyticsSection(
    BuildContext context,
    List<WorkSession> sessions,
  ) {
    return DashboardSection(
      title: 'Work Analytics',
      subtitle: 'Placeholder metrics for work performance and productivity.',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Productivity Trend',
              value: '--',
              icon: Icons.trending_up_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Weekly Summary',
              value: 'Pending',
              icon: Icons.calendar_view_week_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Monthly Summary',
              value: 'Pending',
              icon: Icons.calendar_view_month_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Work Streak',
              value: '0 days',
              icon: Icons.local_fire_department_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Goal Progress',
              value: 'Initializing',
              icon: Icons.flag_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Average Questions',
              value: '--',
              icon: Icons.question_answer_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Average Calls',
              value: '--',
              icon: Icons.call_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Average Chats',
              value: '--',
              icon: Icons.chat_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards(BuildContext context) {
    return DashboardSection(
      title: 'Quick Actions',
      subtitle: 'Common work tasks and shortcuts.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: const [
          _ActionCard(label: 'Start Shift', icon: Icons.play_arrow_outlined),
          _ActionCard(label: 'End Shift', icon: Icons.stop_outlined),
          _ActionCard(label: 'Add Work Log', icon: Icons.add_outlined),
          _ActionCard(label: 'View History', icon: Icons.history_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, String value) {
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: FilledButton.tonal(
        onPressed: () {},
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
