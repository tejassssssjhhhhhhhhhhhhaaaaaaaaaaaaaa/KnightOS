import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_relation.dart';
import 'widgets/knowledge_graph_view.dart';

class KnowledgeGraphExplorerScreen extends ConsumerWidget {
  const KnowledgeGraphExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(memoryEngineProvider);

    return KnightPageScaffold(
      title: 'Graph Explorer',
      body: FutureBuilder<Map<String, dynamic>>(
        future: () async {
          final memories = await engine.search('');
          final relations = await engine.getAllRelations();
          return {'memories': memories, 'relations': relations};
        }(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final memories = snapshot.data!['memories'] as List<KnightMemory>;
          final relations = snapshot.data!['relations'] as List<MemoryRelation>;

          return memories.isEmpty
              ? _buildEmptyState()
              : KnowledgeGraphView(memories: memories, relations: relations);
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
}
