import 'package:flutter/material.dart';
import '../../di/service_locator.dart';
import '../home/home_page.dart';
import 'login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel? _vm;

  @override
  void initState() {
    super.initState();
    try {
      _vm = sl.get<LoginViewModel>();
    } catch (_) {
      _vm = null;
    }
  }

  @override
  void dispose() {
    _vm?.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_vm == null) return;
    final ok = await _vm!.login();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Jello Mark Home Page')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = _vm;
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (vm != null)
              ValueListenableBuilder<bool>(
                valueListenable: vm.loading,
                builder: (context, loading, _) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _onLogin,
                    child: Text(loading ? '로그인 중...' : '카카오로 로그인'),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  child: const Text('카카오로 로그인'),
                ),
              ),
            const SizedBox(height: 12),
            if (vm != null)
              ValueListenableBuilder<String?>(
                valueListenable: vm.error,
                builder: (context, err, _) => err == null
                    ? const SizedBox.shrink()
                    : Text(err, style: const TextStyle(color: Colors.red)),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
