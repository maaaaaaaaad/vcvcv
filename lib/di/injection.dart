import '../data/datasources/auth_local_data_source.dart';
import '../data/datasources/mock_kakao_auth_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_session.dart';
import '../domain/usecases/login_with_kakao.dart';
import '../domain/usecases/logout.dart';
import '../presentation/auth/splash_view_model.dart';
import '../presentation/auth/login_view_model.dart';
import 'service_locator.dart';

Future<void> configureDependencies() async {
  sl.registerSingleton<AuthLocalDataSource>(AuthLocalDataSource());
  sl.registerSingleton<MockKakaoAuthDataSource>(MockKakaoAuthDataSource());
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      local: sl.get<AuthLocalDataSource>(),
      kakao: sl.get<MockKakaoAuthDataSource>(),
    ),
  );
  sl.registerSingleton<GetSession>(GetSession(sl.get<AuthRepository>()));
  sl.registerSingleton<LoginWithKakao>(
    LoginWithKakao(sl.get<AuthRepository>()),
  );
  sl.registerSingleton<Logout>(Logout(sl.get<AuthRepository>()));
  sl.registerFactory<SplashViewModel>(
    () => SplashViewModel(getSession: sl.get<GetSession>()),
  );
  sl.registerFactory<LoginViewModel>(
    () => LoginViewModel(loginWithKakao: sl.get<LoginWithKakao>()),
  );
}
