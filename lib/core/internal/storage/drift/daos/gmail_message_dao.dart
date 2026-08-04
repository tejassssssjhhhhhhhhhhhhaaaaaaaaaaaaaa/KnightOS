import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/gmail_messages.dart';

part 'gmail_message_dao.g.dart';

@DriftAccessor(tables: [GmailMessageTable])
class GmailMessageDao extends BaseDao<GmailMessageTable, GmailMessageData>
    with _$GmailMessageDaoMixin {
  GmailMessageDao(super.db);

  Future<void> upsertMessage(GmailMessageTableCompanion companion) {
    return into(gmailMessageTable).insertOnConflictUpdate(companion);
  }

  Future<GmailMessageData?> getByMessageId(String id) {
    return (select(gmailMessageTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
