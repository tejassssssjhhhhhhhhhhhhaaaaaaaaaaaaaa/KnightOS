import 'dart:async';
import 'package:health/health.dart';
import '../domain/data_provider.dart';
import '../importers/base_parser.dart';
import 'data_ingestion_service.dart';
import 'base_data_provider.dart';
import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';

class GoogleHealthProvider extends BaseDataProvider {
  GoogleHealthProvider({
    required this.ingestionService,
    required super.db,
    super.onChanged,
  });

  final DataIngestionService ingestionService;
  final Health _health = Health();

  @override
  String get id => 'google_health_provider';

  @override
  String get name => 'Health Connect';

  @override
  Future<void> connect() async {
    updateInternalState(status: ProviderStatus.syncing, error: '');
    try {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.SLEEP_SESSION,
        HealthDataType.WORKOUT,
        HealthDataType.HEART_RATE,
        HealthDataType.WEIGHT,
      ];
      
      bool requested = await _health.requestAuthorization(types);
      if (requested) {
        updateInternalState(status: ProviderStatus.connected, error: '');
        KnightLogger.info('Health Connect connected');
      } else {
        updateInternalState(status: ProviderStatus.disconnected);
      }
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
      KnightLogger.error('Health Connect connection failed', error: e);
    }
  }

  @override
  Future<void> disconnect() async {
    updateInternalState(status: ProviderStatus.disconnected, error: '');
  }

  @override
  Future<void> syncIncremental() async {
    if (status != ProviderStatus.connected) return;

    updateInternalState(status: ProviderStatus.syncing, attempted: DateTime.now());
    try {
      final now = DateTime.now();
      final startTime = lastSuccessfulSync ?? now.subtract(const Duration(days: 7));
      
      final types = [
        HealthDataType.STEPS,
        HealthDataType.SLEEP_SESSION,
        HealthDataType.WORKOUT,
      ];

      final healthData = await _health.getHealthDataFromTypes(
        startTime: startTime,
        endTime: now,
        types: types,
      );

      final List<HealthMetricTableCompanion> metrics = [];
      final List<TimelineEventTableCompanion> events = [];

      for (final data in healthData) {
        if (data.type == HealthDataType.WORKOUT) {
          events.add(TimelineEventTableCompanion.insert(
            id: 'hc-workout-${data.dateFrom.millisecondsSinceEpoch}',
            title: 'Workout: ${data.value}',
            startTime: data.dateFrom,
            endTime: data.dateTo,
            type: 'workout',
            sourceProvider: const Value('google_health'),
            sourceIdentifier: Value('hc-w-${data.dateFrom.millisecondsSinceEpoch}'),
          ));
        } else {
          final metricType = data.typeString.toLowerCase();
          metrics.add(HealthMetricTableCompanion.insert(
            id: 'hc-metric-$metricType-${data.dateFrom.millisecondsSinceEpoch}',
            metricType: metricType,
            value: double.tryParse(data.value.toString()) ?? 0.0,
            unit: data.unitString,
            startTime: data.dateFrom,
            source: 'google_health',
            sourceProvider: const Value('google_health'),
            sourceIdentifier: Value('hc-$metricType-${data.dateFrom.millisecondsSinceEpoch}'),
          ));
        }
      }

      final parsedData = ParsedData(
        transactions: [],
        timelineEvents: events,
        healthMetrics: metrics,
      );
      await ingestionService.ingestCloudData('google_health', parsedData);

      updateInternalState(
        status: ProviderStatus.connected, 
        successful: now, 
        error: '', 
        stats: SyncStats(fetched: healthData.length, created: healthData.length)
      );
      KnightLogger.info('Synced ${healthData.length} health records');
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
      KnightLogger.error('Health sync failed', error: e);
    }
  }
}
