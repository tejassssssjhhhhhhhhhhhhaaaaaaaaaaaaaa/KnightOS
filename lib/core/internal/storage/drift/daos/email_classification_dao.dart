import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/email_classifications.dart';

part 'email_classification_dao.g.dart';

@DriftAccessor(tables: [EmailClassificationTable])
class EmailClassificationDao extends BaseDao<EmailClassificationTable, EmailClassification>
    with _$EmailClassificationDaoMixin {
  EmailClassificationDao(super.db);

  Future<void> upsertClassification(EmailClassificationTableCompanion companion) {
    return into(emailClassificationTable).insertOnConflictUpdate(companion);
  }

  Future<EmailClassification?> getByMessageId(String id) {
    return (select(emailClassificationTable)..where((t) => t.messageId.equals(id))).getSingleOrNull();
  }
}
