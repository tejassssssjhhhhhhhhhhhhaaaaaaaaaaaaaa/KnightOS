import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for the manual Focus Mode override.
class FocusModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

final focusModeProvider = NotifierProvider<FocusModeNotifier, bool>(FocusModeNotifier.new);
