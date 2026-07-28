import 'package:flutter/material.dart';

import '../../features/onboarding/domain/onboarding_profile.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({required this.profile, super.key});

  final OnboardingProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insight = _buildInsight(profile);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.55),
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.45),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Insight',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  String _buildInsight(OnboardingProfile profile) {
    final shift = profile.shiftType.trim().toLowerCase();
    final fitness = profile.fitnessLevel.trim().toLowerCase();
    final budget = profile.monthlyBudget.trim();

    if (shift.contains('night') || shift.contains('overnight')) {
      return 'Because you work ${profile.shiftType.isEmpty ? 'night shifts' : profile.shiftType.toLowerCase()}, maintaining a consistent daytime sleep schedule should be your highest priority.';
    }

    if (fitness.contains('beginner') || fitness.contains('new')) {
      return 'Because your fitness level is ${profile.fitnessLevel.isEmpty ? 'beginner' : profile.fitnessLevel.toLowerCase()}, focus on consistency instead of intensity this week.';
    }

    if (budget.isNotEmpty) {
      return 'With a monthly budget of $budget, tracking today\'s spending will help you stay aligned with your goals.';
    }

    return 'Keep your priorities visible and protect one focused block of work each day.';
  }
}
