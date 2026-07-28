import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/knight_background.dart';
import '../../../core/design_system/widgets/knight_layout.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/intelligence_models.dart';
import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class IntelligenceDashboardScreen extends ConsumerWidget {
  const IntelligenceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orchestrator = ref.watch(intelligenceOrchestratorProvider);

    return KnightPageScaffold(
      body: KnightBackground(
        child: CustomScrollView(
          slivers: [
            // 1. HERO
            SliverToBoxAdapter(
              child: EntranceFader(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    DesignSpacing.m,
                    DesignSpacing.xl,
                    DesignSpacing.m,
                    DesignSpacing.l,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INTELLIGENCE PLATFORM',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: DesignColors.focus,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.m),
                      Text(
                        'Cognitive Horizon',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(fontSize: 34),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Unified reasoning across all life domains.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. DAILY BRIEFING
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 100),
                child: FutureBuilder<Map<String, List<String>>>(
                  future: orchestrator.getDailyBriefing(),
                  builder: (context, snapshot) {
                    final items =
                        snapshot.data?.values.expand((i) => i).toList() ?? [];
                    if (items.isEmpty) return const SizedBox.shrink();
                    return _BriefingCard(items: items);
                  },
                ),
              ),
            ),

            // 3. INSIGHTS & RECOMMENDATIONS
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 200),
                child: const KnightSectionHeader(title: 'Proactive Intelligence'),
              ),
            ),

            SliverToBoxAdapter(
              child: FutureBuilder<List<IntelligenceResult>>(
                future: orchestrator.getAllInsights(),
                builder: (context, snapshot) {
                  final results = snapshot.data ?? [];
                  if (results.isEmpty) return const _EmptyIntelligence();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: results.length,
                    itemBuilder: (context, i) =>
                        _IntelligenceCard(result: results[i]),
                  );
                },
              ),
            ),

            // 4. INTELLIGENCE TIMELINE
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 300),
                child: const KnightSectionHeader(title: 'Cognitive Evolution'),
              ),
            ),

            SliverToBoxAdapter(
              child: FutureBuilder<List<KnightMemory>>(
                future: ref
                    .read(memoryEngineProvider)
                    .search('intelligence_milestone'),
                builder: (context, snapshot) {
                  final milestones = snapshot.data ?? [];
                  if (milestones.isEmpty) return const SizedBox.shrink();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: milestones.length,
                    itemBuilder: (context, i) =>
                        _MilestoneTile(memory: milestones[i]),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.memory});
  final KnightMemory memory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignSpacing.m,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: DesignColors.focus.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            memory.content['title'] ?? 'Milestone',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            memory.content['summary'] ?? '',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _BriefingCard extends StatelessWidget {
  const _BriefingCard({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(DesignSpacing.m),
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: DesignColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.wb_sunny_outlined,
                color: Colors.orangeAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'MORNING BRIEFING',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.white38)),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntelligenceCard extends ConsumerStatefulWidget {
  const _IntelligenceCard({required this.result});
  final IntelligenceResult result;

  @override
  ConsumerState<_IntelligenceCard> createState() => _IntelligenceCardState();
}

class _IntelligenceCardState extends ConsumerState<_IntelligenceCard> {
  bool _showReasoning = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignSpacing.m,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.m),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${(widget.result.trace.confidence * 100).toInt()}% Confidence',
                style: TextStyle(
                  color: _getConfidenceColor(widget.result.trace.confidence),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                widget.result.generatedAt.toIso8601String().split('T').first,
                style: const TextStyle(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.result.data.toString(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _FeedbackButton(
                icon: Icons.check_circle_outline,
                label: 'Helpful',
                onTap: () => ref
                    .read(intelligenceOrchestratorProvider)
                    .submitFeedback(
                      widget.result.id,
                      IntelligenceFeedback.helpful,
                    ),
              ),
              const SizedBox(width: 12),
              _FeedbackButton(
                icon: Icons.cancel_outlined,
                label: 'Incorrect',
                onTap: () => ref
                    .read(intelligenceOrchestratorProvider)
                    .submitFeedback(
                      widget.result.id,
                      IntelligenceFeedback.incorrect,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    setState(() => _showReasoning = !_showReasoning),
                child: Text(
                  _showReasoning ? 'Hide Reasoning' : 'Show Reasoning',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          if (_showReasoning) ...[
            const Divider(height: 24, color: Colors.white10),
            const Text(
              'Reasoning Chain:',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.result.trace.thoughtChain.map(
              (thought) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '→ $thought',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.8) return Colors.greenAccent;
    if (confidence > 0.5) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white38),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyIntelligence extends StatelessWidget {
  const _EmptyIntelligence();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DesignSpacing.xl),
      child: Center(
        child: Text(
          'Synthesizing life patterns...',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.2),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
