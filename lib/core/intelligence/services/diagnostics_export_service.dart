import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';
import '../../services/google_auth_service.dart';
import 'system_health_service.dart';

class DiagnosticsExportService {
  DiagnosticsExportService({required this.ref});
  final Ref ref;

  Future<String> generateMarkdownReport() async {
    final db = ref.read(knightDatabaseProvider);
    final health = await ref.read(systemHealthServiceProvider).runFullDiagnostic();
    final auth = GoogleAuthService.instance;

    final emails = await db.customSelect('SELECT COUNT(*) as c FROM gmail_messages').getSingle();
    final entities = await db.customSelect('SELECT COUNT(*) as c FROM extracted_entities').getSingle();

    final buffer = StringBuffer();
    buffer.writeln('# KnightOS Diagnostics Report');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln();
    buffer.writeln('## System Information');
    buffer.writeln('- Application Version: 5.0.0');
    buffer.writeln('- Database Version: 13');
    buffer.writeln('- Health Score: ${health.score}%');
    buffer.writeln();
    buffer.writeln('## Connectivity');
    buffer.writeln('- Google Account: ${auth.currentUser?.email ?? "Not Linked"}');
    buffer.writeln();
    buffer.writeln('## Database Statistics');
    buffer.writeln('- Gmail Messages: ${emails.read<int>("c")}');
    buffer.writeln('- Extracted Entities: ${entities.read<int>("c")}');
    
    return buffer.toString();
  }

  Future<Map<String, dynamic>> generateJsonPackage() async {
     final health = await ref.read(systemHealthServiceProvider).runFullDiagnostic();
     
     return {
       'timestamp': DateTime.now().toIso8601String(),
       'health': {
         'score': health.score,
         'subsystems': health.subsystems.map((s) => {
           'name': s.name,
           'status': s.status.name,
           'last_error': s.lastError,
         }).toList(),
       },
       'stats': {
         'db_version': 13,
       }
     };
  }
}

final diagnosticsExportServiceProvider = Provider<DiagnosticsExportService>((ref) => DiagnosticsExportService(ref: ref));
