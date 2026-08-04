import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';

class DeviceIntelligenceService {
  DeviceIntelligenceService({required this.db});
  final KnightDatabase db;

  Future<void> recordDeviceHealth({
    required String deviceId,
    required int batteryLevel,
    required bool isCharging,
    int? storageUsed,
    String? networkType,
  }) async {
    await db.into(db.deviceHealthTable).insert(DeviceHealthTableCompanion.insert(
      id: 'health-${DateTime.now().millisecondsSinceEpoch}',
      deviceId: deviceId,
      batteryLevel: batteryLevel,
      isCharging: isCharging,
      storageUsedBytes: Value(storageUsed),
      networkType: Value(networkType),
      timestamp: Value(DateTime.now()),
    ));
  }

  Future<List<DeviceHealthData>> getDeviceHistory(String deviceId, {int limit = 24}) {
    return (db.select(db.deviceHealthTable)
          ..where((t) => t.deviceId.equals(deviceId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }
}

final deviceIntelligenceServiceProvider = Provider<DeviceIntelligenceService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return DeviceIntelligenceService(db: db);
});
