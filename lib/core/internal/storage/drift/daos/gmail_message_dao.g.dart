// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gmail_message_dao.dart';

// ignore_for_file: type=lint
mixin _$GmailMessageDaoMixin on DatabaseAccessor<KnightDatabase> {
  $GmailMessageTableTable get gmailMessageTable =>
      attachedDatabase.gmailMessageTable;
  GmailMessageDaoManager get managers => GmailMessageDaoManager(this);
}

class GmailMessageDaoManager {
  final _$GmailMessageDaoMixin _db;
  GmailMessageDaoManager(this._db);
  $$GmailMessageTableTableTableManager get gmailMessageTable =>
      $$GmailMessageTableTableTableManager(
        _db.attachedDatabase,
        _db.gmailMessageTable,
      );
}
