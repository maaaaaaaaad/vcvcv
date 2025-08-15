import 'package:flutter/material.dart';
import 'core/design_system/app_colors.dart';
import 'di/injection.dart';
import 'di/service_locator.dart';
import 'presentation/auth/splash_page.dart';
import 'presentation/auth/splash_view_model.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/login_view_model.dart';
import 'presentation/main/main_page.dart';
import 'presentation/main/paging_view_models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jello Mark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      ),
      home: SplashPage(
        vm: sl.get<SplashViewModel>(),
        homeBuilder: (_) => MainPage(
          homeVm: sl.get<HomeListViewModel>(),
          historyVm: sl.get<HistoryListViewModel>(),
          favoritesVm: sl.get<FavoritesListViewModel>(),
        ),
        loginBuilder: (_) => LoginPage(
          vm: sl.get<LoginViewModel>(),
          homeBuilder: (_) => MainPage(
            homeVm: sl.get<HomeListViewModel>(),
            historyVm: sl.get<HistoryListViewModel>(),
            favoritesVm: sl.get<FavoritesListViewModel>(),
          ),
        ),
      ),
    );
  }
}
