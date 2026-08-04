import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/design_system/design_constants.dart';
import '../controllers/career_timeline_controller.dart';
import '../widgets/explainable_insight_card.dart';
import '../../../../core/domain/entities/timeline_event.dart';

class CareerTimelineScreen extends ConsumerWidget {
  const CareerTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(careerTimelineControllerProvider);

    return KnightPageScaffold(
      title: 'Professional Journey',
      showBackButton: true,
      body: stateAsync.when(
        data: (state) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ExplainableInsightCard(
                      title: 'Timeline Intelligence',
                      recommendation: 'Your project completion rate is peak in Q3.',
                      evidenceSummary: 'Based on 12 verified projects over 3 years.',
                      reasoning: 'Data shows a 15% increase in velocity during July-September cycles.',
                      confidence: 0.88,
                      suggestedAction: 'Plan high-impact projects for next Q3.',
                    ),
                    const SizedBox(height: 32),
                    _buildSearchBar(ref, state),
                    const SizedBox(height: 24),
                    _buildTypeFilters(ref, state),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            if (state.filteredEvents.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text('No events found for the selected filters.', 
                    style: TextStyle(color: DesignColors.secondary)),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = state.filteredEvents[index];
                      final isFirst = index == 0;
                      final isLast = index == state.filteredEvents.length - 1;
                      return _TimelineEventTile(
                        event: event, 
                        isFirst: isFirst, 
                        isLast: isLast,
                      );
                    },
                    childCount: state.filteredEvents.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref, CareerTimelineState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.white10),
      ),
      child: TextField(
        onChanged: (v) => ref.read(careerTimelineControllerProvider.notifier).filter(v),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          icon: Icon(Icons.search_rounded, color: DesignColors.secondary, size: 20),
          hintText: 'Search journey...',
          hintStyle: TextStyle(color: DesignColors.secondary),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTypeFilters(WidgetRef ref, CareerTimelineState state) {
    final types = [
      TimelineEventType.employment,
      TimelineEventType.project,
      TimelineEventType.certification,
      TimelineEventType.education,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          final isSelected = state.selectedTypes.contains(type);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(type.name.toUpperCase()),
              selected: isSelected,
              onSelected: (_) => ref.read(careerTimelineControllerProvider.notifier).toggleType(type),
              backgroundColor: DesignColors.white05,
              selectedColor: DesignColors.career.withValues(alpha: 0.3),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : DesignColors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TimelineEventTile extends StatelessWidget {
  const _TimelineEventTile({
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineIndicator(),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: _buildEventCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator() {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getEventColor(),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _getEventColor().withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: DesignColors.white10,
            ),
          ),
      ],
    );
  }

  Widget _buildEventCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('MMM yyyy').format(event.startTime).toUpperCase(),
                style: const TextStyle(
                  color: DesignColors.secondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              _buildTypeBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (event.location != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 12, color: DesignColors.secondary),
                const SizedBox(width: 4),
                Text(
                  event.location!,
                  style: const TextStyle(color: DesignColors.secondary, fontSize: 12),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.verified_rounded, size: 14, color: DesignColors.success),
              const SizedBox(width: 6),
              const Text('VERIFIED EVIDENCE', style: TextStyle(color: DesignColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: DesignColors.white20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getEventColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _getEventColor().withValues(alpha: 0.2)),
      ),
      child: Text(
        event.type.name.toUpperCase(),
        style: TextStyle(
          color: _getEventColor(),
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Color _getEventColor() {
    switch (event.type) {
      case TimelineEventType.employment: return DesignColors.career;
      case TimelineEventType.promotion: return DesignColors.warning;
      case TimelineEventType.certification: return DesignColors.success;
      case TimelineEventType.education: return DesignColors.accentPurple;
      case TimelineEventType.project: return DesignColors.accentCyan;
      default: return DesignColors.secondary;
    }
  }
}
