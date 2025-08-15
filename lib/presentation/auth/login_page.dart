import 'package:flutter/material.dart';
import 'login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.vm, required this.homeBuilder});

  final LoginViewModel vm;
  final WidgetBuilder homeBuilder;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    widget.vm.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final ok = await widget.vm.login();
    if (!mounted) return;
    if (ok) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: widget.homeBuilder));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: vm.loading,
              builder: (context, loading, _) => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _onLogin,
                  child: Text(loading ? '로그인 중...' : '카카오로 로그인'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String?>(
              valueListenable: vm.error,
              builder: (context, err, _) => err == null
                  ? const SizedBox.shrink()
                  : Text(err, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
