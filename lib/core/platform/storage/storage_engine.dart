import 'knight_entity.dart';

/// Abstract interface for local database engines.
/// Evolution of the foundation to support Reactivity and Platform-level concerns.
abstract class StorageEngine {
  /// Initializes the storage engine (lazy or immediate).
  Future<void> initialize();

  /// Closes the storage engine and releases resources.
  Future<void> dispose();

  /// Reactive: Watches a single entity by its UUID.
  Stream<T?> watch<T extends KnightEntity>(String id);

  /// Reactive: Watches all records of a specific type.
  Stream<List<T>> watchAll<T extends KnightEntity>();

  /// Persists a single entity (Insert or Update).
  Future<void> upsert<T extends KnightEntity>(T entity);

  /// Persists multiple entities in a single atomic transaction.
  Future<void> batchUpsert<T extends KnightEntity>(List<T> entities);

  /// Retrieves an entity by its UUID (One-time fetch).
  Future<T?> get<T extends KnightEntity>(String id);

  /// Permanent delete (Use with caution).
  /// Soft delete is typically handled by [upsert] with isDeleted = true.
  Future<void> hardDelete<T extends KnightEntity>(String id);

  /// Clears all records of a specific type.
  Future<void> clearAll<T extends KnightEntity>();

  /// Performs a transactional block across multiple operations.
  Future<R> transaction<R>(Future<R> Function() action);
}
