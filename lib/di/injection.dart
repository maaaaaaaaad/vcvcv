import '../data/datasources/auth_local_data_source.dart';
import '../data/datasources/mock_kakao_auth_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_session.dart';
import '../domain/usecases/login_with_kakao.dart';
import '../domain/usecases/logout.dart';
import '../presentation/auth/splash_view_model.dart';
import '../presentation/auth/login_view_model.dart';
import '../data/datasources/mock_browse_data_source.dart';
import '../data/repositories/browse_repository_impl.dart';
import '../domain/repositories/browse_repository.dart';
import '../domain/usecases/fetch_shops_page.dart';
import '../domain/usecases/fetch_history_page.dart';
import '../domain/usecases/fetch_favorites_page.dart';
import '../presentation/main/paging_view_models.dart';
import '../domain/usecases/get_shop_detail.dart';
import '../domain/usecases/fetch_shop_reviews_page.dart';
import '../domain/usecases/toggle_favorite.dart';
import 'service_locator.dart';
import '../core/notifications/notification_service.dart';

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

  sl.registerSingleton<MockBrowseDataSource>(MockBrowseDataSource());
  sl.registerSingleton<BrowseRepository>(
    BrowseRepositoryImpl(sl.get<MockBrowseDataSource>()),
  );
  sl.registerSingleton<FetchShopsPage>(
    FetchShopsPage(sl.get<BrowseRepository>()),
  );
  sl.registerSingleton<FetchHistoryPage>(
    FetchHistoryPage(sl.get<BrowseRepository>()),
  );
  sl.registerSingleton<FetchFavoritesPage>(
    FetchFavoritesPage(sl.get<BrowseRepository>()),
  );
  sl.registerFactory<HomeListViewModel>(
    () => HomeListViewModel(useCase: sl.get<FetchShopsPage>()),
  );
  sl.registerFactory<HistoryListViewModel>(
    () => HistoryListViewModel(useCase: sl.get<FetchHistoryPage>()),
  );
  sl.registerFactory<FavoritesListViewModel>(
    () => FavoritesListViewModel(useCase: sl.get<FetchFavoritesPage>()),
  );

  sl.registerSingleton<GetShopDetail>(
    GetShopDetail(sl.get<BrowseRepository>()),
  );
  sl.registerSingleton<FetchShopReviewsPage>(
    FetchShopReviewsPage(sl.get<BrowseRepository>()),
  );
  sl.registerSingleton<ToggleFavorite>(
    ToggleFavorite(sl.get<BrowseRepository>()),
  );

  sl.registerSingleton<NotificationService>(NotificationService());
}
