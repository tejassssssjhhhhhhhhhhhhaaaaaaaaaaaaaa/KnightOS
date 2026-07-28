enum OnboardingStep { personal, work, health, finance, goals, aiPreferences }

extension OnboardingStepX on OnboardingStep {
  String get title {
    switch (this) {
      case OnboardingStep.personal:
        return 'Personal';
      case OnboardingStep.work:
        return 'Work';
      case OnboardingStep.health:
        return 'Health';
      case OnboardingStep.finance:
        return 'Finance';
      case OnboardingStep.goals:
        return 'Productivity';
      case OnboardingStep.aiPreferences:
        return 'AI Preferences';
    }
  }

  String get description {
    switch (this) {
      case OnboardingStep.personal:
        return 'Share the essentials so KnightOS can personalize your experience.';
      case OnboardingStep.work:
        return 'Tell us about your work rhythm and schedule.';
      case OnboardingStep.health:
        return 'Set wellness habits that fit your day.';
      case OnboardingStep.finance:
        return 'Define your budget, priorities, and savings goals.';
      case OnboardingStep.goals:
        return 'Capture your long-term ambitions and daily priorities.';
      case OnboardingStep.aiPreferences:
        return 'Fine-tune how KnightOS communicates with you.';
    }
  }
}
