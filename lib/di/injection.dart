import '../data/datasources/counter_local_data_source.dart';
import '../data/repositories/counter_repository_impl.dart';
import '../domain/repositories/counter_repository.dart';
import '../domain/usecases/get_counter.dart';
import '../domain/usecases/increment_counter.dart';
import '../presentation/counter/counter_view_model.dart';
import 'service_locator.dart';

Future<void> configureDependencies() async {
  sl.registerSingleton<CounterLocalDataSource>(CounterLocalDataSource());

  sl.registerSingleton<CounterRepository>(
    CounterRepositoryImpl(sl.get<CounterLocalDataSource>()),
  );

  sl.registerSingleton<GetCounter>(GetCounter(sl.get<CounterRepository>()));
  sl.registerSingleton<IncrementCounter>(
    IncrementCounter(sl.get<CounterRepository>()),
  );

  sl.registerFactory<CounterViewModel>(
    () => CounterViewModel(
      getCounter: sl.get<GetCounter>(),
      incrementCounter: sl.get<IncrementCounter>(),
    ),
  );
}
