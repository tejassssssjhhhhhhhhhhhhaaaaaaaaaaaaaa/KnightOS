import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import 'gmail_audit_engine.dart';

final financeAuditProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  final engine = GmailAuditEngine(db: db);
  return engine.generateAuditReport();
});
