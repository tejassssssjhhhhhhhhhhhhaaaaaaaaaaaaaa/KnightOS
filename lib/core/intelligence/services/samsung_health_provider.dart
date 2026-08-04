import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../domain/data_provider.dart';
import 'data_ingestion_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';
import '../../internal/utils/knight_logger.dart';

class SamsungHealthProvider implements DataProvider {
  SamsungHealthProvider({
    required this.ingestionService,
    required this.db,
    this.onChanged,
  });

  final DataIngestionService ingestionService;
  final KnightDatabase db;
  final Health _health = Health();
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'samsung_health_provider';

  @override
  String get name => 'Samsung Health';

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
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_SESSION,
        HealthDataType.BLOOD_OXYGEN,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.WEIGHT,
        HealthDataType.BODY_FAT_PERCENTAGE,
        HealthDataType.BODY_MASS_INDEX,
        HealthDataType.WORKOUT,
      ];
      
      bool requested = await _health.requestAuthorization(types);
      if (requested) {
        _status = ProviderStatus.connected;
        KnightLogger.info('Samsung Health connected');
      } else {
        _status = ProviderStatus.disconnected;
      }
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
      KnightLogger.error('Samsung Health connection failed', error: e);
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
      final startTime = _lastSyncTime ?? now.subtract(const Duration(days: 1));
      
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_SESSION,
        HealthDataType.BLOOD_OXYGEN,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.WEIGHT,
        HealthDataType.BODY_FAT_PERCENTAGE,
        HealthDataType.BODY_MASS_INDEX,
        HealthDataType.WORKOUT,
      ];

      final healthData = await _health.getHealthDataFromTypes(
        startTime: startTime,
        endTime: now,
        types: types,
      );

      final List<HealthMetricTableCompanion> metrics = [];
      final List<WorkoutSessionTableCompanion> workouts = [];
      final List<BodyMeasurementTableCompanion> measurements = [];

      for (final data in healthData) {
        final metricType = data.typeString.toLowerCase();
        final id = 'sh-$metricType-${data.dateFrom.millisecondsSinceEpoch}';
        final val = double.tryParse(data.value.toString()) ?? 0.0;

        if (data.type == HealthDataType.WORKOUT) {
          workouts.add(WorkoutSessionTableCompanion.insert(
            id: id,
            workoutType: data.value.toString(),
            durationMinutes: data.dateTo.difference(data.dateFrom).inMinutes.toDouble(),
            startTime: data.dateFrom,
            sourceProvider: const Value('samsung_health'),
            sourceIdentifier: Value(id),
          ));
        } else if (data.type == HealthDataType.WEIGHT || data.type == HealthDataType.BODY_FAT_PERCENTAGE || data.type == HealthDataType.BODY_MASS_INDEX) {
           measurements.add(BodyMeasurementTableCompanion.insert(
             id: id,
             measurementType: metricType,
             value: val,
             unit: data.unitString,
             measuredAt: Value(data.dateFrom),
             sourceProvider: const Value('samsung_health'),
             sourceIdentifier: Value(id),
           ));
        } else {
          metrics.add(HealthMetricTableCompanion.insert(
            id: id,
            metricType: metricType,
            value: val,
            unit: data.unitString,
            startTime: data.dateFrom,
            source: 'samsung_health',
            sourceProvider: const Value('samsung_health'),
            sourceIdentifier: Value(id),
          ));
        }
      }

      await db.batch((batch) {
        batch.insertAll(db.healthMetricTable, metrics, mode: InsertMode.insertOrReplace);
        batch.insertAll(db.workoutSessionTable, workouts, mode: InsertMode.insertOrReplace);
        batch.insertAll(db.bodyMeasurementTable, measurements, mode: InsertMode.insertOrReplace);
      });

      _lastSyncTime = now;
      _status = ProviderStatus.connected;
      KnightLogger.info('Synced ${healthData.length} records from Samsung Health');
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
      KnightLogger.error('Samsung Health sync failed', error: e);
    }
    onChanged?.call();
  }
}
