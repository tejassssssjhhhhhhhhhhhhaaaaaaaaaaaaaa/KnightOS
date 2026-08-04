import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/security_metadata.dart';

part 'security_dao.g.dart';

@DriftAccessor(tables: [SecurityMetadataTable])
class SecurityDao extends BaseDao<SecurityMetadataTable, SecurityMetadata>
    with _$SecurityDaoMixin {
  SecurityDao(super.db);

  Future<String?> getPolicy(String key) async {
    final record = await (select(securityMetadataTable)..where((t) => t.key.equals(key))).getSingleOrNull();
    return record?.value;
  }
}
