import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/finance_settings_models.dart';
import '../../platform/sync/finance_settings_service.dart';
import '../../../../core/providers/preferences_provider.dart';

final financeSettingsServiceProvider = Provider<FinanceSettingsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FinanceSettingsService(prefs);
});

final financeSettingsProvider = NotifierProvider<FinanceSettingsController, FinanceSettings>(
  FinanceSettingsController.new,
);

class FinanceSettingsController extends Notifier<FinanceSettings> {
  @override
  FinanceSettings build() {
    _init();
    return FinanceSettings();
  }

  Future<void> _init() async {
    final service = ref.read(financeSettingsServiceProvider);
    state = await service.loadSettings();
  }

  Future<void> updateSettings(FinanceSettings newSettings) async {
    state = newSettings;
    await ref.read(financeSettingsServiceProvider).saveSettings(newSettings);
  }

  Future<void> toggleSmartSync(bool value) => updateSettings(state.copyWith(isSmartSyncEnabled: value));
  Future<void> toggleAutoSync(bool value) => updateSettings(state.copyWith(isAutoSyncEnabled: value));
  Future<void> setSyncFrequency(String value) => updateSettings(state.copyWith(syncFrequency: value));
  Future<void> toggleNotifyInbox(bool value) => updateSettings(state.copyWith(notifyInbox: value));
  Future<void> toggleNotifyBudgets(bool value) => updateSettings(state.copyWith(notifyBudgets: value));
  Future<void> toggleNotifyGoals(bool value) => updateSettings(state.copyWith(notifyGoals: value));
  Future<void> toggleNotifyAiInsights(bool value) => updateSettings(state.copyWith(notifyAiInsights: value));
  Future<void> setEvidenceRetention(int value) => updateSettings(state.copyWith(evidenceRetentionDays: value));
  Future<void> setDefaultExportFormat(String value) => updateSettings(state.copyWith(defaultExportFormat: value));
  Future<void> toggleAutoReport(bool value) => updateSettings(state.copyWith(isAutoReportEnabled: value));
  Future<void> toggleDeveloperMode(bool value) => updateSettings(state.copyWith(isDeveloperMode: value));
}
