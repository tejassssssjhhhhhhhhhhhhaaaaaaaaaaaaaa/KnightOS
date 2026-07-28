import 'package:drift/drift.dart';
import 'knight_database.dart';

/// Flagship Base DAO for all Knight OS feature modules.
/// Provides universal handling of [KnightTable] metadata and soft-delete filtering.
abstract class BaseDao<TTable extends Table, TData extends DataClass>
    extends DatabaseAccessor<KnightDatabase> {
  BaseDao(super.attachedDatabase);

  /// Filters out records marked as [isDeleted].
  /// Note: [table] must implement [KnightTable] properties.
  SimpleSelectStatement<TTable, TData> selectActive(
    TableInfo<TTable, TData> table,
  ) {
    return select(table)
      ..where((row) => (row as dynamic).isDeleted.equals(false));
  }

  /// Transactional Upsert with metadata management.
  Future<void> upsert(
    TableInfo<TTable, TData> table,
    Insertable<TData> companion,
  ) async {
    await into(table).insertOnConflictUpdate(companion);
  }

  /// Bulk Upsert within a single transaction.
  Future<void> upsertAll(
    TableInfo<TTable, TData> table,
    List<Insertable<TData>> companions,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(table, companions);
    });
  }
}
