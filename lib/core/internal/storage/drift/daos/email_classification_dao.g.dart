// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_classification_dao.dart';

// ignore_for_file: type=lint
mixin _$EmailClassificationDaoMixin on DatabaseAccessor<KnightDatabase> {
  $GmailMessageTableTable get gmailMessageTable =>
      attachedDatabase.gmailMessageTable;
  $EmailClassificationTableTable get emailClassificationTable =>
      attachedDatabase.emailClassificationTable;
  EmailClassificationDaoManager get managers =>
      EmailClassificationDaoManager(this);
}

class EmailClassificationDaoManager {
  final _$EmailClassificationDaoMixin _db;
  EmailClassificationDaoManager(this._db);
  $$GmailMessageTableTableTableManager get gmailMessageTable =>
      $$GmailMessageTableTableTableManager(
        _db.attachedDatabase,
        _db.gmailMessageTable,
      );
  $$EmailClassificationTableTableTableManager get emailClassificationTable =>
      $$EmailClassificationTableTableTableManager(
        _db.attachedDatabase,
        _db.emailClassificationTable,
      );
}
