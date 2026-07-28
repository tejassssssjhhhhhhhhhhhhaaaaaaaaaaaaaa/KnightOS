import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/knight_memory.dart';

class KnowledgeGraphExplorerScreen extends ConsumerWidget {
  const KnowledgeGraphExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrieval = ref.watch(memoryRetrievalEngineProvider);

    return KnightPageScaffold(
      title: 'Graph Explorer',
      body: FutureBuilder<List<KnightMemory>>(
        future: retrieval.search(''), // Fetch all for explorer
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final memories = snapshot.data!;
          return memories.isEmpty
              ? _buildEmptyState()
              : _buildGraphView(context, memories);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No memories in graph yet. Import data to see relationships.',
      ),
    );
  }

  Widget _buildGraphView(BuildContext context, List<KnightMemory> memories) {
    // For Phase 13, we implement a List-based representation of the graph
    // (Actual node-edge layout would require a library like 'graphview')
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: memories.length,
      itemBuilder: (context, index) {
        final memory = memories[index];
        return _buildNodeCard(context, memory);
      },
    );
  }

  Widget _buildNodeCard(BuildContext context, KnightMemory memory) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(memory.summary ?? memory.memoryId),
        subtitle: Text(memory.category.label),
        leading: Icon(_getCategoryIcon(memory.category)),
        children: [_buildRelationshipList(context, memory)],
      ),
    );
  }

  Widget _buildRelationshipList(BuildContext context, KnightMemory memory) {
    // In a real app, we'd query memoryEngine.getRelated(memory.memoryId)
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Relationships', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (memory.relationships.isEmpty)
            const Text('No direct relationships detected.')
          else
            ...memory.relationships.map(
              (rel) => ListTile(
                dense: true,
                title: Text('${rel.type.name} -> ${rel.targetId}'),
                trailing: Text('Strength: ${(rel.strength * 100).toInt()}%'),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(dynamic category) {
    // Basic mapping
    return Icons.psychology_rounded;
  }
}
