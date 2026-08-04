import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'controllers/finance_settings_controller.dart';

class FinanceSettingsScreen extends ConsumerWidget {
  const FinanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(financeSettingsProvider);
    final notifier = ref.read(financeSettingsProvider.notifier);

    return KnightPageScaffold(
      title: 'Finance Settings',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionHeader(title: 'GMAIL CONNECTION'),
          ListTile(
            title: const Text('Gmail Integration', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Connected as user@gmail.com', style: TextStyle(fontSize: 10, color: Colors.white24)),
            trailing: TextButton(onPressed: () {}, child: const Text('RECONNECT')),
          ),
          const Divider(color: Colors.white10),
          
          _SectionHeader(title: 'SYNCHRONIZATION'),
          SwitchListTile(
            title: const Text('Smart Sync', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Intelligent background data fusion.', style: TextStyle(fontSize: 10, color: Colors.white24)),
            value: settings.isSmartSyncEnabled,
            onChanged: notifier.toggleSmartSync,
          ),
          SwitchListTile(
            title: const Text('Automatic Sync', style: TextStyle(fontSize: 14)),
            value: settings.isAutoSyncEnabled,
            onChanged: notifier.toggleAutoSync,
          ),
          ListTile(
            title: const Text('Sync Frequency', style: TextStyle(fontSize: 14)),
            trailing: DropdownButton<String>(
              value: settings.syncFrequency,
              underline: const SizedBox(),
              items: ['daily', 'weekly', 'monthly'].map((f) => DropdownMenuItem(value: f, child: Text(f.toUpperCase()))).toList(),
              onChanged: (v) => notifier.setSyncFrequency(v!),
            ),
          ),
          const Divider(color: Colors.white10),

          _SectionHeader(title: 'NOTIFICATIONS'),
          _ToggleTile(title: 'Finance Inbox Alerts', value: settings.notifyInbox, onChanged: notifier.toggleNotifyInbox),
          _ToggleTile(title: 'Budget Thresholds', value: settings.notifyBudgets, onChanged: notifier.toggleNotifyBudgets),
          _ToggleTile(title: 'Goal Milestones', value: settings.notifyGoals, onChanged: notifier.toggleNotifyGoals),
          _ToggleTile(title: 'AI Analytical Insights', value: settings.notifyAiInsights, onChanged: notifier.toggleNotifyAiInsights),
          const Divider(color: Colors.white10),

          _SectionHeader(title: 'PRIVACY & DATA'),
          ListTile(
            title: const Text('Evidence Retention', style: TextStyle(fontSize: 14)),
            trailing: DropdownButton<int>(
              value: settings.evidenceRetentionDays,
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: 0, child: Text('INDEFINITE')),
                const DropdownMenuItem(value: 30, child: Text('30 DAYS')),
                const DropdownMenuItem(value: 90, child: Text('90 DAYS')),
                const DropdownMenuItem(value: 365, child: Text('1 YEAR')),
              ],
              onChanged: (v) => notifier.setEvidenceRetention(v!),
            ),
          ),
          const Divider(color: Colors.white10),

          _SectionHeader(title: 'AUTOMATION'),
          _ToggleTile(title: 'Automatic Monthly Reports', value: settings.isAutoReportEnabled, onChanged: notifier.toggleAutoReport),
          const Divider(color: Colors.white10),

          _SectionHeader(title: 'DEVELOPER'),
          _ToggleTile(title: 'Developer Mode', value: settings.isDeveloperMode, onChanged: notifier.toggleDeveloperMode),
          if (settings.isDeveloperMode) ...[
            ListTile(
              title: const Text('Run Platform Repair', style: TextStyle(fontSize: 14, color: Colors.orangeAccent)),
              trailing: const Icon(Icons.build_circle_rounded, color: Colors.orangeAccent),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Export Platform Audit', style: TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.file_download_rounded),
              onTap: () {},
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title, style: KnightTokens.label.copyWith(color: Colors.blueAccent)),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({required this.title, required this.value, required this.onChanged});
  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
    );
  }
}
