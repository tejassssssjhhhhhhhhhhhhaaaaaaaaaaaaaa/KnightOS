import '../storage/drift/knight_database.dart';
import 'knight_logger.dart';

class DbAuditor {
  static Future<void> logCounts(KnightDatabase db) async {
    final gmail = (await db.gmailMessageDao.select(db.gmailMessageTable).get()).length;
    final calendar = (await (db.select(db.googleResourceTable)..where((t) => t.resourceType.equals('calendar'))).get()).length;
    final drive = (await (db.select(db.googleResourceTable)..where((t) => t.resourceType.equals('drive'))).get()).length;
    final contacts = (await (db.select(db.googleResourceTable)..where((t) => t.resourceType.equals('contact'))).get()).length;
    
    KnightLogger.info('[AUDIT] DB Counts - Gmail: $gmail, Calendar: $calendar, Drive: $drive, Contacts: $contacts');
  }
}
