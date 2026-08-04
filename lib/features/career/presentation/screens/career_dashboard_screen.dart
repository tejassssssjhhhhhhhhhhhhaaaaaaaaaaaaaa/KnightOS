import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/design_system/design_constants.dart';
import '../controllers/career_dashboard_controller.dart';
import '../widgets/career_health_card.dart';
import '../widgets/skill_dna_preview.dart';
import '../widgets/explainable_insight_card.dart';
import '../widgets/career_quick_actions.dart';
import '../../../../core/domain/entities/mission.dart';
import '../../../../core/domain/entities/timeline_event.dart';

import '../../../../core/domain/entities/insight.dart';

class CareerDashboardScreen extends ConsumerWidget {
  const CareerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(careerDashboardControllerProvider);

    return KnightPageScaffold(
      title: 'Career Dashboard',
      showBackButton: true,
      body: stateAsync.when(
        data: (state) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(state),
              const SizedBox(height: 32),
              
              CareerHealthCard(
                momentum: state.momentum,
                skillGrowth: state.skillGrowth,
                learningProgress: state.learningProgress,
              ),
              const SizedBox(height: 40),
              
              _buildSectionTitle('TODAY\'S FOCUS'),
              const SizedBox(height: 16),
              if (state.activeMissions.isEmpty)
                _buildEmptyState('No active missions. Align your North Star to begin.')
              else
                _buildMissionFocus(state.activeMissions.first),
              const SizedBox(height: 40),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: SkillDnaPreview(topSkills: state.topSkills)),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: _buildTimelinePreview(state.timelinePreview)),
                ],
              ),
              const SizedBox(height: 40),

              if (state.aiInsight != null) ...[
                ExplainableInsightCard(
                  title: 'Career Insight',
                  recommendation: state.aiInsight!.data is Insight 
                      ? (state.aiInsight!.data as Insight).title 
                      : 'Accelerate Cloud Architecture learning.',
                  evidenceSummary: 'Based on ${state.timelinePreview.length} recent professional events.',
                  reasoning: state.aiInsight!.data is Insight 
                      ? (state.aiInsight!.data as Insight).recommendation 
                      : 'Your emerging strength in Flutter paired with system design is high-demand.',
                  confidence: 0.92,
                  suggestedAction: 'View Strategy',
                ),
                const SizedBox(height: 40),
              ] else ...[
                const ExplainableInsightCard(
                  title: 'System Analysis',
                  recommendation: 'Update your Career DNA',
                  evidenceSummary: 'Incomplete professional profile.',
                  reasoning: 'Knight needs more evidence to provide strategic guidance.',
                  confidence: 0.8,
                  suggestedAction: 'Sync GitHub',
                ),
                const SizedBox(height: 40),
              ],

              const CareerQuickActions(),
              const SizedBox(height: 100), // Bottom padding for FAB/Nav
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildHeader(CareerDashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: DesignColors.career,
              backgroundImage: state.identity['photoUrl'] != null 
                  ? NetworkImage(state.identity['photoUrl']) 
                  : null,
              child: state.identity['photoUrl'] == null 
                  ? const Icon(Icons.person, color: Colors.white) 
                  : null,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, ${state.identity['displayName'] ?? 'Knight'}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Systems Architect (Stage 4)',
                  style: TextStyle(color: DesignColors.secondary, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignColors.white05,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: DesignColors.warning, size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'NORTH STAR: Become a Principal Engineer by 2028',
                  style: TextStyle(
                    color: DesignColors.primary.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: DesignColors.secondary,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontSize: 10,
      ),
    );
  }

  Widget _buildMissionFocus(Mission mission) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: DesignRadius.card,
        border: Border.all(color: DesignColors.career.withValues(alpha: 0.3)),
        boxShadow: DesignShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: DesignColors.career,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'CRITICAL',
                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                ),
              ),
              const Spacer(),
              const Text('DUE IN 2 DAYS', style: TextStyle(color: DesignColors.error, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            mission.title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            mission.description ?? 'Next step: Review your progress and verify evidence.',
            style: const TextStyle(color: DesignColors.secondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignColors.career,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('ACTIVATE MISSION'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelinePreview(List<TimelineEvent> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TIMELINE',
          style: TextStyle(
            color: DesignColors.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        if (events.isEmpty)
          _buildEmptyState('No events recorded.')
        else
          ...events.map((e) => _TimelineItem(event: e)),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Text(message, style: const TextStyle(color: DesignColors.secondary, fontSize: 12, fontStyle: FontStyle.italic));
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event});
  final TimelineEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: DesignColors.career, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(color: DesignColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Yesterday', // Placeholder for relative time
                  style: const TextStyle(color: DesignColors.secondary, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
