import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/intelligence/domain/health_visualization_models.dart';
import '../../../core/intelligence/services/health_visualization_service.dart';

final healthPeriodProvider = StateProvider<ChartTimePeriod>((ref) => ChartTimePeriod.week);

final healthChartDataProvider = FutureProvider.family<HealthChartSeries, String>((ref, metricType) async {
  final service = ref.watch(healthVisualizationServiceProvider);
  final period = ref.watch(healthPeriodProvider);
  
  return service.getSeries(
    metricType: metricType,
    period: period,
    endDate: DateTime.now(),
  );
});
