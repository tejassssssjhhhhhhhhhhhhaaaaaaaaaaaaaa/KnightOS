import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/time_period.dart';

final welcomeControllerProvider =
    NotifierProvider<WelcomeController, TimePeriod>(WelcomeController.new);

class WelcomeController extends Notifier<TimePeriod> {
  Timer? _timer;

  @override
  TimePeriod build() {
    _timer = Timer.periodic(const Duration(minutes: 15), (_) => _updateTime());
    return TimePeriod.fromHour(DateTime.now().hour);
  }

  void _updateTime() {
    final newPeriod = TimePeriod.fromHour(DateTime.now().hour);
    if (newPeriod != state) {
      state = newPeriod;
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
