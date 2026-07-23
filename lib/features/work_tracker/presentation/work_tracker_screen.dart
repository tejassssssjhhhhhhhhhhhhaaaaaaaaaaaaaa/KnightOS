import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../data/work_storage.dart';
import '../domain/work_session.dart';

final workSessionsProvider = FutureProvider<List<WorkSession>>((ref) async {
  final storage = WorkStorage();
  return storage.loadSessions();
});

class WorkTrackerScreen extends ConsumerStatefulWidget {
  const WorkTrackerScreen({super.key});

  @override
  ConsumerState<WorkTrackerScreen> createState() => _WorkTrackerScreenState();
}

class _WorkTrackerScreenState extends ConsumerState<WorkTrackerScreen> {
  final _storage = WorkStorage();
  final _uuid = const Uuid();

  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _shiftController = TextEditingController();
  final _questionsController = TextEditingController();
  final _callsController = TextEditingController();
  final _chatsController = TextEditingController();
  final _breakController = TextEditingController();
  final _focusController = TextEditingController();
  final _stressController = TextEditingController();
  final _energyController = TextEditingController();
  final _notesController = TextEditingController();

  String _searchQuery = '';
  String _selectedDateFilter = 'All';
  List<WorkSession> _editingSessions = <WorkSession>[];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toIso8601String().split('T').first;
    _startTimeController.text = '09:00';
    _endTimeController.text = '17:00';
    _shiftController.text = 'Day Shift';
    _questionsController.text = '0';
    _callsController.text = '0';
    _chatsController.text = '0';
    _breakController.text = '0';
    _focusController.text = '8';
    _stressController.text = '4';
    _energyController.text = '7';
    _notesController.text = '';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _shiftController.dispose();
    _questionsController.dispose();
    _callsController.dispose();
    _chatsController.dispose();
    _breakController.dispose();
    _focusController.dispose();
    _stressController.dispose();
    _energyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(workSessionsProvider);
    return KnightPageScaffold(
      title: 'Work Tracker',
      body: sessionsAsync.when(
        data: (sessions) {
          final filtered = _filterSessions(sessions);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(sessions),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Unable to load work logs: $error')),
      ),
    );
  }

