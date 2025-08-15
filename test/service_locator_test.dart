import 'package:flutter_test/flutter_test.dart';
import 'package:jello_mark/di/service_locator.dart';

class A {
  final int v;
  A(this.v);
}

class B {
  final int v;
  B(this.v);
}

void main() {
  test('registerSingleton and get returns instance', () {
    sl.registerSingleton<A>(A(1));
    final a = sl.get<A>();
    expect(a.v, 1);
  });

  test('registerFactory and get returns new instance each time', () {
    var count = 0;
    sl.registerFactory<B>(() => B(++count));
    final b1 = sl.get<B>();
    final b2 = sl.get<B>();
    expect(b1.v, 1);
    expect(b2.v, 2);
  });

  test('get throws when type not found', () {
    expect(() => sl.get<String>(), throwsA(isA<StateError>()));
  });
}
