import 'package:uuid/uuid.dart';

/// Universal metadata and identifier for every persisted object in Knight OS.
/// This is a pure platform contract. No implementation details (like Drift) allowed here.
abstract class KnightEntity {
  KnightEntity({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.version = 1,
    this.isDeleted = false,
    this.deletedAt,
    this.syncStatus = 'pending',
    this.deviceId,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Unique UUID for the record.
  final String id;

  /// ISO 8601 timestamp of creation.
  final DateTime createdAt;

  /// ISO 8601 timestamp of last update.
  final DateTime updatedAt;

  /// Incremental version for optimistic concurrency and history.
  final int version;

  /// Soft delete flag.
  final bool isDeleted;

  /// Timestamp of soft deletion.
  final DateTime? deletedAt;

  /// Status for cloud synchronization: 'pending', 'synced', 'conflict'.
  final String syncStatus;

  /// Identifier for the device that created this record.
  final String? deviceId;

  /// Converts the entity to a JSON map.
  Map<String, dynamic> toJson();
}
