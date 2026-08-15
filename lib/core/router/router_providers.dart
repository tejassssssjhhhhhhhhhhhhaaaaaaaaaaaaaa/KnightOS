import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for the current router location.
class CurrentLocationNotifier extends Notifier<String> {
  @override
  String build() => '/';

  void setLocation(String location) {
    state = location;
  }
}

/// Provider for the current router location.
final currentLocationProvider = NotifierProvider<CurrentLocationNotifier, String>(CurrentLocationNotifier.new);

/// Provider for the current active module based on location.
final currentModuleProvider = Provider<String>((ref) {
  final location = ref.watch(currentLocationProvider);
  
  if (location.startsWith('/finance')) return 'finance';
  if (location.startsWith('/travel')) return 'travel';
  if (location.startsWith('/career')) return 'career';
  if (location.startsWith('/health')) return 'health';
  if (location.startsWith('/planner')) return 'planner';
  if (location.startsWith('/my-place')) return 'hub';
  if (location.startsWith('/settings')) return 'settings';
  if (location.startsWith('/profile')) return 'identity';
  
  return 'system';
});
