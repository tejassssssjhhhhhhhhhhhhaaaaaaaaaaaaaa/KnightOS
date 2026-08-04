import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/design_system/design_constants.dart';
import '../controllers/north_star_controller.dart';
import '../widgets/strategic_insight_card.dart';
import '../../../../core/domain/entities/strategic_models.dart';
import '../../../../core/intelligence/engines/strategic/gap_analysis_engine.dart';

class NorthStarScreen extends ConsumerWidget {
  const NorthStarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(northStarControllerProvider);

    return KnightPageScaffold(
      title: 'Strategic North Star',
      showBackButton: true,
      body: stateAsync.when(
        data: (state) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.vision != null) _buildVisionSection(state.vision!),
              const SizedBox(height: 40),
              
              const StrategicInsightCard(
                recommendation: 'Target Principal Engineer path.',
                why: 'Your current skill trajectory and project complexity align with Tier 1 engineering standards.',
                risks: 'Potential stagnation in salary growth if leadership evidence is not captured by Q4.',
                evidence: '15 verified projects, 2 certifications, and consistent Q3 performance peaks.',
                assumptions: 'Assumes continued full-time commitment and access to architectural projects.',
                confidence: 0.95,
                nextAction: 'Review Growth Strategy',
              ),
              const SizedBox(height: 40),

              _buildNorthStarsSection(state.northStars, state.gapReports),
              const SizedBox(height: 100),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildVisionSection(LifeVision vision) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        borderRadius: DesignRadius.card,
        border: Border.all(color: DesignColors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIFE VISION',
            style: TextStyle(color: DesignColors.warning, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          Text(
            vision.title,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(
            vision.purpose ?? 'Define your primary purpose to align Knight Intelligence.',
            style: const TextStyle(color: DesignColors.secondary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: vision.coreValues.map((v) => _ValueChip(label: v)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNorthStarsSection(List<NorthStar> northStars, Map<String, GapReport> gapReports) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'NORTH STARS',
              style: TextStyle(color: DesignColors.secondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('NEW GOAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (northStars.isEmpty)
          const Text('No North Stars defined. What is your primary destination?', 
            style: TextStyle(color: DesignColors.secondary, fontSize: 12, fontStyle: FontStyle.italic))
        else
          ...northStars.map((ns) => _NorthStarCard(northStar: ns, gapReport: gapReports[ns.id])),
      ],
    );
  }
}

class _ValueChip extends StatelessWidget {
  const _ValueChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DesignColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: DesignColors.warning.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(color: DesignColors.warning, fontSize: 9, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _NorthStarCard extends StatelessWidget {
  const _NorthStarCard({required this.northStar, this.gapReport});
  final NorthStar northStar;
  final GapReport? gapReport;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DomainIcon(domain: northStar.domain),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      northStar.title,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Target: ${northStar.targetState ?? 'Continuous Growth'}',
                      style: const TextStyle(color: DesignColors.secondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _ProgressCircle(progress: northStar.progress),
            ],
          ),
          const SizedBox(height: 24),
          if (gapReport != null) _buildGapSummary(gapReport!),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('GAP ANALYSIS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignColors.career,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('VIEW MISSIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGapSummary(GapReport report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GAP ANALYSIS', style: TextStyle(color: DesignColors.secondary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          if (report.missingSkills.isEmpty)
            const Text('You are aligned with this North Star.', style: TextStyle(color: DesignColors.success, fontSize: 12, fontWeight: FontWeight.bold))
          else
            Text(
              'Missing Skills: ${report.missingSkills.join(', ')}',
              style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: DesignColors.accentBlue, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  report.highestImpactAction,
                  style: const TextStyle(color: DesignColors.accentBlue, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DomainIcon extends StatelessWidget {
  const _DomainIcon({required this.domain});
  final String domain;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (domain.toLowerCase()) {
      case 'career': icon = Icons.business_center_rounded; color = DesignColors.career; break;
      case 'health': icon = Icons.favorite_rounded; color = DesignColors.health; break;
      case 'finance': icon = Icons.account_balance_wallet_rounded; color = DesignColors.finance; break;
      default: icon = Icons.star_rounded; color = DesignColors.warning;
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  const _ProgressCircle({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: DesignColors.white10,
            color: DesignColors.success,
            strokeWidth: 3,
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
