import '../../core/error/failure.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource local;

  CounterRepositoryImpl(this.local);

  @override
  Future<Result<Counter>> getCounter() async {
    try {
      final value = local.getCounter();
      return Result.success(Counter(value));
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to get counter',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  @override
  Future<Result<Counter>> increment() async {
    try {
      final value = local.increment();
      return Result.success(Counter(value));
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to increment counter',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
