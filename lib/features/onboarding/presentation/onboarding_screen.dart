import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/router/app_routes.dart';
import '../../voice/voice_controller.dart';
import '../domain/onboarding_profile.dart';
import '../domain/onboarding_step.dart';
import '../onboarding_controller.dart';
import 'widgets/onboarding_choice_chips.dart';
import 'widgets/onboarding_input_card.dart';
import 'widgets/onboarding_text_field.dart';

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  final VoiceController _voiceController = VoiceController();
  final List<OnboardingStep> _steps = OnboardingStep.values;
  int _currentIndex = 0;

  UserProfile _profile = UserProfile(completedSteps: const []);

  @override
  void initState() {
    super.initState();
    // Profile is loaded via the provider in the build method.
  }

  void _updateProfileState(UserProfile? saved) {
    if (saved != null && _profile.completedSteps.isEmpty) {
      _profile = saved;
      final lastStep = saved.completedSteps.isEmpty
          ? 0
          : _steps.indexWhere((step) => step.name == saved.completedSteps.last);
      _currentIndex = lastStep >= 0 ? lastStep : 0;
    }
  }

  UserProfile _copyProfile({
    String? name,
    String? role,
    String? focusArea,
    String? workStyle,
    String? healthGoal,
    String? financeGoal,
    String? goalText,
    String? aiTone,
    String? aiDepth,
    List<String>? completedSteps,
    String? fullName,
    String? preferredName,
    String? dateOfBirth,
    String? gender,
    String? height,
    String? weight,
    String? country,
    String? timeZone,
    String? occupation,
    String? company,
    String? workType,
    String? shiftType,
    String? workHours,
    String? sleepGoal,
    String? waterGoal,
    String? exerciseFrequency,
    String? fitnessLevel,
    List<String>? healthGoals,
    String? currency,
    String? monthlyIncome,
    String? monthlyBudget,
    String? savingsGoal,
    List<String>? financialPriorities,
    String? lifeGoals,
    String? learningGoals,
    String? focusAreas,
    String? reminderPreference,
    String? aiPersonality,
    String? notificationPreference,
    String? themePreference,
    String? privacyPreference,
  }) {
    return _profile.copyWith(
      completedSteps: completedSteps,
      name: name,
      role: role,
      focusArea: focusArea,
      workStyle: workStyle,
      healthGoal: healthGoal,
      financeGoal: financeGoal,
      goalText: goalText,
      aiTone: aiTone,
      aiDepth: aiDepth,
      fullName: fullName,
      preferredName: preferredName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      height: height,
      weight: weight,
      country: country,
      timeZone: timeZone,
      occupation: occupation,
      company: company,
      workType: workType,
      shiftType: shiftType,
      workHours: workHours,
      sleepGoal: sleepGoal,
      waterGoal: waterGoal,
      exerciseFrequency: exerciseFrequency,
      fitnessLevel: fitnessLevel,
      healthGoals: healthGoals,
      currency: currency,
      monthlyIncome: monthlyIncome,
      monthlyBudget: monthlyBudget,
      savingsGoal: savingsGoal,
      financialPriorities: financialPriorities,
      lifeGoals: lifeGoals,
      learningGoals: learningGoals,
      focusAreas: focusAreas,
      reminderPreference: reminderPreference,
      aiPersonality: aiPersonality,
      notificationPreference: notificationPreference,
      themePreference: themePreference,
      privacyPreference: privacyPreference,
    );
  }

  void _updateProfile(String field, String value) {
    setState(() {
      switch (field) {
        case 'name':
          _profile = _copyProfile(name: value);
          break;
        case 'role':
          _profile = _copyProfile(role: value);
          break;
        case 'focusArea':
          _profile = _copyProfile(focusArea: value);
          break;
        case 'workStyle':
          _profile = _copyProfile(workStyle: value);
          break;
        case 'healthGoal':
          _profile = _copyProfile(healthGoal: value);
          break;
        case 'financeGoal':
          _profile = _copyProfile(financeGoal: value);
          break;
        case 'goalText':
          _profile = _copyProfile(goalText: value);
          break;
        case 'aiTone':
          _profile = _copyProfile(aiTone: value);
          break;
        case 'aiDepth':
          _profile = _copyProfile(aiDepth: value);
          break;
        case 'fullName':
          _profile = _copyProfile(fullName: value);
          break;
        case 'preferredName':
          _profile = _copyProfile(preferredName: value);
          break;
        case 'dateOfBirth':
          _profile = _copyProfile(dateOfBirth: value);
          break;
        case 'gender':
          _profile = _copyProfile(gender: value);
          break;
        case 'height':
          _profile = _copyProfile(height: value);
          break;
        case 'weight':
          _profile = _copyProfile(weight: value);
          break;
        case 'country':
          _profile = _copyProfile(country: value);
          break;
        case 'timeZone':
          _profile = _copyProfile(timeZone: value);
          break;
        case 'occupation':
          _profile = _copyProfile(occupation: value);
          break;
        case 'company':
          _profile = _copyProfile(company: value);
          break;
        case 'workType':
          _profile = _copyProfile(workType: value);
          break;
        case 'shiftType':
          _profile = _copyProfile(shiftType: value);
          break;
        case 'workHours':
          _profile = _copyProfile(workHours: value);
          break;
        case 'sleepGoal':
          _profile = _copyProfile(sleepGoal: value);
          break;
        case 'waterGoal':
          _profile = _copyProfile(waterGoal: value);
          break;
        case 'exerciseFrequency':
          _profile = _copyProfile(exerciseFrequency: value);
          break;
        case 'fitnessLevel':
          _profile = _copyProfile(fitnessLevel: value);
          break;
        case 'currency':
          _profile = _copyProfile(currency: value);
          break;
        case 'monthlyIncome':
          _profile = _copyProfile(monthlyIncome: value);
          break;
        case 'monthlyBudget':
          _profile = _copyProfile(monthlyBudget: value);
          break;
        case 'savingsGoal':
          _profile = _copyProfile(savingsGoal: value);
          break;
        case 'lifeGoals':
          _profile = _copyProfile(lifeGoals: value);
          break;
        case 'learningGoals':
          _profile = _copyProfile(learningGoals: value);
          break;
        case 'focusAreas':
          _profile = _copyProfile(focusAreas: value);
          break;
        case 'reminderPreference':
          _profile = _copyProfile(reminderPreference: value);
          break;
        case 'aiPersonality':
          _profile = _copyProfile(aiPersonality: value);
          break;
        case 'notificationPreference':
          _profile = _copyProfile(notificationPreference: value);
          break;
        case 'themePreference':
          _profile = _copyProfile(themePreference: value);
          break;
        case 'privacyPreference':
          _profile = _copyProfile(privacyPreference: value);
          break;
      }
    });
  }

  void _toggleSelection(List<String> currentValues, String value) {
    setState(() {
      final nextValues = List<String>.from(currentValues);
      if (nextValues.contains(value)) {
        nextValues.remove(value);
      } else {
        nextValues.add(value);
      }
      switch (value) {
        case 'Sleep':
        case 'Recovery':
        case 'Strength':
        case 'Mindfulness':
        case 'Mobility':
        case 'Stress Support':
          _profile = _profile.copyWith(healthGoals: nextValues);
          break;
        default:
          _profile = _profile.copyWith(financialPriorities: nextValues);
      }
    });
  }

  void _toggleHealthGoal(String value) {
    _toggleSelection(_profile.healthGoals, value);
  }

  void _toggleFinancialPriority(String value) {
    _toggleSelection(_profile.financialPriorities, value);
  }

  bool _canProceed() {
    switch (_steps[_currentIndex]) {
      case OnboardingStep.personal:
        return _profile.fullName.trim().isNotEmpty &&
            _profile.dateOfBirth.trim().isNotEmpty &&
            _profile.country.trim().isNotEmpty &&
            _profile.timeZone.trim().isNotEmpty;
      case OnboardingStep.work:
        return _profile.occupation.trim().isNotEmpty &&
            _profile.workType.trim().isNotEmpty &&
            _profile.shiftType.trim().isNotEmpty;
      case OnboardingStep.health:
        return _profile.sleepGoal.trim().isNotEmpty &&
            _profile.waterGoal.trim().isNotEmpty &&
            _profile.exerciseFrequency.trim().isNotEmpty &&
            _profile.fitnessLevel.trim().isNotEmpty &&
            _profile.healthGoals.isNotEmpty;
      case OnboardingStep.finance:
        return _profile.currency.trim().isNotEmpty &&
            _profile.monthlyBudget.trim().isNotEmpty &&
            _profile.savingsGoal.trim().isNotEmpty &&
            _profile.financialPriorities.isNotEmpty;
      case OnboardingStep.goals:
        return _profile.lifeGoals.trim().isNotEmpty &&
            _profile.learningGoals.trim().isNotEmpty &&
            _profile.focusAreas.trim().isNotEmpty;
      case OnboardingStep.aiPreferences:
        return _profile.aiPersonality.trim().isNotEmpty &&
            _profile.notificationPreference.trim().isNotEmpty &&
            _profile.themePreference.trim().isNotEmpty &&
            _profile.privacyPreference.trim().isNotEmpty;
    }
  }

  Future<void> _markCompleted() async {
    final stepName = _steps[_currentIndex].name;
    final completedSteps = List<String>.from(_profile.completedSteps);
    if (!completedSteps.contains(stepName)) {
      completedSteps.add(stepName);
    }
    final updatedProfile = _profile.copyWith(completedSteps: completedSteps);
    if (!mounted) return;
    setState(() => _profile = updatedProfile);
    await ref
        .read(onboardingProfileProvider.notifier)
        .saveProfile(updatedProfile);
  }

  void _goToPage(int index) {
    if (!mounted) return;
    setState(() => _currentIndex = index);
  }

  Future<void> _nextStep() async {
    if (!_canProceed()) {
      return;
    }
    if (_currentIndex < _steps.length - 1) {
      await _markCompleted();
      if (!mounted) return;
      _goToPage(_currentIndex + 1);
    } else {
      await _markCompleted();
      if (!mounted) return;
      context.go(AppRoutes.home);
    }
  }

  Future<void> _skipStep() async {
    final allSteps = _steps.map((s) => s.name).toList();
    final updatedProfile = _profile.copyWith(completedSteps: allSteps);
    await ref.read(onboardingProfileProvider.notifier).saveProfile(updatedProfile);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  Future<void> _captureVoiceAnswer() async {
    await _voiceController.captureSpeech(prompt: '');
    final transcript = _voiceController.currentTranscript ?? '';
    if (transcript.isEmpty) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _profile = _profile.copyWith(goalText: transcript);
    });
  }

  Future<void> _backStep() async {
    if (_currentIndex > 0) {
      _goToPage(_currentIndex - 1);
    }
  }

  Widget _buildMultiSelectSection({
    required String label,
    required List<String> options,
    required List<String> selectedValues,
    required ValueChanged<String> onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onToggle(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPage(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.personal:
        return OnboardingInputCard(
          title: step.title,
          description: step.description,
          child: SingleChildScrollView(
            child: Column(
              children: [
                OnboardingTextField(
                  label: 'Full name',
                  value: _profile.fullName,
                  onChanged: (value) => _updateProfile('fullName', value),
                  hintText: 'Enter your full name',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Preferred name',
                  value: _profile.preferredName,
                  onChanged: (value) => _updateProfile('preferredName', value),
                  hintText: 'Optional',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Date of birth',
                  value: _profile.dateOfBirth,
                  onChanged: (value) => _updateProfile('dateOfBirth', value),
                  hintText: 'YYYY-MM-DD',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Gender',
                  value: _profile.gender,
                  onChanged: (value) => _updateProfile('gender', value),
                  hintText: 'Optional',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OnboardingTextField(
                        label: 'Height',
                        value: _profile.height,
                        onChanged: (value) => _updateProfile('height', value),
                        hintText: 'e.g. 175 cm',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OnboardingTextField(
                        label: 'Weight',
                        value: _profile.weight,
                        onChanged: (value) => _updateProfile('weight', value),
                        hintText: 'e.g. 70 kg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Country',
                  value: _profile.country,
                  onChanged: (value) => _updateProfile('country', value),
                  hintText: 'Where are you based?',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Time zone',
                  value: _profile.timeZone,
                  onChanged: (value) => _updateProfile('timeZone', value),
                  hintText: 'e.g. Europe/London',
                ),
              ],
            ),
          ),
        );
      case OnboardingStep.work:
        return OnboardingInputCard(
          title: step.title,
          description: step.description,
          child: SingleChildScrollView(
            child: Column(
              children: [
                OnboardingTextField(
                  label: 'Occupation',
                  value: _profile.occupation,
                  onChanged: (value) => _updateProfile('occupation', value),
                  hintText: 'What do you do?',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Company',
                  value: _profile.company,
                  onChanged: (value) => _updateProfile('company', value),
                  hintText: 'Optional',
                ),
                const SizedBox(height: 12),
                OnboardingChoiceChips(
                  label: 'Work type',
                  options: const ['Remote', 'Hybrid', 'Office'],
                  selection: _profile.workType,
                  onSelected: (value) => _updateProfile('workType', value),
                ),
                const SizedBox(height: 12),
                OnboardingChoiceChips(
                  label: 'Shift type',
                  options: const ['Day', 'Evening', 'Night', 'Rotating'],
                  selection: _profile.shiftType,
                  onSelected: (value) => _updateProfile('shiftType', value),
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Typical work hours',
                  value: _profile.workHours,
                  onChanged: (value) => _updateProfile('workHours', value),
                  hintText: 'e.g. 09:00-17:00',
                ),
              ],
            ),
          ),
        );
      case OnboardingStep.health:
        return OnboardingInputCard(
          title: step.title,
          description: step.description,
          child: SingleChildScrollView(
            child: Column(
              children: [
                OnboardingTextField(
                  label: 'Sleep goal',
                  value: _profile.sleepGoal,
                  onChanged: (value) => _updateProfile('sleepGoal', value),
                  hintText: 'e.g. 7.5 hours',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Daily water goal',
                  value: _profile.waterGoal,
                  onChanged: (value) => _updateProfile('waterGoal', value),
                  hintText: 'e.g. 2.5 L',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Exercise frequency',
                  value: _profile.exerciseFrequency,
                  onChanged: (value) =>
                      _updateProfile('exerciseFrequency', value),
                  hintText: 'e.g. 4x per week',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Current fitness level',
                  value: _profile.fitnessLevel,
                  onChanged: (value) => _updateProfile('fitnessLevel', value),
                  hintText: 'Beginner, intermediate, advanced',
                ),
                const SizedBox(height: 12),
                _buildMultiSelectSection(
                  label: 'Health goals',
                  options: const [
                    'Sleep',
                    'Recovery',
                    'Strength',
                    'Mindfulness',
                    'Mobility',
                    'Stress Support',
                  ],
                  selectedValues: _profile.healthGoals,
                  onToggle: _toggleHealthGoal,
                ),
              ],
            ),
          ),
        );
      case OnboardingStep.finance:
        return OnboardingInputCard(
          title: step.title,
          description: step.description,
          child: SingleChildScrollView(
            child: Column(
              children: [
                OnboardingChoiceChips(
                  label: 'Currency',
                  options: const ['INR', 'EUR', 'GBP', 'JPY'],
                  selection: _profile.currency,
                  onSelected: (value) => _updateProfile('currency', value),
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Monthly income',
                  value: _profile.monthlyIncome,
                  onChanged: (value) => _updateProfile('monthlyIncome', value),
                  hintText: 'Optional',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Monthly budget',
                  value: _profile.monthlyBudget,
                  onChanged: (value) => _updateProfile('monthlyBudget', value),
                  hintText: 'e.g. 3000',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Savings goal',
                  value: _profile.savingsGoal,
                  onChanged: (value) => _updateProfile('savingsGoal', value),
                  hintText: 'e.g. 10% of income',
                ),
                const SizedBox(height: 12),
                _buildMultiSelectSection(
                  label: 'Financial priorities',
                  options: const [
                    'Emergency fund',
                    'Debt payoff',
                    'Investing',
                    'Travel',
                    'Home',
                    'Family',
                  ],
                  selectedValues: _profile.financialPriorities,
                  onToggle: _toggleFinancialPriority,
                ),
              ],
            ),
          ),
        );
      case OnboardingStep.goals:
        return OnboardingInputCard(
          title: step.title,
          description: step.description,
          child: SingleChildScrollView(
            child: Column(
              children: [
                OnboardingTextField(
                  label: 'Main life goals',
                  value: _profile.lifeGoals,
                  onChanged: (value) => _updateProfile('lifeGoals', value),
                  hintText: 'What matters most to you?',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Learning goals',
                  value: _profile.learningGoals,
                  onChanged: (value) => _updateProfile('learningGoals', value),
                  hintText: 'What do you want to learn?',
                ),
                const SizedBox(height: 12),
                OnboardingTextField(
                  label: 'Daily focus areas',
                  value: _profile.focusAreas,
                  onChanged: (value) => _updateProfile('focusAreas', value),
                  hintText: 'Work, health, family, creativity...',
                ),
                const SizedBox(height: 12),
                OnboardingChoiceChips(
                  label: 'Reminder preference',
                  options: const [
                    'Daily',
                    'Weekly',
                    'Focus mode',
                    'Smart nudges',
                  ],
                  selection: _profile.reminderPreference,
                  onSelected: (value) =>
                      _updateProfile('reminderPreference', value),
                ),
              ],
            ),
          ),
        );
      case OnboardingStep.aiPreferences:
        return OnboardingInputCard(
          title: step.title,
          description: step.description,
          child: SingleChildScrollView(
            child: Column(
              children: [
                OnboardingChoiceChips(
                  label: 'AI personality',
                  options: const [
                    'Professional',
                    'Friendly',
                    'Motivational',
                    'Minimal',
                  ],
                  selection: _profile.aiPersonality,
                  onSelected: (value) => _updateProfile('aiPersonality', value),
                ),
                const SizedBox(height: 12),
                OnboardingChoiceChips(
                  label: 'Notification preference',
                  options: const ['Quiet', 'Balanced', 'Frequent'],
                  selection: _profile.notificationPreference,
                  onSelected: (value) =>
                      _updateProfile('notificationPreference', value),
                ),
                const SizedBox(height: 12),
                OnboardingChoiceChips(
                  label: 'Theme preference',
                  options: const ['Dark', 'Light', 'Adaptive'],
                  selection: _profile.themePreference,
                  onSelected: (value) =>
                      _updateProfile('themePreference', value),
                ),
                const SizedBox(height: 12),
                OnboardingChoiceChips(
                  label: 'Privacy preference',
                  options: const ['Standard', 'Private', 'Strict'],
                  selection: _profile.privacyPreference,
                  onSelected: (value) =>
                      _updateProfile('privacyPreference', value),
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(onboardingProfileProvider);

    _updateProfileState(profileAsync.asData?.value);

    return KnightPageScaffold(
      title: 'Onboarding',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Set up your KnightOS profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Chip(label: Text('${_currentIndex + 1}/${_steps.length}')),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _steps.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              reverseDuration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey(_steps[_currentIndex].name),
                child: _buildPage(_steps[_currentIndex]),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _captureVoiceAnswer,
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('Voice answer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!_canProceed())
            Text(
              'Complete the required fields to continue',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (_currentIndex > 0)
                OutlinedButton.icon(
                  onPressed: _backStep,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back'),
                )
              else
                const SizedBox.shrink(),
              const Spacer(),
              OutlinedButton(onPressed: _skipStep, child: const Text('Skip')),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: _canProceed() ? _nextStep : null,
                child: Text(
                  _currentIndex == _steps.length - 1 ? 'Finish' : 'Next',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
