import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/onboarding/domain/onboarding_profile.dart';
import '../../features/onboarding/onboarding_controller.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/preference_switch.dart';
import '../widgets/knight_page_scaffold.dart';

enum SettingsView { settings, profile, privacy }

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({this.view = SettingsView.settings, super.key});

  final SettingsView view;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _preferredNameController;
  late final TextEditingController _dobController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _countryController;
  late final TextEditingController _timezoneController;
  late final TextEditingController _occupationController;
  late final TextEditingController _workTypeController;
  late final TextEditingController _shiftTypeController;
  late final TextEditingController _sleepGoalController;
  late final TextEditingController _waterGoalController;
  late final TextEditingController _exerciseGoalController;
  late final TextEditingController _monthlyBudgetController;
  late final TextEditingController _monthlyIncomeController;
  late final TextEditingController _savingsGoalController;
  late final TextEditingController _emergencyFundController;
  late final TextEditingController _spendingCategoriesController;
  late final TextEditingController _categoryLimitsController;
  late final TextEditingController _aiPersonalityController;
  late final TextEditingController _aiResponseStyleController;
  late final TextEditingController _motivationLevelController;

  bool _notificationsEnabled = true;
  bool _dailyReminderEnabled = true;
  bool _weeklyReviewEnabled = true;
  String _themeMode = 'System';
  bool _localStorageEnabled = true;
  String _occupation = '';
  String _workType = '';
  String _shiftType = '';
  String _country = '';
  String _healthGoal = 'General Fitness';
  String _timezone = 'IST';
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _preferredNameController = TextEditingController();
    _dobController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _countryController = TextEditingController();
    _timezoneController = TextEditingController();
    _occupationController = TextEditingController();
    _workTypeController = TextEditingController();
    _shiftTypeController = TextEditingController();
    _sleepGoalController = TextEditingController();
    _waterGoalController = TextEditingController();
    _exerciseGoalController = TextEditingController();
    _monthlyBudgetController = TextEditingController();
    _monthlyIncomeController = TextEditingController();
    _savingsGoalController = TextEditingController();
    _emergencyFundController = TextEditingController();
    _spendingCategoriesController = TextEditingController();
    _categoryLimitsController = TextEditingController();
    _aiPersonalityController = TextEditingController();
    _aiResponseStyleController = TextEditingController();
    _motivationLevelController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _preferredNameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _countryController.dispose();
    _timezoneController.dispose();
    _occupationController.dispose();
    _workTypeController.dispose();
    _shiftTypeController.dispose();
    _sleepGoalController.dispose();
    _waterGoalController.dispose();
    _exerciseGoalController.dispose();
    _monthlyBudgetController.dispose();
    _monthlyIncomeController.dispose();
    _savingsGoalController.dispose();
    _emergencyFundController.dispose();
    _spendingCategoriesController.dispose();
    _categoryLimitsController.dispose();
    _aiPersonalityController.dispose();
    _aiResponseStyleController.dispose();
    _motivationLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(onboardingProfileProvider);

    final viewTitle = widget.view == SettingsView.profile
        ? 'Profile'
        : widget.view == SettingsView.privacy
            ? 'Privacy'
            : 'Settings';

    return KnightPageScaffold(
      title: viewTitle,
      showBackButton: true,
      body: profileAsync.when(
        data: (profile) {
          if (profile != null) {
            _populateControllers(profile);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCard(
                  name: _valueOrFallback(profile?.preferredName, profile?.fullName, 'Knight User'),
                  subtitle: 'Manage your saved profile and daily preferences',
                ),
                const SizedBox(height: 20),
                if (widget.view != SettingsView.privacy)
                  SettingsSection(
                    title: 'Profile',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildTextField('Full Name', _fullNameController),
                        _buildTextField('Preferred Name', _preferredNameController),
                        _buildDatePicker('Date of Birth', _dobController),
                        _buildHeightField(),
                        _buildWeightField(),
                        _buildDropdownField('Country', _country, ['India', 'United States', 'United Kingdom', 'Canada', 'Australia'], (value) => setState(() => _country = value ?? 'India')),
                        _buildDropdownField('Timezone', _timezone, ['IST', 'UTC', 'GMT', 'EST', 'PST'], (value) => setState(() => _timezone = value ?? 'IST')),
                        _buildDropdownField('Occupation', _occupation, ['Product Manager', 'Engineer', 'Designer', 'Founder', 'Student'], (value) => setState(() => _occupation = value ?? '')),
                        _buildDropdownField('Work Type', _workType, ['Remote', 'Hybrid', 'On-site'], (value) => setState(() => _workType = value ?? '')),
                        _buildDropdownField('Shift Type', _shiftType, ['Day', 'Night', 'Flexible'], (value) => setState(() => _shiftType = value ?? '')),
                      ],
                    ),
                  ),
                if (widget.view != SettingsView.privacy) const SizedBox(height: 20),
                if (widget.view != SettingsView.privacy)
                  SettingsSection(
                    title: 'Health Goals',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildDropdownField('Goal', _healthGoal, ['General Fitness', 'Weight Loss', 'Muscle Gain', 'Strength', 'Endurance', 'Flexibility', 'Custom'], (value) => setState(() => _healthGoal = value ?? 'General Fitness')),
                        _buildTextField('Sleep Goal', _sleepGoalController),
                        _buildTextField('Water Goal', _waterGoalController),
                        _buildTextField('Exercise Goal', _exerciseGoalController),
                      ],
                    ),
                  ),
                if (widget.view != SettingsView.privacy) const SizedBox(height: 20),
                if (widget.view != SettingsView.privacy)
                  SettingsSection(
                    title: 'Finance Setup',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildTextField('Monthly Income', _monthlyIncomeController),
                        _buildTextField('Emergency Fund Goal', _emergencyFundController),
                        _buildTextField('Spending Categories', _spendingCategoriesController),
                        _buildTextField('Monthly Category Limits', _categoryLimitsController),
                        _buildTextField('Savings Goal', _savingsGoalController),
                      ],
                    ),
                  ),
                if (widget.view != SettingsView.profile) const SizedBox(height: 20),
                if (widget.view != SettingsView.profile)
                  SettingsSection(
                    title: 'Privacy & App Settings',
                    child: Column(
                      children: [
                        SettingsTile(
                          title: 'Theme',
                          subtitle: _themeMode,
                          leading: Icons.palette_outlined,
                          onTap: () async {
                            final mode = await _pickThemeMode(context);
                            if (mode != null) {
                              setState(() => _themeMode = mode);
                            }
                          },
                        ),
                        PreferenceSwitch(
                          title: 'Enable Notifications',
                          subtitle: 'Receive reminders and system prompts.',
                          value: _notificationsEnabled,
                          onChanged: (value) => setState(() => _notificationsEnabled = value),
                        ),
                        PreferenceSwitch(
                          title: 'Daily Reminder',
                          subtitle: 'Get a reminder for your daily mission.',
                          value: _dailyReminderEnabled,
                          onChanged: (value) => setState(() => _dailyReminderEnabled = value),
                        ),
                        PreferenceSwitch(
                          title: 'Weekly Review Reminder',
                          subtitle: 'Review your habits and goals every week.',
                          value: _weeklyReviewEnabled,
                          onChanged: (value) => setState(() => _weeklyReviewEnabled = value),
                        ),
                        PreferenceSwitch(
                          title: 'Local Storage',
                          subtitle: 'Keep profile data available on this device.',
                          value: _localStorageEnabled,
                          onChanged: (value) => setState(() => _localStorageEnabled = value),
                        ),
                        SettingsTile(
                          title: 'Data Export',
                          subtitle: 'Data remains stored locally on this device.',
                          leading: Icons.file_download_outlined,
                          onTap: () {},
                        ),
                        SettingsTile(
                          title: 'Clear Local Data',
                          subtitle: 'Remove the saved profile from local storage',
                          leading: Icons.delete_outline,
                          onTap: () async {
                            if (!mounted) return;
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            await ref.read(onboardingProfileProvider.notifier).clearProfile();
                            if (!mounted) return;
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('Local profile data cleared.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                if (widget.view != SettingsView.profile) const SizedBox(height: 20),
                if (widget.view != SettingsView.profile)
                  SettingsSection(
                    title: 'AI Settings',
                    child: Column(
                      children: [
                        _buildTextField('AI Personality', _aiPersonalityController),
                        _buildTextField('AI Response Style', _aiResponseStyleController),
                        _buildTextField('Motivation Level', _motivationLevelController),
                      ],
                    ),
                  ),
                if (widget.view != SettingsView.profile) const SizedBox(height: 20),
                if (widget.view != SettingsView.profile)
                  SettingsSection(
                    title: 'App Updates',
                    child: Column(
                      children: [
                        SettingsTile(
                          title: 'App Updates',
                          subtitle: 'Check your release status and available updates.',
                          leading: Icons.system_update_outlined,
                          onTap: () => context.push(AppRoutes.appUpdates),
                        ),
                      ],
                    ),
                  ),
                if (widget.view != SettingsView.profile) const SizedBox(height: 20),
                if (widget.view != SettingsView.profile)
                  SettingsSection(
                    title: 'About',
                    child: Column(
                      children: [
                        SettingsTile(title: 'KnightOS Version', subtitle: '1.0.0', leading: Icons.info_outline),
                        SettingsTile(title: 'Build Number', subtitle: '2026.07.23', leading: Icons.build_outlined),
                        SettingsTile(title: 'Flutter Version', subtitle: '3.x', leading: Icons.developer_board_outlined),
                        SettingsTile(title: 'License', subtitle: 'MIT', leading: Icons.description_outlined),
                        SettingsTile(title: 'Privacy Policy', subtitle: 'Local-first and privacy focused', leading: Icons.privacy_tip_outlined),
                      ],
                    ),
                  ),
                if (widget.view != SettingsView.privacy) const SizedBox(height: 20),
                if (widget.view != SettingsView.privacy)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Profile'),
                    ),
                  ),
                if (widget.view == SettingsView.privacy)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Your personal data remains local to this device. We keep backups in the same secure storage location as your profile.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                if (widget.view == SettingsView.privacy) const SizedBox(height: 20),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Unable to load settings: $error')),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(labelText: label, suffixIcon: const Icon(Icons.calendar_today_outlined)),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            controller.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
          }
        },
      ),
    );
  }

  Widget _buildHeightField() {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: _heightController,
        decoration: InputDecoration(
          labelText: 'Height',
          suffixText: _heightUnit,
        ),
      ),
    );
  }

  Widget _buildWeightField() {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: _weightController,
        decoration: InputDecoration(
          labelText: 'Weight',
          suffixText: _weightUnit,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 260,
      child: DropdownButtonFormField<String>(
        initialValue: value.isEmpty ? null : value,
        decoration: InputDecoration(labelText: label),
        items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<String?> _pickThemeMode(BuildContext context) async {
    final modes = ['System', 'Light', 'Dark'];
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Theme'),
        children: modes
            .map(
              (mode) => SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(mode),
                child: Text(mode),
              ),
            )
            .toList(),
      ),
    );
    return result;
  }

  void _populateControllers(OnboardingProfile profile) {
    if (!mounted) return;

    _fullNameController.text = profile.fullName;
    _preferredNameController.text = profile.preferredName;
    _dobController.text = profile.dateOfBirth;
    _heightController.text = profile.height;
    _weightController.text = profile.weight;
    _countryController.text = profile.country;
    _timezoneController.text = profile.timeZone.isEmpty ? 'IST' : profile.timeZone;
    _occupationController.text = profile.occupation;
    _workTypeController.text = profile.workType;
    _shiftTypeController.text = profile.shiftType;
    _sleepGoalController.text = profile.sleepGoal.isEmpty ? '8 hours' : profile.sleepGoal;
    _waterGoalController.text = profile.waterGoal.isEmpty ? '3L' : profile.waterGoal;
    _exerciseGoalController.text = profile.exerciseFrequency.isEmpty ? 'General Fitness' : profile.exerciseFrequency;
    _monthlyBudgetController.text = profile.monthlyBudget;
    _monthlyIncomeController.text = profile.monthlyIncome;
    _savingsGoalController.text = profile.savingsGoal;
    _emergencyFundController.text = profile.financialPriorities.isEmpty ? '3 months' : profile.financialPriorities.first;
    _spendingCategoriesController.text = profile.healthGoals.isEmpty ? 'Housing, Food, Transport' : profile.healthGoals.join(', ');
    _categoryLimitsController.text = profile.focusAreas.isEmpty ? 'Recommended monthly caps' : profile.focusAreas;
    _aiPersonalityController.text = profile.aiPersonality;
    _aiResponseStyleController.text = profile.aiTone;
    _motivationLevelController.text = profile.aiDepth;

    _themeMode = profile.themePreference.isEmpty ? 'System' : profile.themePreference;
    _notificationsEnabled = profile.notificationPreference.isEmpty || profile.notificationPreference.contains('Enable');
    _dailyReminderEnabled = profile.notificationPreference.contains('Daily') || profile.notificationPreference.contains('Reminder');
    _weeklyReviewEnabled = profile.notificationPreference.contains('Weekly');
    _localStorageEnabled = true;
    _occupation = profile.occupation.isEmpty ? '' : profile.occupation;
    _workType = profile.workType.isEmpty ? '' : profile.workType;
    _shiftType = profile.shiftType.isEmpty ? '' : profile.shiftType;
    _country = profile.country.isEmpty ? 'India' : profile.country;
    _timezone = profile.timeZone.isEmpty ? 'IST' : profile.timeZone;
    _healthGoal = profile.exerciseFrequency.isEmpty ? 'General Fitness' : profile.exerciseFrequency;
    _heightUnit = 'cm';
    _weightUnit = 'kg';
  }

  Future<void> _saveProfile() async {
    final profile = OnboardingProfile(
      completedSteps: const ['personal', 'work', 'health', 'finance', 'goals', 'aiPreferences'],
      fullName: _fullNameController.text.trim(),
      preferredName: _preferredNameController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      height: _heightController.text.trim(),
      weight: _weightController.text.trim(),
      country: _countryController.text.trim(),
      timeZone: _timezoneController.text.trim().isEmpty ? 'IST' : _timezoneController.text.trim(),
      occupation: _occupationController.text.trim(),
      workType: _workTypeController.text.trim(),
      shiftType: _shiftTypeController.text.trim(),
      sleepGoal: _sleepGoalController.text.trim().isEmpty ? '8 hours' : _sleepGoalController.text.trim(),
      waterGoal: _waterGoalController.text.trim().isEmpty ? '3L' : _waterGoalController.text.trim(),
      exerciseFrequency: _exerciseGoalController.text.trim().isEmpty ? _healthGoal : _exerciseGoalController.text.trim(),
      monthlyBudget: _monthlyBudgetController.text.trim(),
      monthlyIncome: _monthlyIncomeController.text.trim(),
      savingsGoal: _savingsGoalController.text.trim(),
      financialPriorities: _emergencyFundController.text.trim().isEmpty ? const ['3 months'] : [_emergencyFundController.text.trim()],
      healthGoals: _spendingCategoriesController.text.trim().isEmpty ? const ['Housing', 'Food', 'Transport'] : _spendingCategoriesController.text.split(',').map((value) => value.trim()).where((value) => value.isNotEmpty).toList(),
      focusAreas: _categoryLimitsController.text.trim().isEmpty ? 'Recommended monthly caps' : _categoryLimitsController.text.trim(),
      aiPersonality: _aiPersonalityController.text.trim(),
      aiTone: _aiResponseStyleController.text.trim(),
      aiDepth: _motivationLevelController.text.trim(),
      themePreference: _themeMode,
      notificationPreference: _buildNotificationPreference(),
    );

    await ref.read(onboardingProfileProvider.notifier).saveProfile(profile);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved locally.')),
      );
    }
  }

  String _buildNotificationPreference() {
    final parts = <String>[];
    if (_notificationsEnabled) {
      parts.add('Enable Notifications');
    }
    if (_dailyReminderEnabled) {
      parts.add('Daily Reminder');
    }
    if (_weeklyReviewEnabled) {
      parts.add('Weekly Review Reminder');
    }
    return parts.join(', ');
  }

  String _valueOrFallback(String? primary, String? fallback, String defaultValue) {
    final value = (primary ?? fallback ?? '').trim();
    return value.isEmpty ? defaultValue : value;
  }
}
