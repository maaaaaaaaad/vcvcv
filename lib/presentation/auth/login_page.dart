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
  double _logoScale = 0.9;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _logoScale = 1);
    });
  }

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
    } else {
      final msg = widget.vm.error.value ?? '로그인에 실패했어요. 잠시 후 다시 시도해 주세요.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final vm = widget.vm;
    return Scaffold(
      backgroundColor: c.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/app_splash_screen/jello-mark-splash-screen.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  AnimatedScale(
                    scale: _logoScale,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    child: Column(
                      children: [
                        Text(
                          '젤로마크',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.45),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: c.surfaceContainerHighest.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '3초 가입하고 웰컴 쿠폰을 받아보세요',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: vm.loading,
                    builder: (context, loading, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: _KakaoButton(
                          onPressed: loading ? null : _onLogin,
                          loading: loading,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<String?>(
                    valueListenable: vm.error,
                    builder: (context, err, _) => err == null
                        ? const SizedBox(height: 0)
                        : Text(err, style: TextStyle(color: c.error)),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '로그인 시 이용약관 및 개인정보처리방침에 동의합니다',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: c.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KakaoButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool loading;

  const _KakaoButton({required this.onPressed, required this.loading});

  @override
  State<_KakaoButton> createState() => _KakaoButtonState();
}

class _KakaoButtonState extends State<_KakaoButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final kakaoYellow = const Color(0xFFFEE500);
    final bg = widget.onPressed == null
        ? kakaoYellow.withValues(alpha: 0.6)
        : kakaoYellow;
    return GestureDetector(
      onTapDown: widget.onPressed == null
          ? null
          : (_) => setState(() => _pressed = true),
      onTapCancel: widget.onPressed == null
          ? null
          : () => setState(() => _pressed = false),
      onTapUp: widget.onPressed == null
          ? null
          : (_) => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.loading ? '로그인 중...' : '카카오로 계속하기',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
