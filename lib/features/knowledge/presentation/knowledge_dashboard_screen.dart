import 'package:flutter/material.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';

class KnowledgeDashboardScreen extends StatelessWidget {
  const KnowledgeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Knowledge',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchAnchor(),
            const SizedBox(height: 32),
            _buildKnowledgeGraphStub(),
            const SizedBox(height: 32),
            _buildRecentInsights(),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAnchor() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: DesignRadius.card,
        border: Border.all(color: DesignColors.white05),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.white38),
          SizedBox(width: 16),
          Text('Search your knowledge base...', style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildKnowledgeGraphStub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('KNOWLEDGE GRAPH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DesignColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DesignColors.white05),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hub_outlined, size: 48, color: Colors.white10),
                SizedBox(height: 12),
                Text('Indexing semantic relations...', style: TextStyle(color: Colors.white24, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RECENT MEMORIES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        ...List.generate(3, (i) => Card(
          color: DesignColors.surfaceHigh.withValues(alpha: 0.3),
          margin: const EdgeInsets.only(bottom: 12),
          child: const ListTile(
            leading: Icon(Icons.psychology_outlined, color: DesignColors.accentPurple),
            title: Text('New Skill: Flutter Optimization', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text('Added via autonomous learning cycle', style: TextStyle(fontSize: 11, color: Colors.white38)),
          ),
        )),
      ],
    );
  }
}
