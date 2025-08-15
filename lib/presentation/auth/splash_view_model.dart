import 'package:flutter/foundation.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/usecases/get_session.dart';

enum SplashDestination { home, login }

class SplashViewModel {
  final GetSession getSession;
  SplashViewModel({required this.getSession});

  final ValueNotifier<SplashDestination?> destination = ValueNotifier<SplashDestination?>(null);

  Future<void> decide() async {
    final res = await getSession(const NoParams());
    if (res.isSuccess && res.data != null && res.data!.isValid) {
      destination.value = SplashDestination.home;
    } else {
      destination.value = SplashDestination.login;
    }
  }

  void dispose() {
    destination.dispose();
  }
}
