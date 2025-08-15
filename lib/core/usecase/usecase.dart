import '../error/failure.dart';

abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

class NoParams {
  const NoParams();
}

class Result<T> {
  final T? data;
  final Failure? failure;

  const Result._({this.data, this.failure});

  factory Result.success(T data) => Result._(data: data);

  factory Result.failure(Failure failure) => Result._(failure: failure);

  bool get isSuccess => failure == null;
}
