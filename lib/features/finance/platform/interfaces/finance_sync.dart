abstract class ISmartSyncEngine {
  Future<void> startSync();
  Future<void> startHistoricalScan();
  Future<void> repair();
  
  Stream<SyncProgress> get progress;
}

class SyncProgress {
  final double percentage;
  final String currentStage;
  final String status;

  SyncProgress({
    required this.percentage,
    required this.currentStage,
    required this.status,
  });
}
