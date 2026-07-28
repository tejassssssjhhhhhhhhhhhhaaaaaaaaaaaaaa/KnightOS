import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/import_models.dart';
import '../../domain/import_provider.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/domain/models/models.dart';

class GoogleTimelineProvider implements ImportProvider {
  @override
  String get id => 'google_timeline';

  @override
  String get displayName => 'Google Timeline';

  @override
  String get description =>
      'Import location history and semantic places from Google JSON.';

  @override
  IconData get icon => Icons.location_on_rounded;

  @override
  Color get accentColor => DesignColors.travel;

  @override
  bool canHandle(File file) => file.path.endsWith('.json');

  @override
  Future<ImportResult> parse(File file, {required String jobId}) async {
    try {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      final segments = data['semanticSegments'] as List<dynamic>? ?? [];

      final events = <TimelineEvent>[];

      for (final segment in segments) {
        final startTime = DateTime.tryParse(segment['startTime'] ?? '');
        if (startTime == null) continue;

        if (segment['activity'] != null) {
          final activity = segment['activity'];
          final type = activity['topCandidate']?['type'] ?? 'MOVE';
          events.add(
            TimelineEvent(
              id: '${jobId}_${events.length}',
              title: 'Activity: $type',
              timestamp: startTime,
              category: TimelineCategory.travel,
              subtitle:
                  'Distance: ${activity['distanceMeters']?.toStringAsFixed(0)}m',
              content: segment as Map<String, dynamic>,
            ),
          );
        } else if (segment['visit'] != null) {
          final visit = segment['visit'];
          final placeId = visit['topCandidate']?['placeId'] ?? 'Location';
          events.add(
            TimelineEvent(
              id: '${jobId}_${events.length}',
              title: 'Visit: $placeId',
              timestamp: startTime,
              category: TimelineCategory.personal,
              subtitle: 'Confidence: ${(visit['probability'] * 100).toInt()}%',
              content: segment as Map<String, dynamic>,
            ),
          );
        }
      }

      return ImportResult(
        success: true,
        message: 'Synthesized ${events.length} timeline events.',
        timelineEvents: events,
      );
    } catch (e) {
      return ImportResult(success: false, message: 'Parsing failure: $e');
    }
  }
}
