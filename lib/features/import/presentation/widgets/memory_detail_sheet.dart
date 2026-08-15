import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/intelligence/domain/memory_metadata.dart';
import '../../../../core/intelligence/domain/memory_domain.dart';
import '../../../../core/intelligence/providers/brain_provider.dart';
import '../../../../core/providers/database_provider.dart';

class MemoryDetailSheet extends ConsumerWidget {
  const MemoryDetailSheet({required this.memory, super.key});
  final MemoryTableData memory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domain = MemoryDomain.fromId(memory.domainId);
    final state = KnowledgeState.values.byName(memory.knowledgeState);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(domain),
          const SizedBox(height: 32),
          _buildSection('WHAT KNIGHT KNOWS', memory.summary ?? 'Detailed fact unit'),
          _buildSection('WHY?', memory.explanation ?? 'Direct observation from source.'),
          _buildMetaGrid(state),
          const SizedBox(height: 32),
          _buildRelationships(ref),
          const SizedBox(height: 32),
          _buildTechnicalDetails(),
          const SizedBox(height: 32),
          if (state == KnowledgeState.needsReview || state == KnowledgeState.inferred)
            _buildActions(context, ref),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTechnicalDetails() {
    return ExpansionTile(
      title: const Text('TECHNICAL DIAGNOSTICS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24)),
      tilePadding: EdgeInsets.zero,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
          child: Text(
            _maskSensitiveInfo(memory.content),
            style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  String _maskSensitiveInfo(String input) {
    final tokenRegex = RegExp(r'(?:access_token|refresh_token|password|secret|key|bearer)\s*[:=]\s*[^\s,"]+', caseSensitive: false);
    return input.replaceAllMapped(tokenRegex, (match) {
      final parts = match.group(0)!.split(RegExp(r'[:=]'));
      if (parts.length == 2) {
        return '${parts[0]}: [MASKED]';
      }
      return '[MASKED]';
    });
  }

  Widget _buildHeader(MemoryDomain domain) {
    return Row(
      children: [
        Icon(domain.icon, color: domain.color, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(domain.label.toUpperCase(), style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 10, color: Colors.white24)),
            Text(memory.type.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 9, color: Colors.blueAccent)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildMetaGrid(KnowledgeState state) {
    return Wrap(
      spacing: 32,
      runSpacing: 24,
      children: [
        _metaItem('SOURCE', memory.source.toUpperCase()),
        _metaItem('DATE', DateFormat('MMM dd, yyyy').format(memory.effectiveAt)),
        _metaItem('CONFIDENCE', '${(memory.confidence * 100).toInt()}%'),
        _metaItem('STATE', state.name.toUpperCase()),
        _metaItem('LAST UPDATED', DateFormat('MMM dd, HH:mm').format(memory.updatedAt)),
      ],
    );
  }

  Widget _buildRelationships(WidgetRef ref) {
    final relationsAsync = ref.watch(memoryRelationsProvider(memory.memoryId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RELATIONSHIPS', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 9, color: Colors.blueAccent)),
        const SizedBox(height: 12),
        relationsAsync.when(
          data: (relations) {
            if (relations.isEmpty) {
              return const Text('KNIGHT has not established a connection yet.', style: TextStyle(fontSize: 11, color: Colors.white24));
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: relations.map((r) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '${r.relation.type.toUpperCase()}: ${r.memory?.summary ?? r.relation.targetId}',
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              )).toList(),
            );
          },
          loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, _) => const Text('Error loading relationships', style: TextStyle(color: Colors.redAccent, fontSize: 10)),
        ),
      ],
    );
  }

  Widget _metaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white24)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showCorrectionDialog(context, ref),
                child: const Text('CORRECT'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => _updateState(ref, context, KnowledgeState.userConfirmed),
                style: FilledButton.styleFrom(backgroundColor: Colors.greenAccent),
                child: const Text('CONFIRM', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => _updateState(ref, context, KnowledgeState.userRejected),
            child: const Text('DISMISS', style: TextStyle(color: Colors.white24)),
          ),
        ),
      ],
    );
  }

  void _showCorrectionDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: memory.summary ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Correct Information'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Observation Correction',
            labelStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          FilledButton(
            onPressed: () async {
              final db = ref.read(knightDatabaseProvider);
              await db.memoryDao.saveWithVersioning(memory.toCompanion(false).copyWith(
                summary: Value(controller.text),
                knowledgeState: Value(KnowledgeState.userCorrected.name),
                reasoning: Value('User manual correction at ${DateTime.now()}'),
              ));
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close sheet
              }
            },
            child: const Text('SAVE CORRECTION'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateState(WidgetRef ref, BuildContext context, KnowledgeState newState) async {
    final db = ref.read(knightDatabaseProvider);
    await db.memoryDao.saveWithVersioning(memory.toCompanion(false).copyWith(
      knowledgeState: Value(newState.name),
      verified: Value(newState == KnowledgeState.userConfirmed),
      lastVerifiedAt: Value(DateTime.now()),
    ));
    if (context.mounted) Navigator.pop(context);
  }
}
