import 'package:flutter/material.dart';
import 'splash_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.vm,
    required this.homeBuilder,
    required this.loginBuilder,
  });

  final SplashViewModel vm;
  final WidgetBuilder homeBuilder;
  final WidgetBuilder loginBuilder;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget.vm.decide();
  }

  @override
  void dispose() {
    widget.vm.dispose();
    super.dispose();
  }

  void _navigate(SplashDestination dest) {
    final page = dest == SplashDestination.home
        ? widget.homeBuilder(context)
        : widget.loginBuilder(context);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<SplashDestination?>(
        valueListenable: widget.vm.destination,
        builder: (context, value, _) {
          if (value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigate(value);
            });
          }
          return Container(
            color: Colors.white,
            child: Center(
              child: Image.asset(
                'assets/app_splash_screen/jello-mark-splash.png',
                width: 220,
              ),
            ),
          );
        },
      ),
    );
  }
}
