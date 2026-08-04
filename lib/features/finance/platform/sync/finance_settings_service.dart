import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/finance_settings_models.dart';

class FinanceSettingsService {
  final SharedPreferences prefs;

  FinanceSettingsService(this.prefs);

  static const _keyPrefix = 'knight_finance_';

  Future<FinanceSettings> loadSettings() async {
    return FinanceSettings(
      isSmartSyncEnabled: prefs.getBool('${_keyPrefix}smart_sync') ?? true,
      isAutoSyncEnabled: prefs.getBool('${_keyPrefix}auto_sync') ?? true,
      syncFrequency: prefs.getString('${_keyPrefix}sync_freq') ?? 'daily',
      notifyInbox: prefs.getBool('${_keyPrefix}notify_inbox') ?? true,
      notifyBudgets: prefs.getBool('${_keyPrefix}notify_budgets') ?? true,
      notifyGoals: prefs.getBool('${_keyPrefix}notify_goals') ?? true,
      notifyAiInsights: prefs.getBool('${_keyPrefix}notify_ai') ?? true,
      evidenceRetentionDays: prefs.getInt('${_keyPrefix}retention') ?? 0,
      defaultExportFormat: prefs.getString('${_keyPrefix}export_format') ?? 'pdf',
      isAutoReportEnabled: prefs.getBool('${_keyPrefix}auto_report') ?? false,
      isDeveloperMode: prefs.getBool('${_keyPrefix}dev_mode') ?? false,
    );
  }

  Future<void> saveSettings(FinanceSettings settings) async {
    await prefs.setBool('${_keyPrefix}smart_sync', settings.isSmartSyncEnabled);
    await prefs.setBool('${_keyPrefix}auto_sync', settings.isAutoSyncEnabled);
    await prefs.setString('${_keyPrefix}sync_freq', settings.syncFrequency);
    await prefs.setBool('${_keyPrefix}notify_inbox', settings.notifyInbox);
    await prefs.setBool('${_keyPrefix}notify_budgets', settings.notifyBudgets);
    await prefs.setBool('${_keyPrefix}notify_goals', settings.notifyGoals);
    await prefs.setBool('${_keyPrefix}notify_ai', settings.notifyAiInsights);
    await prefs.setInt('${_keyPrefix}retention', settings.evidenceRetentionDays);
    await prefs.setString('${_keyPrefix}export_format', settings.defaultExportFormat);
    await prefs.setBool('${_keyPrefix}auto_report', settings.isAutoReportEnabled);
    await prefs.setBool('${_keyPrefix}dev_mode', settings.isDeveloperMode);
  }
}
