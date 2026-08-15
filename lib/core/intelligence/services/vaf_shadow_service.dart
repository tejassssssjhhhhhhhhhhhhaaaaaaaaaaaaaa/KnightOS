import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../engines/memory_engine.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../domain/memory_version.dart';
import '../../domain/entities/timeline_event.dart';
import '../../../features/finance/domain/finance_transaction.dart';

/// Service responsible for maintaining the Shadow VAF (Versioned Atomic Fact) layer.
/// It synchronizes domain-specific records from specialized storage into a 
/// unified semantic MemoryTable for cross-domain AI reasoning.
class VafShadowService {
  final MemoryEngine memoryEngine;

  VafShadowService({required this.memoryEngine});

  /// Shadows a financial transaction into the VAF layer.
  Future<void> shadowTransaction(TransactionData tx) async {
    await _saveShadow(
      id: 'finance_tx_${tx.transactionId}',
      category: BookCategory.finance,
      domain: MemoryDomain.finance,
      source: MemorySource.imported,
      provenance: tx.originProviderId ?? tx.institution,
      effectiveAt: tx.transactionDate,
      confidence: tx.confidenceScore ?? 1.0,
      summary: '${tx.type == 'income' ? '+' : '-'}${tx.amount} at ${tx.merchant}',
      content: {
        'transactionId': tx.transactionId,
        'amount': tx.amount,
        'type': tx.type,
        'category': tx.category,
        'merchant': tx.merchant,
        'institution': tx.institution,
        'description': tx.description,
        'paymentMethod': tx.paymentMethod,
        'dedupeHash': tx.dedupeHash,
      },
      tags: ['shadow_vaf', 'finance', tx.category],
    );
  }

  Future<void> shadowTransactionEntity(FinanceTransaction tx) async {
    await _saveShadow(
      id: 'finance_tx_${tx.id}',
      category: BookCategory.finance,
      domain: MemoryDomain.finance,
      source: MemorySource.manual,
      provenance: 'manual',
      effectiveAt: DateTime.tryParse(tx.transactionDate) ?? DateTime.now(),
      confidence: 1.0,
      summary: '${tx.transactionType == 'income' ? '+' : '-'}${tx.amount} at ${tx.account}',
      content: tx.toJson(),
      tags: ['shadow_vaf', 'finance', tx.category],
    );
  }

  /// Shadows a timeline event into the VAF layer.
  Future<void> shadowTimelineEvent(TimelineEventData event) async {
    await _saveShadow(
      id: 'timeline_event_${event.id}',
      category: _mapTimelineTypeToCategory(event.type),
      domain: MemoryDomain.memories,
      source: MemorySource.imported,
      provenance: event.originProviderId ?? 'system',
      effectiveAt: event.startTime,
      confidence: event.confidenceScore ?? 1.0,
      summary: event.title,
      content: {
        'eventId': event.id,
        'title': event.title,
        'type': event.type,
        'location': event.location,
        'startTime': event.startTime.toIso8601String(),
        'endTime': event.endTime.toIso8601String(),
        'originResourceId': event.originResourceId,
      },
      tags: ['shadow_vaf', 'timeline', event.type],
    );
  }

  Future<void> shadowTimelineEntity(TimelineEvent event) async {
    await _saveShadow(
      id: 'timeline_event_${event.id}',
      category: _mapTimelineTypeToCategory(event.type.name),
      domain: MemoryDomain.memories,
      source: MemorySource.manual,
      provenance: event.originProviderId ?? 'manual',
      effectiveAt: event.startTime,
      confidence: event.confidenceScore ?? 1.0,
      summary: event.title,
      content: {
        'eventId': event.id,
        'title': event.title,
        'type': event.type.name,
        'location': event.location,
        'startTime': event.startTime.toIso8601String(),
        'endTime': event.endTime.toIso8601String(),
        'originResourceId': event.originResourceId,
      },
      tags: ['shadow_vaf', 'timeline', event.type.name],
    );
  }

  /// Shadows a health metric into the VAF layer.
  Future<void> shadowHealthMetric(HealthMetricData metric) async {
    await _saveShadow(
      id: 'health_metric_${metric.id}',
      category: BookCategory.health,
      domain: MemoryDomain.health,
      source: MemorySource.sensor,
      provenance: metric.source,
      effectiveAt: metric.startTime,
      confidence: 1.0,
      summary: '${metric.metricType.toUpperCase()}: ${metric.value} ${metric.unit}',
      content: {
        'metricId': metric.id,
        'metricType': metric.metricType,
        'value': metric.value,
        'unit': metric.unit,
        'startTime': metric.startTime.toIso8601String(),
        'endTime': metric.endTime?.toIso8601String(),
      },
      tags: ['shadow_vaf', 'health', metric.metricType],
    );
  }

