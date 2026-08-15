import 'dart:async';

class StreamUtils {
  static Stream<T> combineLatest3<A, B, C, T>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    T Function(A, B, C) combiner,
  ) {
    final controller = StreamController<T>.broadcast();
    A? lastA;
    B? lastB;
    C? lastC;
    bool hasA = false;
    bool hasB = false;
    bool hasC = false;

    void update() {
      if (hasA && hasB && hasC) {
        controller.add(combiner(lastA as A, lastB as B, lastC as C));
      }
    }

    final subA = streamA.listen((val) { lastA = val; hasA = true; update(); });
    final subB = streamB.listen((val) { lastB = val; hasB = true; update(); });
    final subC = streamC.listen((val) { lastC = val; hasC = true; update(); });

    controller.onCancel = () {
      subA.cancel();
      subB.cancel();
      subC.cancel();
    };

    return controller.stream;
  }
}
