import 'package:flutter/foundation.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/usecases/login_with_kakao.dart';

class LoginViewModel {
  final LoginWithKakao loginWithKakao;
  LoginViewModel({required this.loginWithKakao});

  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> error = ValueNotifier<String?>(null);

  Future<bool> login() async {
    loading.value = true;
    error.value = null;
    final res = await loginWithKakao(const NoParams());
    loading.value = false;
    if (res.isSuccess) {
      return true;
    } else {
      error.value = res.failure?.message;
      return false;
    }
  }

  void dispose() {
    loading.dispose();
    error.dispose();
  }
}
