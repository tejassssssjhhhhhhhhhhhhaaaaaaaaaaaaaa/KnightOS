import '../domain/entities/timeline_event.dart';
import '../domain/entities/evidence.dart';
import '../domain/events/integration_events.dart';
import '../services/event_bus.dart';
import '../services/evidence_service.dart';
import '../services/timeline_service.dart';
import '../internal/utils/knight_logger.dart';

/// Universal pipeline to transform raw data into KnightOS standard entities.
class NormalizationPipeline {
  NormalizationPipeline({
    required this.evidenceService,
    required this.timelineService,
    EventBus? eventBus,
  })  : _eventBus = eventBus ?? EventBus.instance;

  final EvidenceService evidenceService;
  final TimelineService timelineService;
  final EventBus _eventBus;

  /// Processes raw data from a connector.
  /// Decoupled into [ingestRawData] and [projectEvidenceToTimeline].
  Future<void> process({
    required String connectorId,
    required String type,
    required Map<String, dynamic> rawData,
    required String caid,
    bool immediateProjection = true,
  }) async {
    KnightLogger.info('[PIPE] Processing $type from $connectorId');

    final evidence = await ingestRawData(
      connectorId: connectorId,
      type: type,
      rawData: rawData,
      caid: caid,
    );

    if (immediateProjection) {
      await projectEvidenceToTimeline(evidence, rawData);
    }
  }

  /// Stage 1: Ingestion - Raw Data to Evidence Node
  Future<Evidence> ingestRawData({
    required String connectorId,
    required String type,
    required Map<String, dynamic> rawData,
    required String caid,
  }) async {
    final evidence = await evidenceService.ingest(
      caid: caid,
      originalName: rawData['source_name'] ?? 'imported_document',
      mimeType: rawData['mime_type'] ?? 'application/octet-stream',
      fileSize: rawData['size'] ?? 0,
      storagePath: rawData['path'] ?? '',
      metadata: {
        'source_connector': connectorId,
        'original_type': type,
        'ingestion_timestamp': DateTime.now().toIso8601String(),
        ...rawData, // Preserve all raw data in metadata for explainability
      },
    );

    _eventBus.publish(EvidenceImported(
      connectorId: connectorId,
      timestamp: DateTime.now(),
      evidenceId: evidence.caid,
      type: type,
    ));

    return evidence;
  }

  /// Stage 2: Projection - Verified Evidence to Timeline Engine
  Future<void> projectEvidenceToTimeline(Evidence evidence, Map<String, dynamic> data) async {
    final type = data['original_type'] ?? evidence.extractionData['original_type'] ?? 'unknown';
    
    if (data.containsKey('timestamp') || data.containsKey('start_time')) {
      final startTime = DateTime.tryParse(data['timestamp'] ?? data['start_time'] ?? '') ?? DateTime.now();
      
      await timelineService.record(
        type: _mapToTimelineType(type),
        title: data['title'] ?? 'Imported $type',
        startTime: startTime,
        endTime: DateTime.tryParse(data['end_time'] ?? '') ?? startTime,
        location: data['location'],
        originProviderId: data['source_connector'] ?? evidence.extractionData['source_connector'],
        originResourceId: data['id'],
        metadata: {
          'evidence_id': evidence.caid,
          'confidence': evidence.confidence,
        },
      );
      
      KnightLogger.info('[PIPE] Projected evidence ${evidence.caid} to Timeline');
    }
  }

  TimelineEventType _mapToTimelineType(String type) {
    switch (type.toLowerCase()) {
      case 'meeting':
      case 'calendar_event':
        return TimelineEventType.meeting;
      case 'commit':
      case 'work':
        return TimelineEventType.workSession;
      case 'transaction':
        return TimelineEventType.transaction;
      case 'certificate':
      case 'promotion':
        return TimelineEventType.milestone;
      default:
        return TimelineEventType.activity;
    }
  }
}
