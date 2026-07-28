import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/recovery_metric.dart';
import '../domain/recovery_repository.dart';

/// Persistence-backed implementation of [RecoveryRepository] using [LocalDatabase].
class LocalRecoveryRepository implements RecoveryRepository {
  LocalRecoveryRepository({LocalDatabase? database})
    : _database = database ?? const LocalDatabase();

  final LocalDatabase _database;
  List<RecoveryMetric>? _cache;

  @override
  Future<List<RecoveryMetric>> getRecoveryMetrics() async {
    if (_cache != null) return _cache!;

    final data = await _database.readJsonList(StorageKeys.recoveryMetrics);
    if (data == null) {
      _cache = RecoveryMetric.defaults;
      return _cache!;
    }

    try {
      _cache = data
          .map((e) => RecoveryMetric.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      _cache = RecoveryMetric.defaults;
      return _cache!;
    }
  }

  @override
  Future<void> updateMetric(RecoveryMetric metric) async {
    final metrics = await getRecoveryMetrics();
    final index = metrics.indexWhere((m) => m.category == metric.category);

    final updatedList = List<RecoveryMetric>.from(metrics);
    if (index != -1) {
      updatedList[index] = metric;
    } else {
      updatedList.add(metric);
    }

    _cache = updatedList;
    await _database.writeJsonList(
      StorageKeys.recoveryMetrics,
      updatedList.map((m) => m.toJson()).toList(),
    );
  }
}
