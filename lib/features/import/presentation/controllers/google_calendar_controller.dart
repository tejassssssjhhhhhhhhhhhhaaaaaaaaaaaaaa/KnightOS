import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/integration_providers.dart';
import '../../../../core/domain/connectors/i_connector.dart';

class GoogleCalendarState {
  const GoogleCalendarState({
    this.status = ConnectorStatus.registered,
    this.isSyncing = false,
    this.error,
    this.lastProcessed = 0,
  });

  final ConnectorStatus status;
  final bool isSyncing;
  final String? error;
  final int lastProcessed;

  GoogleCalendarState copyWith({
    ConnectorStatus? status,
    bool? isSyncing,
    String? error,
    int? lastProcessed,
  }) {
    return GoogleCalendarState(
      status: status ?? this.status,
      isSyncing: isSyncing ?? this.isSyncing,
      error: error,
      lastProcessed: lastProcessed ?? this.lastProcessed,
    );
  }
}

class GoogleCalendarNotifier extends Notifier<GoogleCalendarState> {
  @override
  GoogleCalendarState build() {
    final connector = ref.watch(googleCalendarConnectorProvider);
    
    // Listen to status changes
    connector.onStatusChanged.listen((status) {
      state = state.copyWith(status: status);
    });

    return GoogleCalendarState(status: connector.status);
  }

  Future<void> authorize() async {
    final connector = ref.read(googleCalendarConnectorProvider);
    final result = await connector.authorize();
    if (result.status == ConnectorStatus.failed) {
      state = state.copyWith(error: result.error);
    }
  }

  Future<void> sync({bool fullSync = false}) async {
    state = state.copyWith(isSyncing: true, error: null);
    final connector = ref.read(googleCalendarConnectorProvider);
    
    final result = await connector.sync(fullSync: fullSync);
    
    if (result.status == ConnectorStatus.completed) {
      state = state.copyWith(isSyncing: false, lastProcessed: result.data ?? 0);
    } else {
      state = state.copyWith(isSyncing: false, error: result.error);
    }
  }
}

final googleCalendarControllerProvider = NotifierProvider<GoogleCalendarNotifier, GoogleCalendarState>(
  GoogleCalendarNotifier.new,
);
