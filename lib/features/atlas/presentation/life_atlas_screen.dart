import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/knight_context_provider.dart';
import '../../../core/internal/storage/drift/knight_database.dart';

class LifeAtlasScreen extends ConsumerWidget {
  const LifeAtlasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      title: 'Life Atlas',
      showBackButton: true,
      body: contextAsync.when(
        data: (knightContext) => _LifeAtlasContent(events: knightContext.recentTimelineEvents),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _LifeAtlasContent extends StatelessWidget {
  const _LifeAtlasContent({required this.events});
  final List<TimelineEventData> events;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMapStub(),
          const SizedBox(height: 32),
          const Text('CHRONOLOGICAL JOURNEY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38, letterSpacing: 1.0)),
          const SizedBox(height: 16),
          if (events.isEmpty)
             _buildEmptyState()
          else
            ...events.map((e) => _TimelineItem(
              title: e.title,
              time: '${e.startTime.hour}:${e.startTime.minute.toString().padLeft(2, '0')}',
              type: e.type,
              isLast: e == events.last,
            )),
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildMapStub() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: DesignRadius.card,
        border: Border.all(color: DesignColors.white05),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 48, color: Colors.white10),
            SizedBox(height: 12),
            Text('Relational Map view offline.', style: TextStyle(color: Colors.white24, fontSize: 12)),
            Text('Connect GPS for real-time tracking.', style: TextStyle(color: Colors.white10, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
     return Center(
       child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 40),
         child: Column(
           children: [
             const Icon(Icons.history_toggle_off_rounded, size: 48, color: Colors.white10),
             const SizedBox(height: 16),
             const Text('No location history found.', style: TextStyle(color: Colors.white24)),
             TextButton(onPressed: () {}, child: const Text('Import Google Timeline')),
           ],
         ),
       ),
     );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.title, required this.time, required this.type, this.isLast = false});
  final String title;
  final String time;
  final String type;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                type == 'visit' ? Icons.location_on_rounded : Icons.directions_run_rounded,
                color: DesignColors.accentPurple,
                size: 20,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(time, style: const TextStyle(fontSize: 12, color: Colors.white38)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
