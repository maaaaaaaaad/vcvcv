import 'package:flutter_test/flutter_test.dart';
import 'package:jello_mark/core/usecase/usecase.dart';
import 'package:jello_mark/data/datasources/auth_local_data_source.dart';
import 'package:jello_mark/data/datasources/mock_kakao_auth_data_source.dart';
import 'package:jello_mark/data/repositories/auth_repository_impl.dart';
import 'package:jello_mark/domain/entities/token_pair.dart';
import 'package:jello_mark/domain/usecases/get_session.dart';
import 'package:jello_mark/domain/usecases/login_with_kakao.dart';
import 'package:jello_mark/domain/usecases/logout.dart';

void main() {
  group('Auth layer', () {
    test('AuthLocalDataSource save/get/clear', () async {
      final local = AuthLocalDataSource();
      expect(local.getSession(), null);
      final saved = local.save(const TokenPair(accessToken: 'a', refreshToken: 'b'));
      expect(saved.isValid, true);
      expect(local.getSession()!.accessToken, 'a');
      expect(local.clear(), true);
      expect(local.getSession(), null);
    });

    test('MockKakaoAuthDataSource returns mock token', () async {
      final kakao = MockKakaoAuthDataSource();
      final tokens = await kakao.login();
      expect(tokens.isValid, true);
      expect(tokens.accessToken, isNotEmpty);
      expect(tokens.refreshToken, isNotEmpty);
    });

    test('AuthRepositoryImpl session/login/logout', () async {
      final repo = AuthRepositoryImpl(local: AuthLocalDataSource(), kakao: MockKakaoAuthDataSource());
      final s0 = await repo.getSession();
      expect(s0.isSuccess, true);
      expect(s0.data, null);
      final l = await repo.loginWithKakao();
      expect(l.isSuccess, true);
      expect(l.data!.isValid, true);
      final s1 = await repo.getSession();
      expect(s1.data, isA<TokenPair>());
      final out = await repo.logout();
      expect(out.isSuccess, true);
      final s2 = await repo.getSession();
      expect(s2.data, null);
    });

    test('Auth use cases forward to repository', () async {
      final repo = AuthRepositoryImpl(local: AuthLocalDataSource(), kakao: MockKakaoAuthDataSource());
      final get = GetSession(repo);
      final login = LoginWithKakao(repo);
      final logout = Logout(repo);
      final s0 = await get(const NoParams());
      expect(s0.data, null);
      final l = await login(const NoParams());
      expect(l.data!.isValid, true);
      final s1 = await get(const NoParams());
      expect(s1.data, isA<TokenPair>());
      final o = await logout(const NoParams());
      expect(o.data, true);
    });
  });
}
