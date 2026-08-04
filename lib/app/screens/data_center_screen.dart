import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/knight_tokens.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';
import '../../core/intelligence/services/dataset_verification_service.dart';
import '../../core/internal/storage/drift/knight_database.dart';
import '../../core/providers/database_provider.dart';
import '../widgets/knight_page_scaffold.dart';

class DataCenterScreen extends ConsumerWidget {
  const DataCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importsAsync = ref.watch(_importHistoryProvider);
    final verificationAsync = ref.watch(_verificationReportProvider);

    return KnightPageScaffold(
      title: 'Data Center',
      showBackButton: true,
      body: CustomScrollView(
        slivers: [
          // 1. Coverage Overview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(KnightTokens.spacingM),
              child: verificationAsync.when(
                data: (report) => _DataCoverageCard(report: report),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Verification Error: $e'),
              ),
            ),
          ),
          
          // 2. Technical Health
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KnightTokens.spacingM),
              child: verificationAsync.when(
                data: (report) => _TechnicalHealthGrid(report: report),
                loading: () => const SizedBox.shrink(),
                error: (e, s) => const SizedBox.shrink(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 3. Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KnightTokens.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'VERIFY DATA',
                      icon: Icons.fact_check_rounded,
                      onPressed: () => ref.invalidate(_verificationReportProvider),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'RE-INDEX ALL',
                      icon: Icons.refresh_rounded,
                      onPressed: () => _nukeAndReindex(context, ref),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(KnightTokens.spacingM, 40, KnightTokens.spacingM, 16),
              child: Text('IMPORT HISTORY', style: KnightTokens.label),
            ),
          ),

          // 4. Import History List
          importsAsync.when(
            data: (imports) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final imp = imports[index];
                  return _ImportHistoryTile(imp: imp);
                },
                childCount: imports.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }

  Future<void> _triggerImport(BuildContext context, WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(const SnackBar(content: Text('Starting Ingestion...')));
    try {
      await ref.read(dataIngestionServiceProvider).runFullIngestion();
      if (!context.mounted) return;
      ref.invalidate(_importHistoryProvider);
      ref.invalidate(_verificationReportProvider);
      scaffold.showSnackBar(const SnackBar(content: Text('Ingestion Complete')));
    } catch (e) {
      if (!context.mounted) return;
      scaffold.showSnackBar(SnackBar(content: Text('Ingestion Failed: $e'), backgroundColor: Colors.redAccent));
    }
  }

  Future<void> _nukeAndReindex(BuildContext context, WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(const SnackBar(content: Text('Nuking Database...')));
    try {
      final db = ref.read(knightDatabaseProvider);
      await db.transaction(() async {
        await db.customStatement('DELETE FROM transactions');
        await db.customStatement('DELETE FROM health_metrics');
        await db.customStatement('DELETE FROM timeline_events');
        await db.customStatement('DELETE FROM import_history');
        await db.customStatement('DELETE FROM graph_nodes');
        await db.customStatement('DELETE FROM graph_edges');
      });
      if (!context.mounted) return;
      await _triggerImport(context, ref);
    } catch (e) {
      if (!context.mounted) return;
      scaffold.showSnackBar(SnackBar(content: Text('Nuke Failed: $e'), backgroundColor: Colors.redAccent));
    }
  }
}

final _importHistoryProvider = FutureProvider<List<ImportHistoryData>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  return db.importDao.getAllImports();
});

final _verificationReportProvider = FutureProvider<VerificationReport>((ref) async {
  final service = ref.watch(datasetVerificationServiceProvider);
  return service.runVerification('knight_knowledge_base');
});

class _DataCoverageCard extends StatelessWidget {
  const _DataCoverageCard({required this.report});
  final VerificationReport report;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.05),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('KNOWLEDGE COVERAGE', style: KnightTokens.label.copyWith(color: Colors.blueAccent)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(100)),
                child: Text('${report.coveragePercentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(label: 'TOTAL FILES', value: '${report.totalFiles}'),
              _Stat(label: 'SUPPORTED', value: '${report.supportedFiles}'),
              _Stat(label: 'IMPORTED', value: '${report.importedFiles}'),
              _Stat(label: 'MISSING', value: '${report.missingFiles}', color: report.missingFiles > 0 ? Colors.orangeAccent : null),
            ],
          ),
          if (report.missingRecommendations.isNotEmpty) ...[
            const SizedBox(height: 32),
            const Divider(color: Colors.white10),
            const SizedBox(height: 20),
            ...report.missingRecommendations.map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.orangeAccent),
                  const SizedBox(width: 12),
                  Expanded(child: Text(rec, style: const TextStyle(fontSize: 12, color: Colors.white60, height: 1.4))),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}

class _TechnicalHealthGrid extends StatelessWidget {
  const _TechnicalHealthGrid({required this.report});
  final VerificationReport report;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _HealthItem(label: 'Parser Health', value: report.parserHealth),
        _HealthItem(label: 'AI Index', value: report.aiIndexStatus),
        _HealthItem(label: 'Graph Status', value: report.graphStatus),
        _HealthItem(label: 'Duplicates', value: '${report.duplicateFiles} Found', isWarning: report.duplicateFiles > 0),
      ],
    );
  }
}

class _HealthItem extends StatelessWidget {
  const _HealthItem({required this.label, required this.value, this.isWarning = false});
  final String label;
  final String value;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: isWarning ? Colors.orangeAccent : Colors.greenAccent)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, required this.onPressed});
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.03),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: Colors.white10),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: Colors.blueAccent),
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
    );
  }
}

class _ImportHistoryTile extends StatelessWidget {
  const _ImportHistoryTile({required this.imp});
  final ImportHistoryData imp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: KnightTokens.spacingM, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
          child: Icon(
            imp.docType == 'location_history' ? Icons.location_on_rounded : Icons.description_rounded,
            color: Colors.blueAccent,
            size: 18,
          ),
        ),
        title: Text(imp.fileName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text('${imp.recordCount} records • ${imp.docType}', style: const TextStyle(fontSize: 11, color: Colors.white38)),
        trailing: Icon(
          imp.status == 'success' ? Icons.check_circle_rounded : Icons.error_rounded,
          color: imp.status == 'success' ? Colors.greenAccent : Colors.redAccent,
          size: 20,
        ),
      ),
    );
  }
}
