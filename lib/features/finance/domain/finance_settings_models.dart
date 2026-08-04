class FinanceSettings {
  final bool isSmartSyncEnabled;
  final bool isAutoSyncEnabled;
  final String syncFrequency; // daily, weekly, monthly
  final bool notifyInbox;
  final bool notifyBudgets;
  final bool notifyGoals;
  final bool notifyAiInsights;
  final int evidenceRetentionDays; // 0 for indefinite
  final String defaultExportFormat; // pdf, csv, excel
  final bool isAutoReportEnabled;
  final bool isDeveloperMode;

  FinanceSettings({
    this.isSmartSyncEnabled = true,
    this.isAutoSyncEnabled = true,
    this.syncFrequency = 'daily',
    this.notifyInbox = true,
    this.notifyBudgets = true,
    this.notifyGoals = true,
    this.notifyAiInsights = true,
    this.evidenceRetentionDays = 0,
    this.defaultExportFormat = 'pdf',
    this.isAutoReportEnabled = false,
    this.isDeveloperMode = false,
  });

  FinanceSettings copyWith({
    bool? isSmartSyncEnabled,
    bool? isAutoSyncEnabled,
    String? syncFrequency,
    bool? notifyInbox,
    bool? notifyBudgets,
    bool? notifyGoals,
    bool? notifyAiInsights,
    int? evidenceRetentionDays,
    String? defaultExportFormat,
    bool? isAutoReportEnabled,
    bool? isDeveloperMode,
  }) {
    return FinanceSettings(
      isSmartSyncEnabled: isSmartSyncEnabled ?? this.isSmartSyncEnabled,
      isAutoSyncEnabled: isAutoSyncEnabled ?? this.isAutoSyncEnabled,
      syncFrequency: syncFrequency ?? this.syncFrequency,
      notifyInbox: notifyInbox ?? this.notifyInbox,
      notifyBudgets: notifyBudgets ?? this.notifyBudgets,
      notifyGoals: notifyGoals ?? this.notifyGoals,
      notifyAiInsights: notifyAiInsights ?? this.notifyAiInsights,
      evidenceRetentionDays: evidenceRetentionDays ?? this.evidenceRetentionDays,
      defaultExportFormat: defaultExportFormat ?? this.defaultExportFormat,
      isAutoReportEnabled: isAutoReportEnabled ?? this.isAutoReportEnabled,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
    );
  }
}
