import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/intelligence/services/google_data_hub.dart';
import '../../../core/intelligence/services/cloud_sync_service.dart';
import '../../../core/intelligence/providers/data_providers.dart';
import '../../../core/design_system/knight_tokens.dart';

class ImportCenterScreen extends ConsumerWidget {
  const ImportCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(googleDataHubProvider);
    final hub = ref.read(googleDataHubProvider.notifier);
    final cloudStatus = ref.watch(cloudSyncServiceProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('DATA HUB', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          IconButton(
            icon: Icon(status == HubStatus.syncingHistorical || status == HubStatus.syncingIncremental ? Icons.stop_circle_rounded : Icons.play_arrow_rounded),
            onPressed: () => hub.startUnifiedSync(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => hub.refreshStats(),
          ),
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
              if (cloudStatus == CloudSyncStatus.syncing)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: LinearProgressIndicator(color: Colors.greenAccent),
                ),
              const SizedBox(height: 32),
              _buildSyncProgress(progress, status),
              const SizedBox(height: 32),
              _buildMetricGrid(progress),
              const SizedBox(height: 32),
              _buildManualImportSection(context, ref),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
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
                const Text('GOOGLE INFRASTRUCTURE CONNECTED', style: TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          if (status == HubStatus.disconnected)
            FilledButton(
              onPressed: () => hub.startUnifiedSync(),
              child: const Text('CONNECT'),
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
                  _statusBox('YEAR', progress.currentYear.toString()),
                  _statusBox('MONTH', progress.currentMonth.toString().padLeft(2, '0')),
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

  Widget _buildMetricGrid(HubProgress progress) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _metricCard('EMAILS', progress.emailsImported.toString(), Icons.email_rounded, Colors.blue),
        _metricCard('CALENDAR', progress.calendarEvents.toString(), Icons.calendar_today_rounded, Colors.orange),
        _metricCard('CONTACTS', progress.contacts.toString(), Icons.people_rounded, Colors.purple),
        _metricCard('DRIVE FILES', progress.driveFiles.toString(), Icons.insert_drive_file_rounded, Colors.cyan),
        _metricCard('TASKS', progress.tasks.toString(), Icons.task_alt_rounded, Colors.green),
        _metricCard('FINANCE', progress.transactions.toString(), Icons.account_balance_wallet_rounded, Colors.redAccent),
        _metricCard('HEALTH', progress.healthRecords.toString(), Icons.favorite_rounded, Colors.pinkAccent),
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

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Container(
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
}
