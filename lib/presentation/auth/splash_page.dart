import 'package:flutter/material.dart';
import '../../di/service_locator.dart';
import '../main/main_page.dart';
import 'login_page.dart';
import 'splash_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = sl.get<SplashViewModel>();
    _vm.decide();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _navigate(SplashDestination dest) {
    final page = dest == SplashDestination.home
        ? const MainPage()
        : const LoginPage();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<SplashDestination?>(
          valueListenable: _vm.destination,
          builder: (context, value, _) {
            if (value == null) {
              return const CircularProgressIndicator();
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigate(value);
            });
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
