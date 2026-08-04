import 'package:flutter/foundation.dart';

enum ChartTimePeriod { day, week, month, year }

@immutable
class HealthChartDataPoint {
  const HealthChartDataPoint({
    required this.x,
    required this.y,
    this.label,
  });

  final double x;
  final double y;
  final String? label;
}

@immutable
class HealthChartSeries {
  const HealthChartSeries({
    required this.metricType,
    required this.dataPoints,
    required this.unit,
    this.colorHex,
  });

  final String metricType;
  final List<HealthChartDataPoint> dataPoints;
  final String unit;
  final String? colorHex;
}
