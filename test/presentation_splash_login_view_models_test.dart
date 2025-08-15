import 'package:flutter_test/flutter_test.dart';
import 'package:jello_mark/core/usecase/usecase.dart';
import 'package:jello_mark/data/datasources/auth_local_data_source.dart';
import 'package:jello_mark/data/datasources/mock_kakao_auth_data_source.dart';
import 'package:jello_mark/data/repositories/auth_repository_impl.dart';
import 'package:jello_mark/domain/entities/token_pair.dart';
import 'package:jello_mark/domain/usecases/get_session.dart';
import 'package:jello_mark/domain/usecases/login_with_kakao.dart';
import 'package:jello_mark/presentation/auth/login_view_model.dart';
import 'package:jello_mark/presentation/auth/splash_view_model.dart';

void main() {
  group('SplashViewModel', () {
    test('decides login when no session', () async {
      final repo = AuthRepositoryImpl(local: AuthLocalDataSource(), kakao: MockKakaoAuthDataSource());
      final vm = SplashViewModel(getSession: GetSession(repo));
      expect(vm.destination.value, null);
      await vm.decide();
      expect(vm.destination.value, SplashDestination.login);
      vm.dispose();
    });

    test('decides home when session exists', () async {
      final local = AuthLocalDataSource();
      local.save(const TokenPair(accessToken: 'a', refreshToken: 'b'));
      final repo = AuthRepositoryImpl(local: local, kakao: MockKakaoAuthDataSource());
      final vm = SplashViewModel(getSession: GetSession(repo));
      await vm.decide();
      expect(vm.destination.value, SplashDestination.home);
      vm.dispose();
    });
  });

  group('LoginViewModel', () {
    test('login succeeds and returns true', () async {
      final repo = AuthRepositoryImpl(local: AuthLocalDataSource(), kakao: MockKakaoAuthDataSource());
      final vm = LoginViewModel(loginWithKakao: LoginWithKakao(repo));
      expect(vm.loading.value, false);
      final ok = await vm.login();
      expect(ok, true);
      expect(vm.loading.value, false);
      vm.dispose();
    });
  });
}
