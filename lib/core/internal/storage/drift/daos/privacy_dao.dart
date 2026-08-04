import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/data_privacy_metadata.dart';

part 'privacy_dao.g.dart';

@DriftAccessor(tables: [DataPrivacyMetadataTable])
class PrivacyDao extends BaseDao<DataPrivacyMetadataTable, DataPrivacyMetadata>
    with _$PrivacyDaoMixin {
  PrivacyDao(super.db);

  Future<void> upsertPrivacy(DataPrivacyMetadataTableCompanion companion) {
    return into(dataPrivacyMetadataTable).insertOnConflictUpdate(companion);
  }
}
