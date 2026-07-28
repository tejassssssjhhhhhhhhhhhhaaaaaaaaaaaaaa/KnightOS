import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../data/sleep_storage.dart';
import '../domain/sleep_session.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  final _storage = SleepStorage();
  final _uuid = const Uuid();

  final _dateController = TextEditingController();
  final _bedTimeController = TextEditingController();
  final _wakeTimeController = TextEditingController();
  final _qualityController = TextEditingController();
  final _wakeUpsController = TextEditingController();
  final _napController = TextEditingController();
  final _moodController = TextEditingController();
  final _energyController = TextEditingController();
  final _notesController = TextEditingController();

  String _searchQuery = '';
  String _selectedDateFilter = 'All';

  late final Future<List<SleepSession>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toIso8601String().split('T').first;
    _bedTimeController.text = '22:30';
    _wakeTimeController.text = '06:30';
    _qualityController.text = '8';
    _wakeUpsController.text = '1';
    _napController.text = '0';
    _moodController.text = 'Refreshed';
    _energyController.text = '7';
    _notesController.text = '';
    _sessionsFuture = _storage.loadSessions();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _bedTimeController.dispose();
    _wakeTimeController.dispose();
    _qualityController.dispose();
    _wakeUpsController.dispose();
    _napController.dispose();
    _moodController.dispose();
    _energyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Sleep Tracker',
      body: FutureBuilder<List<SleepSession>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data ?? <SleepSession>[];
          final filtered = _filterSessions(sessions);
          final averageSleep = _averageValue(
            sessions,
            (session) => session.sleepDuration,
          );
          final bestSleep = sessions.isEmpty
              ? 0.0
              : sessions
                    .map((session) => session.sleepDuration)
                    .reduce(math.max);
          final worstSleep = sessions.isEmpty
              ? 0.0
              : sessions
                    .map((session) => session.sleepDuration)
                    .reduce(math.min);
          final qualityTrend = sessions.isEmpty
              ? 0.0
              : sessions
                        .map((session) => session.sleepQuality)
                        .reduce((value, element) => value + element) /
                    sessions.length;
          final debtTrend = sessions.isEmpty
              ? 0.0
              : sessions
                        .map((session) => _sleepDebt(session))
                        .reduce((value, element) => value + element) /
                    sessions.length;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(
                  sessions,
                  averageSleep,
                  bestSleep,
                  worstSleep,
                  qualityTrend,
                  debtTrend,
                ),
                const SizedBox(height: 20),
                _buildLogForm(),
                const SizedBox(height: 20),
                _buildHistorySection(filtered),
                const SizedBox(height: 20),
                _buildAnalyticsSection(sessions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(
    List<SleepSession> sessions,
    double averageSleep,
    double bestSleep,
    double worstSleep,
    double qualityTrend,
    double debtTrend,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MetricCard(
          title: 'Average Sleep',
          value: '${averageSleep.toStringAsFixed(1)}h',
          icon: Icons.bedtime_outlined,
        ),
        _MetricCard(
          title: 'Best Sleep',
          value: '${bestSleep.toStringAsFixed(1)}h',
          icon: Icons.thumb_up_outlined,
        ),
        _MetricCard(
          title: 'Worst Sleep',
          value: '${worstSleep.toStringAsFixed(1)}h',
          icon: Icons.thumb_down_outlined,
        ),
        _MetricCard(
          title: 'Sleep Quality Trend',
          value: qualityTrend.toStringAsFixed(1),
          icon: Icons.auto_awesome_outlined,
        ),
        _MetricCard(
          title: 'Sleep Debt Trend',
          value: debtTrend.toStringAsFixed(1),
          icon: Icons.notifications_active_outlined,
        ),
      ],
    );
  }

  Widget _buildLogForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log a sleep session',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTextField('Sleep Date', _dateController),
              _buildTextField('Bed Time', _bedTimeController),
              _buildTextField('Wake Time', _wakeTimeController),
              _buildTextField(
                'Sleep Quality (1–10)',
                _qualityController,
                isNumber: true,
              ),
              _buildTextField('Wake-ups', _wakeUpsController, isNumber: true),
              _buildTextField('Nap Duration', _napController, isNumber: true),
              _buildTextField('Mood After Waking', _moodController),
              _buildTextField(
                'Energy Level',
                _energyController,
                isNumber: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saveSession,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Sleep'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<SleepSession> sessions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'History',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_outlined),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Search sessions'),
            onChanged: (value) =>
                setState(() => _searchQuery = value.toLowerCase()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedDateFilter,
            items: ['All', 'Today', 'Week', 'Month']
                .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _selectedDateFilter = value ?? 'All'),
            decoration: const InputDecoration(labelText: 'Filter by date'),
          ),
          const SizedBox(height: 16),
          if (sessions.isEmpty)
            Text(
              'No sleep sessions logged yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            ...sessions.map(
              (session) => Card(
                child: ListTile(
                  title: Text(
                    '${session.sleepDate} · ${session.moodAfterWaking}',
                  ),
                  subtitle: Text(
                    '${session.sleepDuration.toStringAsFixed(1)}h • ${session.sleepQuality}/10 quality • ${session.wakeUps} wake-ups',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _editSession(session),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteSession(session.id),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(List<SleepSession> sessions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricCard(
                title: 'Average Sleep',
                value: _averageValue(
                  sessions,
                  (session) => session.sleepDuration,
                ).toStringAsFixed(1),
                icon: Icons.bedtime_outlined,
              ),
              _MetricCard(
                title: 'Best Sleep',
                value: _bestValue(
                  sessions,
                  (session) => session.sleepDuration,
                ).toStringAsFixed(1),
                icon: Icons.thumb_up_outlined,
              ),
              _MetricCard(
                title: 'Worst Sleep',
                value: _worstValue(
                  sessions,
                  (session) => session.sleepDuration,
                ).toStringAsFixed(1),
                icon: Icons.thumb_down_outlined,
              ),
              _MetricCard(
                title: 'Sleep Quality Trend',
                value: _averageValue(
                  sessions,
                  (session) => session.sleepQuality,
                ).toStringAsFixed(1),
                icon: Icons.auto_awesome_outlined,
              ),
              _MetricCard(
                title: 'Sleep Debt Trend',
                value: _averageValue(
                  sessions,
                  (session) => _sleepDebt(session),
                ).toStringAsFixed(1),
                icon: Icons.notifications_active_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return SizedBox(
      width: 240,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  List<SleepSession> _filterSessions(List<SleepSession> sessions) {
    var filtered = sessions.where((session) {
      final matchesQuery =
          session.notes.toLowerCase().contains(_searchQuery) ||
          session.moodAfterWaking.toLowerCase().contains(_searchQuery) ||
          session.sleepDate.contains(_searchQuery);
      return matchesQuery;
    }).toList();

    if (_selectedDateFilter == 'Today') {
      final today = DateTime.now().toIso8601String().split('T').first;
      filtered = filtered
          .where((session) => session.sleepDate == today)
          .toList();
    } else if (_selectedDateFilter == 'Week') {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      filtered = filtered.where((session) {
        final date = DateTime.parse(session.sleepDate);
        return !date.isBefore(weekStart) && !date.isAfter(now);
      }).toList();
    } else if (_selectedDateFilter == 'Month') {
      final now = DateTime.now();
      filtered = filtered.where((session) {
        final date = DateTime.parse(session.sleepDate);
        return date.year == now.year && date.month == now.month;
      }).toList();
    }
    return filtered;
  }

  Future<void> _saveSession() async {
    final session = _buildSession();
    await _storage.saveSession(session);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sleep session saved.')));
    }
    setState(() {});
  }

  SleepSession _buildSession() {
    final bedTime = _parseTime(_bedTimeController.text);
    final wakeTime = _parseTime(_wakeTimeController.text);
    final durationHours = _calculateDurationHours(bedTime, wakeTime);
    final quality = int.tryParse(_qualityController.text) ?? 0;
    final wakeUps = int.tryParse(_wakeUpsController.text) ?? 0;
    final nap = double.tryParse(_napController.text) ?? 0;
    final energy = int.tryParse(_energyController.text) ?? 0;

    return SleepSession(
      id: _uuid.v4(),
      sleepDate: _dateController.text.trim(),
      bedTime: _bedTimeController.text.trim(),
      wakeTime: _wakeTimeController.text.trim(),
      sleepQuality: quality,
      wakeUps: wakeUps,
      napDuration: nap,
      moodAfterWaking: _moodController.text.trim(),
      energyLevel: energy,
      notes: _notesController.text.trim(),
      sleepDuration: durationHours,
    );
  }

  double _calculateDurationHours(DateTime? bedTime, DateTime? wakeTime) {
    if (bedTime == null || wakeTime == null) {
      return 0;
    }
    var hours = wakeTime.difference(bedTime).inMinutes / 60;
    if (hours < 0) {
      hours += 24;
    }
    return hours.clamp(0, 16).toDouble();
  }

  DateTime? _parseTime(String input) {
    final parts = input.trim().split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return DateTime(2000, 1, 1, hour, minute);
  }

  Future<void> _editSession(SleepSession session) async {
    _dateController.text = session.sleepDate;
    _bedTimeController.text = session.bedTime;
    _wakeTimeController.text = session.wakeTime;
    _qualityController.text = session.sleepQuality.toString();
    _wakeUpsController.text = session.wakeUps.toString();
    _napController.text = session.napDuration.toString();
    _moodController.text = session.moodAfterWaking;
    _energyController.text = session.energyLevel.toString();
    _notesController.text = session.notes;
    setState(() {});
  }

  Future<void> _deleteSession(String id) async {
    await _storage.deleteSession(id);
    setState(() {});
  }

  double _averageValue(
    List<SleepSession> sessions,
    num Function(SleepSession) selector,
  ) {
    if (sessions.isEmpty) {
      return 0;
    }
    final sum = sessions.fold<double>(
      0,
      (value, session) => value + selector(session).toDouble(),
    );
    return sum / sessions.length;
  }

  double _bestValue(
    List<SleepSession> sessions,
    num Function(SleepSession) selector,
  ) {
    if (sessions.isEmpty) {
      return 0;
    }
    return sessions
        .map((session) => selector(session).toDouble())
        .reduce(math.max);
  }

  double _worstValue(
    List<SleepSession> sessions,
    num Function(SleepSession) selector,
  ) {
    if (sessions.isEmpty) {
      return 0;
    }
    return sessions
        .map((session) => selector(session).toDouble())
        .reduce(math.min);
  }

  double _sleepDebt(SleepSession session) {
    final target = 8.0;
    return math.max(0, target - session.sleepDuration);
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 190,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
