import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';

class KnowledgeVaultScreen extends ConsumerWidget {
  const KnowledgeVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsync = ref.watch(_knowledgeMemoriesProvider);

    return KnightPageScaffold(
      title: 'Knowledge Vault',
      showBackButton: true,
      body: memoriesAsync.when(
        data: (memories) => _VaultContent(memories: memories),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Vault Error: $e')),
      ),
    );
  }
}

final _knowledgeMemoriesProvider = FutureProvider<List<KnightMemory>>((ref) async {
  final engine = ref.read(memoryEngineProvider);
  return engine.getByCategory(BookCategory.skills);
});

class _VaultContent extends StatelessWidget {
  const _VaultContent({required this.memories});
  final List<KnightMemory> memories;

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: memories.length,
      itemBuilder: (context, index) {
        final m = memories[index];
        return _VaultItem(memory: m);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.white10),
          const SizedBox(height: 24),
          const Text('Knowledge Vault is empty.', style: TextStyle(color: Colors.white24, fontSize: 15)),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {}, 
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text('UPLOAD DOCUMENT'),
            style: OutlinedButton.styleFrom(
              foregroundColor: DesignColors.accentBlue,
              side: const BorderSide(color: DesignColors.accentBlue, width: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultItem extends StatelessWidget {
  const _VaultItem({required this.memory});
  final KnightMemory memory;

  @override
  Widget build(BuildContext context) {
    final type = memory.content['mimeType']?.toString() ?? 'document';
    final date = DateFormat('MMM dd, yyyy').format(memory.effectiveAt);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getIconColor(type).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_getIcon(type), color: _getIconColor(type), size: 18),
        ),
        title: Text(memory.summary ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          '$type • $date',
          style: const TextStyle(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
        onTap: () {
          // Future: Open detail view or AI analysis
        },
      ),
    );
  }

  IconData _getIcon(String mime) {
    if (mime.contains('pdf')) return Icons.picture_as_pdf_rounded;
    if (mime.contains('image')) return Icons.image_rounded;
    if (mime.contains('sheet')) return Icons.table_chart_rounded;
    return Icons.description_rounded;
  }

  Color _getIconColor(String mime) {
    if (mime.contains('pdf')) return Colors.redAccent;
    if (mime.contains('image')) return Colors.blueAccent;
    if (mime.contains('sheet')) return Colors.greenAccent;
    return Colors.white38;
  }
}
