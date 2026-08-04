import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Registry for normalized real-world identities.
@DataClassName('CanonicalIdentity')
class CanonicalIdentityTable extends KnightTable {
  @override
  String get tableName => 'canonical_identities';

  /// Primary normalized name (e.g. AMAZON).
  TextColumn get canonicalName => text().unique()();

  /// e.g. merchant, airline, restaurant, bank.
  TextColumn get category => text()();

  /// High-level industry.
  TextColumn get industry => text().nullable()();

  /// Primary logo or icon URI.
  TextColumn get logoUri => text().nullable()();

  /// Custom user tags for this identity.
  TextColumn get userTags => text().nullable()();
}

/// Mapping of variations to canonical identities.
@DataClassName('IdentityAlias')
class IdentityAliasTable extends KnightTable {
  @override
  String get tableName => 'identity_aliases';

  /// The raw string found in data (e.g. "Amazon India").
  TextColumn get rawName => text().unique()();

  /// Reference to the canonical identity.
  TextColumn get canonicalId => text().references(CanonicalIdentityTable, #id)();
}
