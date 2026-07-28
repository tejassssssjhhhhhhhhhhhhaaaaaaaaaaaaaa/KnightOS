import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/money_metric.dart';
import '../domain/money_repository.dart';

/// Persistence-backed implementation of [MoneyRepository] using [LocalDatabase].
class LocalMoneyRepository implements MoneyRepository {
  LocalMoneyRepository({LocalDatabase? database})
    : _database = database ?? const LocalDatabase();

  final LocalDatabase _database;
  List<MoneyMetric>? _cache;

  @override
  Future<List<MoneyMetric>> getMoneyMetrics() async {
    if (_cache != null) return _cache!;

    final data = await _database.readJsonList(StorageKeys.moneyMetrics);
    if (data == null) {
      _cache = MoneyMetric.defaults;
      return _cache!;
    }

    try {
      _cache = data
          .map((e) => MoneyMetric.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      // Fallback to defaults if data is corrupt
      _cache = MoneyMetric.defaults;
      return _cache!;
    }
  }

  @override
  Future<void> updateMetric(MoneyMetric metric) async {
    final metrics = await getMoneyMetrics();
    final index = metrics.indexWhere((m) => m.category == metric.category);

    final updatedList = List<MoneyMetric>.from(metrics);
    if (index != -1) {
      updatedList[index] = metric;
    } else {
      updatedList.add(metric);
    }

    _cache = updatedList;
    await _database.writeJsonList(
      StorageKeys.moneyMetrics,
      updatedList.map((m) => m.toJson()).toList(),
    );
  }
}
