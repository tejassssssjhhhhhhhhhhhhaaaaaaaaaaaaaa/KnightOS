import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';

void main() {
  test('Fresh v10 database has all infrastructure tables', () async {
    final db = KnightDatabase.forTesting(NativeDatabase.memory());
    
    // Trigger creation
    await db.executor.ensureOpen(db);
    
    // 1. Verify New Tables
    final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE type='table'").get();
    final tableNames = tables.map((row) => row.read<String>('name')).toList();
    
    expect(tableNames, contains('provider_sync_metadata'));
    expect(tableNames, contains('sync_task_queue'));
    expect(tableNames, contains('reminders'));
    expect(tableNames, contains('device_registry'));
    expect(tableNames, contains('parser_registry'));
    expect(tableNames, contains('security_metadata'));

    // 2. Verify Origin Columns in Transactions
    final txColumns = await db.customSelect("PRAGMA table_info(transactions)").get();
    final txColNames = txColumns.map((row) => row.read<String>('name')).toList();
    
    expect(txColNames, contains('origin_provider_id'));
    expect(txColNames, contains('confidence_score'));
    expect(txColNames, contains('verification_state'));

    await db.close();
  });
}
