import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'base_parser.dart';
import '../../internal/storage/drift/knight_database.dart';

class TimelineParser implements BaseParser {
  @override
  String get docType => 'location_history';

  @override
  int get version => 1;

  @override
  Future<ParsedData> parse(File file) async {
    final content = await file.readAsString();
    return compute(_parseInBackground, content);
  }

  static ParsedData _parseInBackground(String content) {
    final data = jsonDecode(content) as Map<String, dynamic>;
    final segments = data['semanticSegments'] as List?;
    
    if (segments == null) return const ParsedData();

    final events = <TimelineEventTableCompanion>[];
    final health = <HealthMetricTableCompanion>[];

    for (final segment in segments) {
      final startTime = DateTime.tryParse(segment['startTime'] ?? '');
      final endTime = DateTime.tryParse(segment['endTime'] ?? '');
      
      if (startTime == null || endTime == null) continue;

      String type = 'unknown';
      String title = 'Unknown Event';
      String? location;

      if (segment['activity'] != null) {
        final activity = segment['activity'];
        type = 'activity';
        final topType = activity['topCandidate']?['type'] ?? 'Activity';
        title = topType;
        
        // Extract health metric if it's a movement activity
        final distance = (activity['distanceMeters'] as num?)?.toDouble() ?? 0.0;
        if (distance > 0) {
          health.add(HealthMetricTableCompanion.insert(
            id: 'dist-${startTime.millisecondsSinceEpoch}',
            metricType: 'distance',
            value: distance,
            unit: 'meters',
            startTime: startTime,
            endTime: Value(endTime),
            source: 'imported_timeline',
          ));
          
          // Heuristic: 1.3 meters per step
          health.add(HealthMetricTableCompanion.insert(
            id: 'steps-${startTime.millisecondsSinceEpoch}',
            metricType: 'steps',
            value: distance / 0.75, // Better average
            unit: 'count',
            startTime: startTime,
            endTime: Value(endTime),
            source: 'imported_timeline',
          ));
        }
      } else if (segment['visit'] != null) {
        type = 'visit';
        final visit = segment['visit'];
        final candidate = visit['topCandidate'];
        title = candidate?['placeId'] ?? 'Location Visit';
        if (candidate?['placeLocation'] != null) {
           location = jsonEncode(candidate['placeLocation']);
        }
      }

      events.add(TimelineEventTableCompanion.insert(
        id: 'timeline-${startTime.millisecondsSinceEpoch}',
        type: type,
        title: title,
        startTime: startTime,
        endTime: endTime,
        location: Value(location),
        metadata: Value(jsonEncode(segment)),
        originProviderId: const Value('google_location_history'),
        confidenceScore: const Value(1.0),
        verificationState: const Value('OBSERVED'),
      ));
    }

    return ParsedData(
      timelineEvents: events,
      healthMetrics: health,
    );
  }
}
