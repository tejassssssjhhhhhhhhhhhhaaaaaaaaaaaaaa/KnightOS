import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/intelligence/knight_context_provider.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/router/app_routes.dart';
import 'widgets/atlas_event_detail_sheet.dart';

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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(DesignSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMapStub(context),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CHRONOLOGICAL JOURNEY', style: KnightTokens.label),
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded, size: 16, color: DesignColors.accentPurple),
                onPressed: () => context.push(AppRoutes.knight),
                tooltip: 'Analyze Journey',
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (events.isEmpty)
             _buildEmptyState()
          else
            ...events.map((e) => _TimelineItem(
              event: e,
              isLast: e == events.last,
              onTap: () => _showEventDetail(context, e),
            )),
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  void _showEventDetail(BuildContext context, TimelineEventData event) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AtlasEventDetailSheet(event: event),
    );
  }

  Widget _buildMapStub(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_edu_rounded, size: 40, color: Colors.white10),
                SizedBox(height: 12),
                Text('SEMANTIC GRAPH VIEW', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: TextButton.icon(
              onPressed: () => context.push(AppRoutes.dataHub),
              icon: const Icon(Icons.hub_rounded, size: 12),
              label: const Text('SYNC DATA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
     return Center(
       child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 60),
         child: Column(
           children: [
             const Icon(Icons.history_toggle_off_rounded, size: 48, color: DesignColors.white10),
             const SizedBox(height: 16),
             const Text('Your journey is being mapped.', style: TextStyle(color: Colors.white24, fontSize: 13)),
             const SizedBox(height: 24),
             OutlinedButton(
              onPressed: () {}, 
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white10)),
              child: const Text('MANUAL SYNC', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ),
           ],
         ),
       ),
     );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.onTap, this.isLast = false});
  final TimelineEventData event;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final startTimeStr = DateFormat('HH:mm').format(event.startTime);
    final duration = event.endTime.difference(event.startTime);
    final durationStr = duration.inHours > 0 
        ? '${duration.inHours}h ${duration.inMinutes.remainder(60)}m'
        : '${duration.inMinutes}m';
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: _getEventColor(event.type),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getEventColor(event.type).withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            event.title, 
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(startTimeStr, style: const TextStyle(fontSize: 11, color: Colors.white10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (event.location != null && event.location!.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 10, color: Colors.white24),
                          const SizedBox(width: 4),
                          Text(event.location!, style: const TextStyle(fontSize: 11, color: Colors.white24)),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        _SourceTag(label: event.type.toUpperCase()),
                        const SizedBox(width: 8),
                        if (event.type == 'visit' || event.type == 'activity')
                          _SourceTag(label: durationStr, color: Colors.white24),
                        const SizedBox(width: 8),
                        if (event.confidenceScore != null && event.confidenceScore! < 1.0)
                          _SourceTag(label: 'PROBABLE', color: Colors.amberAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'visit': return DesignColors.accentPurple;
      case 'activity': return Colors.greenAccent;
      case 'milestone': return Colors.amberAccent;
      case 'meeting': return DesignColors.accentBlue;
      default: return Colors.blueAccent;
    }
  }
}

class _SourceTag extends StatelessWidget {
  const _SourceTag({required this.label, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Colors.white10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: activeColor.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: activeColor == Colors.white10 ? Colors.white24 : activeColor),
      ),
    );
  }
}
