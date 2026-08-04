import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../domain/data_provider.dart';
import '../importers/base_parser.dart';
import 'data_ingestion_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';
import '../../internal/utils/knight_logger.dart';

class GoogleHealthProvider implements DataProvider {
  GoogleHealthProvider({
    required this.ingestionService,
    this.onChanged,
  });

  final DataIngestionService ingestionService;
  final Health _health = Health();
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'google_health_provider';

  @override
  String get name => 'Health Connect';

  @override
  ProviderStatus get status => _status;

  @override
  DateTime? get lastSyncTime => _lastSyncTime;

  @override
  String? get lastError => _lastError;

  @override
  SyncStats get stats => const SyncStats();

  @override
  Future<void> connect() async {
    _status = ProviderStatus.syncing;
    onChanged?.call();
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
        _status = ProviderStatus.connected;
        KnightLogger.info('Health Connect connected');
      } else {
        _status = ProviderStatus.disconnected;
      }
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
      KnightLogger.error('Health Connect connection failed', error: e);
    }
    onChanged?.call();
  }

  @override
  Future<void> disconnect() async {
    _status = ProviderStatus.disconnected;
    onChanged?.call();
  }

  @override
  Future<void> syncIncremental() async {
    if (_status != ProviderStatus.connected) return;

    _status = ProviderStatus.syncing;
    onChanged?.call();
    try {
      final now = DateTime.now();
      final startTime = _lastSyncTime ?? now.subtract(const Duration(days: 7));
      
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

      _lastSyncTime = now;
      _status = ProviderStatus.connected;
      KnightLogger.info('Synced ${healthData.length} health records');
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
      KnightLogger.error('Health sync failed', error: e);
    }
    onChanged?.call();
  }
}