  Widget _buildSummaryCards(List<WorkSession> sessions) {
    final today = DateTime.now().toIso8601String().split('T').first;
    final todaySession = sessions.where((session) => session.workDate == today).toList();
    final totalHours = todaySession.fold<double>(0, (sum, item) => sum + item.totalHours);
    final questions = todaySession.fold<int>(0, (sum, item) => sum + item.questionsCompleted);
    final focus = todaySession.isEmpty ? 0 : todaySession.map((item) => item.focusRating).reduce((a, b) => a + b) / todaySession.length;
    final productivity = todaySession.isEmpty ? 0 : todaySession.map((item) => item.productiveHours).reduce((a, b) => a + b) / todaySession.length;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MetricCard(title: 'Today\'s Questions', value: '$questions', icon: Icons.question_answer_outlined),
        _MetricCard(title: 'Hours Worked', value: '${totalHours.toStringAsFixed(1)}h', icon: Icons.schedule_outlined),
        _MetricCard(title: 'Current Productivity', value: '${productivity.toStringAsFixed(1)}h', icon: Icons.insights_outlined),
        _MetricCard(title: 'Today\'s Focus', value: focus.toStringAsFixed(1), icon: Icons.center_focus_strong_outlined),
      ],
    );
  }

  Widget _buildLogForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log a session', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTextField('Work Date', _dateController),
              _buildTextField('Start Time', _startTimeController),
              _buildTextField('End Time', _endTimeController),
              _buildTextField('Shift Type', _shiftController),
              _buildTextField('Questions Completed', _questionsController, isNumber: true),
              _buildTextField('Calls Handled', _callsController, isNumber: true),
              _buildTextField('Chats Handled', _chatsController, isNumber: true),
              _buildTextField('Break Duration', _breakController, isNumber: true),
              _buildTextField('Focus Rating (1–10)', _focusController, isNumber: true),
              _buildTextField('Stress Rating (1–10)', _stressController, isNumber: true),
              _buildTextField('Energy Rating (1–10)', _energyController, isNumber: true),
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
            label: const Text('Save Session'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<WorkSession> sessions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
              IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Search sessions'),
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedDateFilter,
            items: ['All', 'Today', 'Week', 'Month']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) => setState(() => _selectedDateFilter = value ?? 'All'),
            decoration: const InputDecoration(labelText: 'Filter by date'),
          ),
          const SizedBox(height: 16),
          if (sessions.isEmpty)
            Text('No sessions logged yet.', style: Theme.of(context).textTheme.bodyMedium)
          else
            ...sessions.map((session) => Card(
                  child: ListTile(
                    title: Text('${session.workDate} · ${session.shiftType}'),
                    subtitle: Text('${session.totalHours.toStringAsFixed(1)}h • ${session.questionsCompleted} questions • ${session.focusRating}/10 focus'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _editSession(session)),
                        IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _deleteSession(session.id)),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(List<WorkSession> sessions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricCard(title: 'Questions per Day', value: _averageValue(sessions, (session) => session.questionsCompleted).toStringAsFixed(1), icon: Icons.bar_chart_outlined),
              _MetricCard(title: 'Hours Worked', value: _averageValue(sessions, (session) => session.totalHours).toStringAsFixed(1), icon: Icons.timeline_outlined),
              _MetricCard(title: 'Focus Trend', value: _averageValue(sessions, (session) => session.focusRating).toStringAsFixed(1), icon: Icons.trending_up_outlined),
              _MetricCard(title: 'Stress Trend', value: _averageValue(sessions, (session) => session.stressRating).toStringAsFixed(1), icon: Icons.trending_down_outlined),
              _MetricCard(title: 'Weekly Productivity', value: _averageValue(sessions, (session) => session.productiveHours).toStringAsFixed(1), icon: Icons.auto_graph_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return SizedBox(
      width: 240,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  List<WorkSession> _filterSessions(List<WorkSession> sessions) {
    var filtered = sessions.where((session) {
      final matchesQuery = session.notes.toLowerCase().contains(_searchQuery) ||
          session.shiftType.toLowerCase().contains(_searchQuery) ||
          session.workDate.contains(_searchQuery);
      return matchesQuery;
    }).toList();

    if (_selectedDateFilter == 'Today') {
      final today = DateTime.now().toIso8601String().split('T').first;
      filtered = filtered.where((session) => session.workDate == today).toList();
    } else if (_selectedDateFilter == 'Week') {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      filtered = filtered.where((session) {
        final date = DateTime.parse(session.workDate);
        return !date.isBefore(weekStart) && !date.isAfter(now);
      }).toList();
    } else if (_selectedDateFilter == 'Month') {
      final now = DateTime.now();
      filtered = filtered.where((session) {
        final date = DateTime.parse(session.workDate);
        return date.year == now.year && date.month == now.month;
      }).toList();
    }
    return filtered;
  }

  Future<void> _saveSession() async {
    final session = _buildSession();
    await _storage.saveSession(session);
    ref.invalidate(workSessionsProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Work session saved.')));
    }
  }

  WorkSession _buildSession() {
    final totalHours = _calculateDurationHours();
    final productiveHours = totalHours * 0.8;
    final calls = int.tryParse(_callsController.text) ?? 0;
    final chats = int.tryParse(_chatsController.text) ?? 0;
    final questions = int.tryParse(_questionsController.text) ?? 0;
    final totalInteractions = calls + chats;
    final callsPercentage = totalInteractions == 0 ? 0.0 : (calls / totalInteractions) * 100;
    final chatsPercentage = totalInteractions == 0 ? 0.0 : (chats / totalInteractions) * 100;
    final questionsPerHour = totalHours == 0 ? 0.0 : questions / totalHours;
    final weeklyAverage = questions.toDouble();
    final monthlyAverage = questions.toDouble();

    return WorkSession(
      id: _uuid.v4(),
      workDate: _dateController.text.trim(),
      startTime: _startTimeController.text.trim(),
      endTime: _endTimeController.text.trim(),
      shiftType: _shiftController.text.trim(),
      questionsCompleted: questions,
      callsHandled: calls,
      chatsHandled: chats,
      breakDuration: int.tryParse(_breakController.text) ?? 0,
      focusRating: int.tryParse(_focusController.text) ?? 0,
      stressRating: int.tryParse(_stressController.text) ?? 0,
      energyRating: int.tryParse(_energyController.text) ?? 0,
      notes: _notesController.text.trim(),
      totalHours: totalHours,
      productiveHours: productiveHours,
      callsPercentage: callsPercentage,
      chatsPercentage: chatsPercentage,
      questionsPerHour: questionsPerHour,
      weeklyAverage: weeklyAverage,
      monthlyAverage: monthlyAverage,
    );
  }

  double _calculateDurationHours() {
    final start = _parseTime(_startTimeController.text);
    final end = _parseTime(_endTimeController.text);
    final breakMinutes = int.tryParse(_breakController.text) ?? 0;
    if (start == null || end == null) {
      return 0;
    }
    var minutes = end.difference(start).inMinutes;
    if (minutes < 0) {
      minutes += 24 * 60;
    }
    return math.max(0, minutes - breakMinutes) / 60;
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

  Future<void> _editSession(WorkSession session) async {
    _dateController.text = session.workDate;
    _startTimeController.text = session.startTime;
    _endTimeController.text = session.endTime;
    _shiftController.text = session.shiftType;
    _questionsController.text = session.questionsCompleted.toString();
    _callsController.text = session.callsHandled.toString();
    _chatsController.text = session.chatsHandled.toString();
    _breakController.text = session.breakDuration.toString();
    _focusController.text = session.focusRating.toString();
    _stressController.text = session.stressRating.toString();
    _energyController.text = session.energyRating.toString();
    _notesController.text = session.notes;
    setState(() {});
  }

  Future<void> _deleteSession(String id) async {
    await _storage.deleteSession(id);
    ref.invalidate(workSessionsProvider);
  }

  double _averageValue(List<WorkSession> sessions, num Function(WorkSession) selector) {
    if (sessions.isEmpty) {
      return 0;
    }
    final sum = sessions.fold<double>(0, (value, session) => value + selector(session));
    return sum / sessions.length;
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon, super.key});

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
            Text(title, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
