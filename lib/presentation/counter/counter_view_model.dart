import 'package:flutter/foundation.dart';

import '../../core/usecase/usecase.dart';
import '../../domain/usecases/get_counter.dart';
import '../../domain/usecases/increment_counter.dart';

class CounterViewModel {
  final GetCounter getCounter;
  final IncrementCounter incrementCounter;

  CounterViewModel({required this.getCounter, required this.incrementCounter});

  final ValueNotifier<int> counter = ValueNotifier<int>(0);
  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> error = ValueNotifier<String?>(null);

  Future<void> load() async {
    loading.value = true;
    error.value = null;
    final res = await getCounter(const NoParams());
    if (res.isSuccess) {
      counter.value = res.data!.value;
    } else {
      error.value = res.failure!.message;
    }
    loading.value = false;
  }

  Future<void> increment() async {
    loading.value = true;
    error.value = null;
    final res = await incrementCounter(const NoParams());
    if (res.isSuccess) {
      counter.value = res.data!.value;
    } else {
      error.value = res.failure!.message;
    }
    loading.value = false;
  }

  void dispose() {
    counter.dispose();
    loading.dispose();
    error.dispose();
  }
}
