import 'package:drift/drift.dart';
import '../knight_table.dart';

/// The central storage for all KnightOS intelligence.
/// Updated for Knowledge Base v1.0 integrity.
@DataClassName('MemoryTableData')
class MemoryTable extends KnightTable {
  @override
  String get tableName => 'memories';

  /// Logical identifier for the fact chain (Single Source of Truth key).
  TextColumn get memoryId => text()();

  /// Primary category (11 Books).
  IntColumn get categoryId => integer()();

  /// Specific domain (30 Domains).
  IntColumn get domainId => integer()();

  /// identity or event.
  TextColumn get type => text()();

  /// JSON payload conforming to domain schema.
  TextColumn get content => text()();

  /// Optional short description.
  TextColumn get summary => text().nullable()();

  /// 0.0 to 1.0.
  RealColumn get importance => real().withDefault(const Constant(0.5))();

  /// 0.0 to 1.0 (Calculated or stated).
  RealColumn get confidence => real().withDefault(const Constant(1.0))();

  /// manual, imported, ai_generated, sensor.
  TextColumn get source => text()();

  /// Origin details.
  TextColumn get provenance => text()();

  /// Incremental version number.
  @override
  IntColumn get version => integer().withDefault(const Constant(1))();

  /// creation, evolution, etc.
  TextColumn get changeType => text()();

  /// Logical justification for the version.
  TextColumn get reasoning => text().nullable()();

  /// JSON map of fields that changed.
  TextColumn get delta => text().nullable()();

  /// Timeline timestamp.
  DateTimeColumn get effectiveAt => dateTime()();

  /// Storage timestamp.
  DateTimeColumn get recordedAt => dateTime()();

  /// Last modification timestamp.
  @override
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// When the user last confirmed this memory.
  DateTimeColumn get lastVerifiedAt => dateTime().nullable()();

  /// JSON list of verification events.
  TextColumn get verificationHistory => text().nullable()();

  /// Foreign key to previous version within the chain.
  TextColumn get prevVersionId =>
      text().nullable().references(MemoryTable, #id)();

  /// Current state flag for optimized queries.
  BoolColumn get isLatest => boolean().withDefault(const Constant(true))();

  /// Whether the owner has explicitly verified this information.
  BoolColumn get verified => boolean().withDefault(const Constant(false))();

  /// Link back to the specific inquiry in the Question Bank.
  TextColumn get questionId => text().nullable()();

  /// Lifecycle state: observed, inferred, userConfirmed, userCorrected, deprecated.
  TextColumn get knowledgeState =>
      text().withDefault(const Constant('observed'))();

  /// Human-readable reasoning for inferred knowledge.
  TextColumn get explanation => text().nullable()();

  /// Comma-separated or JSON list of labels.
  TextColumn get tags => text().withDefault(const Constant(''))();

  /// Reserved for future vector support (JSON string of doubles).
  TextColumn get embedding => text().nullable()();
}
