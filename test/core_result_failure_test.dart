import 'package:flutter_test/flutter_test.dart';
import 'package:jello_mark/core/error/failure.dart';
import 'package:jello_mark/core/usecase/usecase.dart';

void main() {
  test('Result success and isSuccess', () {
    final r = Result.success(10);
    expect(r.isSuccess, true);
    expect(r.data, 10);
    expect(r.failure, null);
  });

  test('Result failure and isSuccess false', () {
    final f = Failure('x');
    final r = Result.failure(f);
    expect(r.isSuccess, false);
    expect(r.data, null);
    expect(r.failure, f);
    expect(f.toString().contains('Failure'), true);
  });
}