  Future<void> shadowTransactionCompanion(TransactionTableCompanion tx) async {
    await _saveShadow(
      id: 'finance_tx_${tx.transactionId.value}',
      category: BookCategory.finance,
      domain: MemoryDomain.finance,
      source: MemorySource.imported,
      provenance: tx.originProviderId.value ?? tx.institution.value,
      effectiveAt: tx.transactionDate.value,
      confidence: tx.confidenceScore.value ?? 1.0,
      summary: '${tx.type.value == 'income' ? '+' : '-'}${tx.amount.value} at ${tx.merchant.value}',
      content: {
        'transactionId': tx.transactionId.value,
        'amount': tx.amount.value,
        'type': tx.type.value,
        'category': tx.category.value,
        'merchant': tx.merchant.value,
        'institution': tx.institution.value,
        'description': tx.description.value,
        'paymentMethod': tx.paymentMethod.value,
        'dedupeHash': tx.dedupeHash.value,
      },
      tags: ['shadow_vaf', 'finance', tx.category.value],
    );
  }

  Future<void> shadowTimelineCompanion(TimelineEventTableCompanion event) async {
    await _saveShadow(
      id: 'timeline_event_${event.id.value}',
      category: _mapTimelineTypeToCategory(event.type.value),
      domain: MemoryDomain.memories,
      source: MemorySource.imported,
      provenance: event.originProviderId.value ?? 'system',
      effectiveAt: event.startTime.value,
      confidence: event.confidenceScore.value ?? 1.0,
      summary: event.title.value,
      content: {
        'eventId': event.id.value,
        'title': event.title.value,
        'type': event.type.value,
        'location': event.location.value,
        'startTime': event.startTime.value.toIso8601String(),
        'endTime': event.endTime.value.toIso8601String(),
        'originResourceId': event.originResourceId.value,
      },
      tags: ['shadow_vaf', 'timeline', event.type.value],
    );
  }

  Future<void> shadowHealthCompanion(HealthMetricTableCompanion metric) async {
    await _saveShadow(
      id: 'health_metric_${metric.id.value}',
      category: BookCategory.health,
      domain: MemoryDomain.health,
      source: MemorySource.sensor,
      provenance: metric.source.value,
      effectiveAt: metric.startTime.value,
      confidence: 1.0,
      summary: '${metric.metricType.value.toUpperCase()}: ${metric.value.value} ${metric.unit.value}',
      content: {
        'metricId': metric.id.value,
        'metricType': metric.metricType.value,
        'value': metric.value.value,
        'unit': metric.unit.value,
        'startTime': metric.startTime.value.toIso8601String(),
        'endTime': metric.endTime.value?.toIso8601String(),
      },
      tags: ['shadow_vaf', 'health', metric.metricType.value],
    );
  }

  Future<void> shadowBodyMeasurementCompanion(BodyMeasurementTableCompanion m) async {
    await _saveShadow(
      id: 'body_measurement_${m.id.value}',
      category: BookCategory.health,
      domain: MemoryDomain.health,
      source: MemorySource.manual,
      provenance: 'manual',
      effectiveAt: m.measuredAt.value,
      confidence: 1.0,
      summary: 'Body Measurement: ${m.measurementType.value} = ${m.value.value} ${m.unit.value}',
      content: {
        'measurementType': m.measurementType.value,
        'value': m.value.value,
        'unit': m.unit.value,
        'measuredAt': m.measuredAt.value.toIso8601String(),
      },
      tags: ['shadow_vaf', 'health', 'body', m.measurementType.value],
    );
  }

  Future<void> shadowHealthTrackerCompanion(HealthTrackerTableCompanion t) async {
    await _saveShadow(
      id: 'health_tracker_${t.id.value}',
      category: BookCategory.health,
      domain: MemoryDomain.health,
      source: MemorySource.manual,
      provenance: 'manual',
      effectiveAt: t.timestamp.value,
      confidence: 1.0,
      summary: 'Logged ${t.trackerType.value}: ${t.value.value}',
      content: {
        'trackerType': t.trackerType.value,
        'value': t.value.value,
        'timestamp': t.timestamp.value.toIso8601String(),
        'notes': t.notes.value,
      },
      tags: ['shadow_vaf', 'health', 'tracker', t.trackerType.value],
    );
  }


  Future<void> _saveShadow({
    required String id,
    required BookCategory category,
    required MemoryDomain domain,
    required MemorySource source,
    required String provenance,
    required DateTime effectiveAt,
    required double confidence,
    required String summary,
    required Map<String, dynamic> content,
    required List<String> tags,
  }) async {
    await memoryEngine.save(KnightMemory.create(
      memoryId: id,
      category: category,
      domain: domain,
      source: source,
      provenance: provenance,
      content: content,
      summary: summary,
      effectiveAt: effectiveAt,
      confidence: confidence,
      tags: tags,
    ));
  }

  BookCategory _mapTimelineTypeToCategory(String type) {
    switch (type.toLowerCase()) {
      case 'transaction': return BookCategory.finance;
      case 'health_metric': return BookCategory.health;
      case 'visit': return BookCategory.history;
      case 'meeting': return BookCategory.social; // Communication -> Social
      case 'milestone': return BookCategory.career;
      case 'task': return BookCategory.ambitions; // Upcoming -> Ambitions
      default: return BookCategory.history;
    }
  }
}
