import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/tasks/v1.dart';
import 'google_auth_service.dart';

/// Service for managing connectivity to various Google Workspace APIs.
class GoogleApiConnectivityService {
  GoogleApiConnectivityService._({GoogleAuthService? authService})
      : _authService = authService ?? GoogleAuthService.instance;

  static final GoogleApiConnectivityService instance =
      GoogleApiConnectivityService._();

  final GoogleAuthService _authService;

  Future<GmailApi> getGmailApi() async {
    final client = await _authService.getAuthenticatedClient();
    return GmailApi(client);
  }

  Future<CalendarApi> getCalendarApi() async {
    final client = await _authService.getAuthenticatedClient();
    return CalendarApi(client);
  }

  Future<DriveApi> getDriveApi() async {
    final client = await _authService.getAuthenticatedClient();
    return DriveApi(client);
  }

  Future<TasksApi> getTasksApi() async {
    final client = await _authService.getAuthenticatedClient();
    return TasksApi(client);
  }

  Future<bool> isConnected() async {
    return _authService.currentUser != null;
  }
}
