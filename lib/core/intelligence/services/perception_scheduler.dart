import 'dart:async';
import 'world_service.dart';

/// Manages background world perception cycles.
class PerceptionScheduler {
  PerceptionScheduler({required this.worldService});

  final WorldService worldService;
  Timer? _timer;

  /// Starts the autonomous perception loop.
  void start({Duration interval = const Duration(minutes: 15)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => worldService.syncWorld());
  }

  /// Stops the loop.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isActive => _timer != null;
}
