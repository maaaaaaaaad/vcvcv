import '../entities/counter.dart';
import '../../core/usecase/usecase.dart';

abstract class CounterRepository {
  Future<Result<Counter>> getCounter();

  Future<Result<Counter>> increment();
}
