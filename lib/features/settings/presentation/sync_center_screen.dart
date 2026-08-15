import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/app/widgets/knight_page_scaffold.dart';
import 'package:knight_os/core/design_system/knight_tokens.dart';
import 'package:knight_os/core/router/app_routes.dart';

class SyncCenterScreen extends ConsumerWidget {
  const SyncCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(knightDatabaseProvider);
    final historyFuture = (db.select(db.syncHistoryTable)..orderBy([(t) => OrderingTerm.desc(t.startTime)])..limit(50)).get();

    return KnightPageScaffold(
      title: 'Diagnostics',
      showBackButton: true,
      body: FutureBuilder<List<SyncHistoryData>>(
        future: historyFuture,
        builder: (context, snapshot) {
          final history = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(KnightTokens.spacingM),
            children: [
              _buildSummaryHeader(history),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.googleDataAudit),
                icon: const Icon(Icons.analytics_rounded),
                label: const Text('VIEW DATA CONSISTENCY AUDIT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                  foregroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              const Text('PIPELINE EXECUTION LOG', style: KnightTokens.label),
              const SizedBox(height: 16),
              if (history.isEmpty)
                const Center(child: Text('No sync history found.', style: TextStyle(color: Colors.white10)))
              else
                ...history.map((h) => _HistoryTile(data: h)),
              const SizedBox(height: 140),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(List<SyncHistoryData> history) {
    final failures = history.where((h) => h.status == 'failed').length;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: failures > 0 ? Colors.red : Colors.blue),
      child: Column(
        children: [
          Row(
            children: [
              Icon(failures > 0 ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded, 
                color: failures > 0 ? Colors.redAccent : Colors.greenAccent),
              const SizedBox(width: 16),
              Text(
                failures > 0 ? '$failures PIPELINE ISSUES' : 'PIPELINE NOMINAL',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.data});
  final SyncHistoryData data;

  @override
  Widget build(BuildContext context) {
    final isSuccess = data.status == 'success';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(data.providerId.split('_').first.toUpperCase(), 
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.blueAccent)),
              const Spacer(),
              Text(
                DateFormat('HH:mm:ss').format(data.startTime),
                style: const TextStyle(fontSize: 10, color: Colors.white24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isSuccess ? Icons.done_all_rounded : Icons.close_rounded, 
                size: 14, color: isSuccess ? Colors.greenAccent : Colors.redAccent),
              const SizedBox(width: 8),
              Text(data.status.toUpperCase(), 
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, 
                  color: isSuccess ? Colors.greenAccent : Colors.redAccent)),
            ],
          ),
          if (!isSuccess && data.errorSummary != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(data.errorSummary!, style: const TextStyle(fontSize: 10, color: Colors.white54)),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _count('F', data.fetchedCount),
              _count('C', data.createdCount),
              _count('U', data.updatedCount),
              _count('S', data.skippedCount),
              _count('X', data.failedCount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _count(String label, int val) {
    return Row(
      children: [
        Text('$label:', style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(val.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
