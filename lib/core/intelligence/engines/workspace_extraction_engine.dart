import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../domain/workspace_models.dart';

class WorkspaceExtractionEngine {
  WorkspaceExtractionEngine();

  /// Converts a raw Gmail message into a KnightMemory unit.
  KnightMemory extractEmail(Map<String, dynamic> msg, {String? accountEmail}) {
    final id = msg['id'] as String;
    final threadId = msg['threadId'] as String? ?? id;
    final subject = msg['subject'] as String? ?? 'No Subject';
    final sender = msg['sender'] as String? ?? 'Unknown';
    final snippet = msg['snippet'] as String? ?? '';
    final date = msg['date'] as DateTime? ?? DateTime.now();
    final labels = msg['labels'] is List ? List<String>.from(msg['labels'] as List) : <String>[];
    final isUnread = msg['isUnread'] as bool? ?? true;

    final workspaceEmail = WorkspaceEmail(
      id: id,
      threadId: threadId,
      subject: subject,
      sender: sender,
      snippet: snippet,
      date: date,
      labels: labels,
      isUnread: isUnread,
      importance: _determineImportance(subject, snippet),
      metadata: {
        'originAccount': accountEmail,
      },
    );

    return KnightMemory.create(
      memoryId: 'workspace-email-$id',
      category: BookCategory.social,
      domain: MemoryDomain.knowledge,
      source: MemorySource.imported,
      provenance: 'gmail_api',
      effectiveAt: date,
      confidence: 1.0,
      importance: workspaceEmail.importance == 'critical' ? 1.0 : (workspaceEmail.importance == 'high' ? 0.8 : 0.5),
      content: workspaceEmail.toJson(),
      summary: 'Email: $subject',
      tags: ['workspace', 'gmail', ...labels],
    );
  }

  /// Converts a raw Google Calendar event into a KnightMemory unit.
  KnightMemory extractCalendarEvent(Map<String, dynamic> event) {
    final id = event['id'] as String;
    final title = event['summary'] as String? ?? 'Untitled Event';
    final description = event['description'] as String? ?? '';
    final startTime = event['start'] is DateTime ? event['start'] as DateTime : DateTime.now();
    final endTime = event['end'] is DateTime ? event['end'] as DateTime : startTime.add(const Duration(hours: 1));

    final workspaceEvent = WorkspaceCalendarEvent(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: event['location'] as String?,
      status: event['status'] as String? ?? 'confirmed',
    );

    return KnightMemory.create(
      memoryId: 'workspace-cal-$id',
      category: BookCategory.ambitions,
      domain: MemoryDomain.dailyRoutine,
      source: MemorySource.imported,
      provenance: 'google_calendar_api',
      effectiveAt: startTime,
      confidence: 1.0,
      importance: 0.7,
      content: workspaceEvent.toJson(),
      summary: 'Calendar: $title',
      tags: ['workspace', 'calendar'],
    );
  }

  /// Converts Google Drive file metadata into a KnightMemory unit.
  KnightMemory extractDriveFile(Map<String, dynamic> file) {
    final id = file['id'] as String;
    final name = file['name'] as String? ?? 'Untitled File';
    final modifiedTime = file['modifiedTime'] is DateTime ? file['modifiedTime'] as DateTime : DateTime.now();

    final workspaceFile = WorkspaceDriveFile(
      id: id,
      name: name,
      mimeType: file['mimeType'] as String? ?? 'application/octet-stream',
      modifiedTime: modifiedTime,
      webViewLink: file['webViewLink'] as String?,
      sizeBytes: int.tryParse(file['size']?.toString() ?? ''),
    );

    return KnightMemory.create(
      memoryId: 'workspace-drive-$id',
      category: BookCategory.skills,
      domain: MemoryDomain.documents,
      source: MemorySource.imported,
      provenance: 'google_drive_api',
      effectiveAt: modifiedTime,
      confidence: 1.0,
      importance: 0.5,
      content: workspaceFile.toJson(),
      summary: 'Drive File: $name',
      tags: ['workspace', 'drive'],
    );
  }

  String _determineImportance(String subject, String snippet) {
    final text = '$subject $snippet'.toLowerCase();
    if (text.contains('urgent') || text.contains('action required') || text.contains('asap')) {
      return 'critical';
    }
    if (text.contains('important') || text.contains('priority')) {
      return 'high';
    }
    return 'normal';
  }
}
