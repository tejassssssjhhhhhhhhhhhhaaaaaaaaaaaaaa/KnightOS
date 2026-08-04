import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/extraction_analytics.dart';

part 'extraction_analytics_dao.g.dart';

@DriftAccessor(tables: [ExtractionAnalyticsTable])
class ExtractionAnalyticsDao extends BaseDao<ExtractionAnalyticsTable, ExtractionAnalytic>
    with _$ExtractionAnalyticsDaoMixin {
  ExtractionAnalyticsDao(super.db);

  Future<void> logAnalytics(ExtractionAnalyticsTableCompanion companion) {
    return into(extractionAnalyticsTable).insert(companion);
  }
}
