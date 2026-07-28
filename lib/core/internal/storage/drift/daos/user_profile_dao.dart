import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../base_dao.dart';
import '../tables/user_profiles.dart';

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfileTable])
class UserProfileDao extends BaseDao<UserProfileTable, UserProfileTableData>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Future<UserProfileTableData?> getProfile() {
    return (select(userProfileTable)..limit(1)).getSingleOrNull();
  }

  Future<UserProfileTableData?> getById(String id) {
    return (select(
      userProfileTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> saveProfile(UserProfileTableCompanion profile) {
    return upsert(userProfileTable, profile);
  }

  Future<void> clearProfile() {
    return delete(userProfileTable).go();
  }
}
