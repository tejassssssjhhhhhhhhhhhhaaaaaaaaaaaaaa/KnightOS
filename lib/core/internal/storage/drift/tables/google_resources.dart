import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Stores raw metadata for various Google resources (Calendar, Drive, Contacts, Tasks).
@DataClassName('GoogleResourceData')
class GoogleResourceTable extends KnightTable {
  @override
  String get tableName => 'google_resources';

  @override
  TextColumn get id => text()(); // resourceId

  /// 'calendar', 'drive', 'contact', 'task', 'photo', 'location'.
  TextColumn get resourceType => text()();

  TextColumn get title => text()();
  
  /// Primary timestamp for the resource (start time, modified time, etc.).
  DateTimeColumn get resourceDate => dateTime()();

  /// JSON metadata specific to the resource type.
  TextColumn get metadata => text().nullable()();

  TextColumn get originAccount => text()();
  
  /// JSON blob of raw API response.
  TextColumn get rawMetadata => text().nullable()();
  
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
}
