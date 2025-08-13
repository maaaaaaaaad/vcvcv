import '../../core/usecase/usecase.dart';
import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

class GetCounter implements UseCase<Counter, NoParams> {
  final CounterRepository repository;

  GetCounter(this.repository);

  @override
  Future<Result<Counter>> call(NoParams params) {
    return repository.getCounter();
  }
}
