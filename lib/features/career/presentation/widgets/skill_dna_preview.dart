import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class SkillDnaPreview extends StatelessWidget {
  const SkillDnaPreview({required this.topSkills, super.key});

  final List<String> topSkills;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skill DNA',
          style: TextStyle(
            color: DesignColors.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topSkills.map((skill) => _SkillTag(label: skill)).toList(),
        ),
        const SizedBox(height: 24),
        const _SkillTrendRow(
          label: 'Improving',
          skills: ['Flutter', 'System Design'],
          color: DesignColors.success,
        ),
        const SizedBox(height: 12),
        const _SkillTrendRow(
          label: 'Attention Needed',
          skills: ['AWS'],
          color: DesignColors.warning,
        ),
      ],
    );
  }
}

class _SkillTag extends StatelessWidget {
  const _SkillTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: DesignColors.white10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: DesignColors.primary, fontSize: 12),
      ),
    );
  }
}

class _SkillTrendRow extends StatelessWidget {
  const _SkillTrendRow({required this.label, required this.skills, required this.color});
  final String label;
  final List<String> skills;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: DesignColors.secondary, fontSize: 12),
        ),
        Text(
          skills.join(', '),
          style: const TextStyle(color: DesignColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
