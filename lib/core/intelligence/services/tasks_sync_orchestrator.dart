import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;
import 'package:http/http.dart' as http;
import 'sync_orchestrator.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';

class TasksSyncOrchestrator extends SyncOrchestrator {
  TasksSyncOrchestrator({
    required super.db,
    required this.authService,
  }) : super(providerId: 'google_tasks_api');

  final GoogleAuthService authService;

  @override
  Future<void> executeSync() async {
    final stopwatch = Stopwatch()..start();
    await updateCursor('sync_status', 'in_progress');

    try {
      final headers = await authService.getAuthHeaders();
      final client = _AuthenticatedClient(headers, http.Client());
      final tasksApi = tasks.TasksApi(client);

      await _runFullSync(tasksApi);

      await updateCursor('last_sync_time', DateTime.now().toIso8601String());
      await updateCursor('sync_status', 'idle');
      KnightLogger.info('[TASKS] Sync completed in ${stopwatch.elapsed.inSeconds}s');
    } catch (e) {
      await updateCursor('sync_status', 'failed');
      await updateCursor('last_sync_error', e.toString());
      rethrow;
    }
  }

  Future<void> _runFullSync(tasks.TasksApi api) async {
    final taskLists = await api.tasklists.list();
    int processed = 0;

    for (final list in taskLists.items ?? []) {
      if (list.id == null) continue;
      
      String? nextPageToken;
      do {
        final tasksResponse = await api.tasks.list(list.id!, pageToken: nextPageToken);
        if (tasksResponse.items != null) {
          fetchedCount += tasksResponse.items!.length;
          for (final task in tasksResponse.items!) {
            await _processTask(task, list.title ?? 'Default');
            processed++;
          }
        }
        nextPageToken = tasksResponse.nextPageToken;
      } while (nextPageToken != null);
    }

    KnightLogger.info('[TASKS] Processed $processed tasks');
  }

  Future<void> _processTask(tasks.Task task, String listTitle) async {
    if (task.id == null) {
      skippedCount++;
      return;
    }

    final accountEmail = authService.currentUser?.email ?? 'unknown';

    try {
      await db.googleResourceDao.upsertResource(GoogleResourceTableCompanion.insert(
        id: task.id!,
        resourceType: 'task',
        title: task.title ?? 'Untitled Task',
        resourceDate: task.updated != null ? DateTime.parse(task.updated!) : DateTime.now(),
        metadata: Value(jsonEncode({
          'list': listTitle,
          'notes': task.notes,
          'due': task.due,
          'status': task.status,
        })),
        originAccount: accountEmail,
        rawMetadata: Value(jsonEncode(task.toJson())),
        syncStatus: const Value('synced'),
      ));
      
      // Link to Timeline if it has a due date
      if (task.due != null) {
        final dueDate = DateTime.parse(task.due!);
        await db.timelineDao.insertEvents([
          TimelineEventTableCompanion.insert(
            id: 'task-${task.id}',
            title: '[TASK] ${task.title}',
            startTime: dueDate,
            endTime: dueDate,
            type: 'task',
            metadata: Value(task.notes ?? ''),
            originProviderId: const Value('google_tasks_api'),
            originResourceId: Value(task.id),
          )
        ]);
      }
      createdCount++;
    } catch (e) {
      failedCount++;
    }
  }
}

class _AuthenticatedClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner;

  _AuthenticatedClient(this._headers, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
