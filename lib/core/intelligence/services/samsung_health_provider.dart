import 'dart:async';
import 'package:health/health.dart';
import '../domain/data_provider.dart';
import 'data_ingestion_service.dart';
import 'base_data_provider.dart';
import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';

class SamsungHealthProvider extends BaseDataProvider {
  SamsungHealthProvider({
    required this.ingestionService,
    required super.db,
    super.onChanged,
  });

  final DataIngestionService ingestionService;
  final Health _health = Health();

  @override
  String get id => 'samsung_health_provider';

  @override
  String get name => 'Samsung Health';

  @override
  Future<void> connect() async {
    updateInternalState(status: ProviderStatus.syncing, error: '');
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
        updateInternalState(status: ProviderStatus.connected, error: '');
        KnightLogger.info('Samsung Health connected');
      } else {
        updateInternalState(status: ProviderStatus.disconnected);
      }
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
      KnightLogger.error('Samsung Health connection failed', error: e);
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
      final startTime = lastSuccessfulSync ?? now.subtract(const Duration(days: 1));
      
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
        final recordId = 'sh-$metricType-${data.dateFrom.millisecondsSinceEpoch}';
        final val = double.tryParse(data.value.toString()) ?? 0.0;

        if (data.type == HealthDataType.WORKOUT) {
          workouts.add(WorkoutSessionTableCompanion.insert(
            id: recordId,
            workoutType: data.value.toString(),
            durationMinutes: Value(data.dateTo.difference(data.dateFrom).inMinutes.toDouble()),
            startTime: data.dateFrom,
            sourceProvider: const Value('samsung_health'),
            sourceIdentifier: Value(recordId),
          ));
        } else if (data.type == HealthDataType.WEIGHT || data.type == HealthDataType.BODY_FAT_PERCENTAGE || data.type == HealthDataType.BODY_MASS_INDEX) {
           measurements.add(BodyMeasurementTableCompanion.insert(
             id: recordId,
             measurementType: metricType,
             value: val,
             unit: data.unitString,
             measuredAt: Value(data.dateFrom),
             sourceProvider: const Value('samsung_health'),
             sourceIdentifier: Value(recordId),
           ));
        } else {
          metrics.add(HealthMetricTableCompanion.insert(
            id: recordId,
            metricType: metricType,
            value: val,
            unit: data.unitString,
            startTime: data.dateFrom,
            source: 'samsung_health',
            sourceProvider: const Value('samsung_health'),
            sourceIdentifier: Value(recordId),
          ));
        }
      }

      await db.batch((batch) {
        batch.insertAll(db.healthMetricTable, metrics, mode: InsertMode.insertOrReplace);
        batch.insertAll(db.workoutSessionTable, workouts, mode: InsertMode.insertOrReplace);
        batch.insertAll(db.bodyMeasurementTable, measurements, mode: InsertMode.insertOrReplace);
      });

      updateInternalState(
        status: ProviderStatus.connected, 
        successful: now, 
        error: '', 
        stats: SyncStats(fetched: healthData.length, created: healthData.length)
      );
      KnightLogger.info('Synced ${healthData.length} records from Samsung Health');
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
      KnightLogger.error('Samsung Health sync failed', error: e);
    }
  }
}
