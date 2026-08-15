import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/intelligence/services/google_data_hub.dart';
import '../../../core/intelligence/services/cloud_sync_service.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/data_provider.dart';
import '../../../core/providers/storage_providers.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';

class ImportCenterScreen extends ConsumerWidget {
  const ImportCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(googleDataHubProvider);
    final hub = ref.read(googleDataHubProvider.notifier);
    final cloudStatus = ref.watch(cloudSyncServiceProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('DATA HUB', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          IconButton(
            icon: Icon(status == HubStatus.syncingHistorical || status == HubStatus.syncingIncremental ? Icons.stop_circle_rounded : Icons.play_arrow_rounded, color: DesignColors.accentBlue),
            onPressed: () => hub.startUnifiedSync(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white24),
            onPressed: () => hub.refreshStats(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<HubProgress>(
        stream: hub.progress,
        builder: (context, snapshot) {
          final progress = snapshot.data ?? HubProgress();
          
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildConnectionCard(status, hub),
              if (cloudStatus == CloudSyncStatus.syncing || status == HubStatus.syncingHistorical || status == HubStatus.syncingIncremental)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: LinearProgressIndicator(color: Colors.blueAccent),
                ),
              const SizedBox(height: 32),
              _buildPipelineObservability(progress),
              const SizedBox(height: 32),
              _buildSyncSettings(ref),
              const SizedBox(height: 32),
              _buildProviderList(ref),
              const SizedBox(height: 32),
              _buildSyncProgress(progress, status),
              const SizedBox(height: 32),
              _buildMetricGrid(progress, context),
              const SizedBox(height: 32),
              _buildManualImportSection(context, ref),
              const SizedBox(height: 32),
              _buildAdvancedSection(context),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPipelineObservability(HubProgress progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PIPELINE OBSERVABILITY', style: KnightTokens.label),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _obsCard('FETCHED', progress.fetchedCount.toString(), Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _obsCard('PARSED', progress.parsedCount.toString(), Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _obsCard('INDEXED', progress.persistedCount.toString(), Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _obsCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSyncSettings(WidgetRef ref) {
    final prefs = ref.watch(importPreferenceServiceProvider);
    final isAuto = prefs.isAutoSyncEnabled();
    final freq = prefs.getSyncFrequency();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SYNC ENGINE CONFIGURATION', style: KnightTokens.label),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Automatic Background Sync', style: TextStyle(fontSize: 14)),
                  Switch(
                    value: isAuto, 
                    onChanged: (val) => ref.read(dataProviderRegistryProvider.notifier).setAutoSyncEnabled(val),
                    activeThumbColor: Colors.blueAccent,
                  ),
                ],
              ),
              const Divider(height: 32, color: DesignColors.white05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sync Frequency', style: TextStyle(fontSize: 14)),
                  DropdownButton<String>(
                    value: freq,
                    dropdownColor: const Color(0xFF1A1A1A),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13),
                    items: ['hourly', 'daily', 'weekly'].map((f) => DropdownMenuItem(
                      value: f,
                      child: Text(f.toUpperCase()),
                    )).toList(),
                    onChanged: isAuto ? (val) {
                      if (val != null) ref.read(dataProviderRegistryProvider.notifier).setSyncFrequency(val);
                    } : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProviderList(WidgetRef ref) {
    final providers = ref.watch(dataProviderRegistryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CONNECTED SOURCES', style: KnightTokens.label),
        const SizedBox(height: 16),
        ...providers.map((p) => _ProviderTile(provider: p, onToggle: (val) {
           ref.read(dataProviderRegistryProvider.notifier).setConnectionIntent(p.id, val);
        })),
      ],
    );
  }

  Widget _buildConnectionCard(HubStatus status, GoogleDataHub hub) {
    bool isSyncing = status == HubStatus.syncingHistorical || status == HubStatus.syncingIncremental;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: isSyncing ? Colors.blue : Colors.green),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: isSyncing ? null : 1.0,
            strokeWidth: 2,
            color: isSyncing ? Colors.blueAccent : Colors.greenAccent,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                Text(
                  isSyncing ? 'SYNCHRONIZING INFRASTRUCTURE...' : 'GOOGLE INFRASTRUCTURE CONNECTED', 
                  style: const TextStyle(color: Colors.white38, fontSize: 10)
                ),
              ],
            ),
          ),
          if (status == HubStatus.disconnected || status == HubStatus.error)
            FilledButton(
              onPressed: () => hub.startUnifiedSync(),
              child: const Text('RECONNECT'),
            ),
        ],
      ),
    );
  }

  Widget _buildSyncProgress(HubProgress progress, HubStatus status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('HISTORICAL PIPELINE', style: KnightTokens.label),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusBox('YEAR', progress.currentYear == 0 ? '---' : progress.currentYear.toString()),
                  _statusBox('MONTH', progress.currentMonth == 0 ? '--' : progress.currentMonth.toString().padLeft(2, '0')),
                  _statusBox('SPEED', '40ms/msg'),
                ],
              ),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                value: status == HubStatus.syncingHistorical ? null : 1.0,
                backgroundColor: Colors.white10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricGrid(HubProgress progress, BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _metricCard('EMAILS', progress.emailsImported.toString(), Icons.email_rounded, Colors.blue, 
          onTap: () => context.push('/hub/emails')),
        _metricCard('CALENDAR', progress.calendarEvents.toString(), Icons.calendar_today_rounded, Colors.orange,
          onTap: () => context.push('/hub/calendar')),
        _metricCard('CONTACTS', progress.contacts.toString(), Icons.people_rounded, Colors.purple,
          onTap: () => context.push('/hub/contacts')),
        _metricCard('DRIVE FILES', progress.driveFiles.toString(), Icons.insert_drive_file_rounded, Colors.cyan,
          onTap: () => context.push('/hub/drive')),
        _metricCard('TASKS', progress.tasks.toString(), Icons.task_alt_rounded, Colors.green,
          onTap: () => context.push('/hub/tasks')),
        _metricCard('FINANCE', progress.transactions.toString(), Icons.account_balance_wallet_rounded, Colors.redAccent,
          onTap: () => context.push(AppRoutes.finance)),
        _metricCard('HEALTH', progress.healthRecords.toString(), Icons.favorite_rounded, Colors.pinkAccent,
          onTap: () => context.push(AppRoutes.health)),
      ],
    );
  }

  Widget _buildManualImportSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MANUAL IMPORT CENTER', style: KnightTokens.label),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _importButton('PDF', Icons.picture_as_pdf_rounded, () => _pickFile(context, ref, ['pdf'])),
            _importButton('CSV', Icons.table_chart_rounded, () => _pickFile(context, ref, ['csv'])),
            _importButton('IMAGE', Icons.image_rounded, () => _pickFile(context, ref, ['jpg', 'png'])),
            _importButton('CLOUD SYNC', Icons.cloud_upload_rounded, () => ref.read(cloudSyncServiceProvider.notifier).triggerSync()),
          ],
        ),
      ],
    );
  }

  Future<void> _pickFile(BuildContext context, WidgetRef ref, List<String> extensions) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      await ref.read(dataIngestionServiceProvider).importDocument(file);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Importing ${result.files.single.name}...')),
        );
      }
    }
  }

  Widget _metricCard(String label, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
            Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _statusBox(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
      ],
    );
  }

  Widget _importButton(String label, IconData icon, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAdvancedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DIAGNOSTICS & RECOVERY', style: KnightTokens.label),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.analytics_outlined, color: Colors.blueAccent),
          title: const Text('Google Data Audit', style: TextStyle(fontSize: 14)),
          subtitle: const Text('Verify consistency between Google and Knight.', style: TextStyle(fontSize: 11, color: Colors.white10)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
          onTap: () => context.push(AppRoutes.googleDataAudit),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.history_rounded, color: Colors.white24),
          title: const Text('Sync Engine Diagnostics', style: TextStyle(fontSize: 14)),
          subtitle: const Text('View low-level provider health and audit logs.', style: TextStyle(fontSize: 11, color: Colors.white10)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
          onTap: () => context.push(AppRoutes.integrations),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
          title: const Text('Full Pipeline Rebuild', style: TextStyle(fontSize: 14, color: Colors.redAccent)),
          subtitle: const Text('Clears all local data and restarts exhaustive sync.', style: TextStyle(fontSize: 11, color: Colors.white10)),
          onTap: () => _showRebuildConfirm(context),
        ),
      ],
    );
  }

  void _showRebuildConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Rebuild Pipeline?'),
        content: const Text('This will delete all local transactions, events, and records. It will trigger a full historical sync. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          FilledButton(
            onPressed: () {
               // Future: Implement destructive clear
               Navigator.pop(context);
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rebuild sequence initialized.')));
            }, 
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('REBUILD'),
          ),
        ],
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({required this.provider, required this.onToggle});
  final DataProvider provider;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    final isConnected = provider.status == ProviderStatus.connected || provider.status == ProviderStatus.syncing;
    final lastSync = provider.lastSuccessfulSync;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _getProviderIcon(provider.id),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      provider.status == ProviderStatus.syncing ? 'Syncing...' : 
                      (lastSync != null ? 'Last sync: ${DateFormat('MMM dd, HH:mm').format(lastSync)}' : 'Never synced'),
                      style: const TextStyle(fontSize: 11, color: Colors.white24),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isConnected, 
                onChanged: onToggle,
                activeThumbColor: Colors.blueAccent,
              ),
            ],
          ),
          if (provider.status == ProviderStatus.error && provider.lastError != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                provider.lastError!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 10),
              ),
            ),
          if (isConnected && (provider.stats.fetched > 0 || provider.stats.created > 0))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _miniStat('FETCHED', provider.stats.fetched),
                  _miniStat('CREATED', provider.stats.created),
                  _miniStat('SKIPPED', provider.stats.skipped),
                  _miniStat('FAILED', provider.stats.failed),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 7, color: Colors.white10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _getProviderIcon(String id) {
    IconData icon;
    Color color;
    if (id.contains('gmail')) { icon = Icons.email_rounded; color = Colors.blue; }
    else if (id.contains('calendar')) { icon = Icons.calendar_today_rounded; color = Colors.orange; }
    else if (id.contains('drive')) { icon = Icons.insert_drive_file_rounded; color = Colors.cyan; }
    else if (id.contains('health')) { icon = Icons.favorite_rounded; color = Colors.pink; }
    else if (id.contains('contacts')) { icon = Icons.people_rounded; color = Colors.purple; }
    else if (id.contains('tasks')) { icon = Icons.task_alt_rounded; color = Colors.green; }
    else { icon = Icons.hub_rounded; color = Colors.white24; }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
