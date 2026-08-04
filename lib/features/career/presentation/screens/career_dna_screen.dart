import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/design_system/design_constants.dart';
import '../controllers/career_dna_controller.dart';
import '../widgets/explainable_insight_card.dart';
import '../../domain/career_models.dart';

class CareerDnaScreen extends ConsumerWidget {
  const CareerDnaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(careerDnaControllerProvider);

    return KnightPageScaffold(
      title: 'Career DNA',
      showBackButton: true,
      body: stateAsync.when(
        data: (state) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ExplainableInsightCard(
                title: 'Skill Intelligence',
                recommendation: 'Accelerate Cloud Architecture learning.',
                evidenceSummary: 'Based on 5 related projects and 85% market relevance score.',
                reasoning: 'Your emerging strength in Flutter paired with AWS expertise is a high-demand hybrid profile.',
                confidence: 0.94,
                suggestedAction: 'Start the "Advanced Cloud Patterns" mission.',
              ),
              const SizedBox(height: 40),
              
              _buildNebulaStats(state.skills),
              const SizedBox(height: 40),
              
              _buildTrendSection('Improving Skills', state.skills.where((s) => s.growthTrend == 'improving').toList(), DesignColors.success),
              const SizedBox(height: 32),
              
              _buildTrendSection('Declining Skills', state.skills.where((s) => s.growthTrend == 'declining').toList(), DesignColors.error),
              const SizedBox(height: 40),

              _buildSkillList(state.skills),
              const SizedBox(height: 100),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildNebulaStats(List<SkillIntelligence> skills) {
    return Row(
      children: [
        _StatBox(label: 'VERIFIED SKILLS', value: '${skills.length}'),
        const SizedBox(width: 16),
        _StatBox(label: 'AVG PROFICIENCY', value: '${(skills.map((s) => s.proficiency).reduce((a, b) => a + b) / skills.length * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildTrendSection(String title, List<SkillIntelligence> skills, Color color) {
    if (skills.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(color: DesignColors.secondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills.map((s) => _TrendChip(skill: s, color: color)).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillList(List<SkillIntelligence> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ALL COMPETENCIES', style: TextStyle(color: DesignColors.secondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
        const SizedBox(height: 16),
        ...skills.map((s) => _SkillIntelligenceTile(skill: s)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: DesignColors.white05,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignColors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: DesignColors.secondary, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.skill, required this.color});
  final SkillIntelligence skill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(skill.growthTrend == 'improving' ? Icons.trending_up : Icons.trending_down, size: 14, color: color),
          const SizedBox(width: 8),
          Text(skill.name, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SkillIntelligenceTile extends StatelessWidget {
  const _SkillIntelligenceTile({required this.skill});
  final SkillIntelligence skill;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(skill.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              _VerificationBadge(level: skill.verificationLevel),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: skill.proficiency,
                  backgroundColor: DesignColors.white10,
                  valueColor: AlwaysStoppedAnimation(_getProficiencyColor()),
                  minHeight: 4,
                ),
              ),
              const SizedBox(width: 16),
              Text('${(skill.proficiency * 100).toInt()}%', style: const TextStyle(color: DesignColors.secondary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniMeta(label: 'Evidence', value: '${skill.evidenceCount} nodes'),
              const SizedBox(width: 16),
              _MiniMeta(label: 'Confidence', value: '${(skill.confidence * 100).toInt()}%'),
              const Spacer(),
              const Icon(Icons.info_outline_rounded, size: 14, color: DesignColors.white20),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProficiencyColor() {
    if (skill.proficiency > 0.8) return DesignColors.success;
    if (skill.proficiency > 0.4) return DesignColors.accentBlue;
    return DesignColors.warning;
  }
}

class _VerificationBadge extends StatelessWidget {
  const _VerificationBadge({required this.level});
  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DesignColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, size: 10, color: DesignColors.success),
          const SizedBox(width: 4),
          Text(level.toUpperCase(), style: const TextStyle(color: DesignColors.success, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _MiniMeta extends StatelessWidget {
  const _MiniMeta({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(color: DesignColors.secondary, fontSize: 10)),
        Text(value, style: const TextStyle(color: DesignColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
