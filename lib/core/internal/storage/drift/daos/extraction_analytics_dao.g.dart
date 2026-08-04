// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extraction_analytics_dao.dart';

// ignore_for_file: type=lint
mixin _$ExtractionAnalyticsDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ExtractionAnalyticsTableTable get extractionAnalyticsTable =>
      attachedDatabase.extractionAnalyticsTable;
  ExtractionAnalyticsDaoManager get managers =>
      ExtractionAnalyticsDaoManager(this);
}

class ExtractionAnalyticsDaoManager {
  final _$ExtractionAnalyticsDaoMixin _db;
  ExtractionAnalyticsDaoManager(this._db);
  $$ExtractionAnalyticsTableTableTableManager get extractionAnalyticsTable =>
      $$ExtractionAnalyticsTableTableTableManager(
        _db.attachedDatabase,
        _db.extractionAnalyticsTable,
      );
}
