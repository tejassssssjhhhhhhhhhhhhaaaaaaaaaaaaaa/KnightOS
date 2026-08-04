import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Stores arbitrary synchronization state (cursors, historyIds, tokens) per provider.
@DataClassName('ProviderSyncMetadata')
class ProviderSyncMetadataTable extends KnightTable {
  @override
  String get tableName => 'provider_sync_metadata';

  /// Unique ID for the provider (e.g., 'gmail_api', 'health_connect').
  TextColumn get providerId => text()();

  /// State key (e.g., 'last_history_id', 'next_page_token').
  TextColumn get stateKey => text()();

  /// Serialized state value.
  TextColumn get stateValue => text()();

  /// When this specific piece of state was last updated.
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {providerId, stateKey};
}
