import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:googleapis/people/v1.dart' as people;
import 'package:http/http.dart' as http;
import 'sync_orchestrator.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';

class ContactsSyncOrchestrator extends SyncOrchestrator {
  ContactsSyncOrchestrator({
    required super.db,
    required this.authService,
  }) : super(providerId: 'google_contacts_api');

  final GoogleAuthService authService;

  @override
  Future<void> executeSync() async {
    final stopwatch = Stopwatch()..start();
    await updateCursor('sync_status', 'in_progress');

    try {
      final headers = await authService.getAuthHeaders();
      final client = _AuthenticatedClient(headers, http.Client());
      final peopleApi = people.PeopleServiceApi(client);

      await _runFullSync(peopleApi);

      await updateCursor('last_sync_time', DateTime.now().toIso8601String());
      await updateCursor('sync_status', 'idle');
      KnightLogger.info('[CONTACTS] Sync completed in ${stopwatch.elapsed.inSeconds}s');
    } catch (e) {
      await updateCursor('sync_status', 'failed');
      await updateCursor('last_sync_error', e.toString());
      rethrow;
    }
  }

  Future<void> _runFullSync(people.PeopleServiceApi api) async {
    String? nextPageToken;
    int processed = 0;

    do {
      final response = await api.people.connections.list(
        'people/me',
        personFields: 'names,emailAddresses,phoneNumbers,photos,organizations',
        pageToken: nextPageToken,
        pageSize: 100,
      );

      if (response.connections != null) {
        for (final person in response.connections!) {
          await _processPerson(person);
          processed++;
        }
      }

      nextPageToken = response.nextPageToken;
    } while (nextPageToken != null);

    KnightLogger.info('[CONTACTS] Processed $processed contacts');
  }

  Future<void> _processPerson(people.Person person) async {
    final name = person.names?.first.displayName ?? 'Unknown';
    final email = person.emailAddresses?.first.value ?? '';
    if (person.resourceName == null) return;

    final accountEmail = authService.currentUser?.email ?? 'unknown';

    await db.googleResourceDao.upsertResource(GoogleResourceTableCompanion.insert(
      id: person.resourceName!,
      resourceType: 'contact',
      title: name,
      resourceDate: DateTime.now(),
      metadata: Value(jsonEncode({
        'email': email,
        'phone': person.phoneNumbers?.first.value,
        'org': person.organizations?.first.name,
      })),
      originAccount: accountEmail,
      rawMetadata: Value(jsonEncode(person.toJson())),
      syncStatus: const Value('synced'),
    ));
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
