import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_events.dart';

void main() {
  late IntelligenceBus bus;

  setUp(() {
    bus = IntelligenceBus();
  });

  tearDown(() {
    bus.dispose();
  });

  test('IntelligenceBus should emit and receive events', () async {
    final event = ContextChangedEvent(
      timestamp: DateTime.now(),
      contextLabel: 'home',
    );

    final expectation = expectLater(bus.events, emits(event));

    bus.emit(event);

    await expectation;
  });

  test(
    'IntelligenceBus should handle multiple listeners (broadcast)',
    () async {
      int callCount1 = 0;
      int callCount2 = 0;

      bus.events.listen((_) => callCount1++);
      bus.events.listen((_) => callCount2++);

      bus.emit(
        ContextChangedEvent(timestamp: DateTime.now(), contextLabel: 'home'),
      );

      // Give it a microtask to propagate
      await Future.delayed(Duration.zero);

      expect(callCount1, 1);
      expect(callCount2, 1);
    },
  );
}
