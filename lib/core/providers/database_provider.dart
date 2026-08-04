import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../internal/storage/drift/knight_database.dart';

/// Flagship Database provider.
final knightDatabaseProvider = Provider<KnightDatabase>((ref) {
  final db = KnightDatabase();
  ref.onDispose(() => db.close());
  return db;
});
