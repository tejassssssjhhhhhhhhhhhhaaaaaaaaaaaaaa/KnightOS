import 'package:flutter/material.dart';
import '../../../../core/intelligence/engines/knowledge_retrieval_engine.dart';

class ReasoningExplorer extends StatelessWidget {
  const ReasoningExplorer({super.key, required this.result});

  final SearchResult result;

  static void show(BuildContext context, SearchResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReasoningExplorer(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final memory = result.memory;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reasoning Explorer',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    'Conclusion',
                    memory.summary ?? 'Untitled Memory',
                    Icons.psychology_rounded,
                  ),
                  const SizedBox(height: 24),
                  _buildScoreSection(context),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Evidence',
                    'Source: ${memory.metadata.provenance}\nTrust Weight: ${memory.confidence}',
                    Icons.source_rounded,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Semantic Context',
                    'Provider: ${memory.semanticMetadata['provider']}\nVersion: ${memory.semanticMetadata['version']}',
                    Icons.data_object_rounded,
                  ),
                  const SizedBox(height: 24),
                  _buildCausalSection(context, memory),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCausalSection(BuildContext context, dynamic memory) {
    // Phase 13: Causal Path visualization
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_tree_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Causal Path',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildCausalStep('Detected sleep debt (1.5h)', 'HappensBefore'),
              _buildCausalStep('Low productivity reported', 'Causes'),
              _buildCausalStep(memory.summary ?? 'Target Outcome', 'Final'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCausalStep(String text, String relation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.subdirectory_arrow_right_rounded, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
          if (relation != 'Final')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                relation,
                style: const TextStyle(fontSize: 10, color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildScoreSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ranking Metrics',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildMetricBar(
          context,
          'Semantic Similarity',
          result.semanticSimilarity,
        ),
        const SizedBox(height: 8),
        _buildMetricBar(context, 'Total Score', result.score),
      ],
    );
  }

  Widget _buildMetricBar(BuildContext context, String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(
              '${(value * 100).toInt()}%',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Theme.of(context).colorScheme.outlineVariant,
        ),
      ],
    );
  }
}
