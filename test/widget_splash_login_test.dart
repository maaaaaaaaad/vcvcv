import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jello_mark/di/service_locator.dart';
import 'package:jello_mark/presentation/auth/login_page.dart';
import 'package:jello_mark/presentation/auth/login_view_model.dart';
import 'package:jello_mark/presentation/auth/splash_page.dart';
import 'package:jello_mark/presentation/auth/splash_view_model.dart';
import 'package:jello_mark/main.dart';

class _FakeSplashToLogin extends SplashViewModel {
  _FakeSplashToLogin() : super(getSession: throw UnimplementedError());

  @override
  Future<void> decide() async {
    destination.value = SplashDestination.login;
  }
}

class _FakeSplashToHome extends SplashViewModel {
  _FakeSplashToHome() : super(getSession: throw UnimplementedError());

  @override
  Future<void> decide() async {
    destination.value = SplashDestination.home;
  }
}

class _FakeLoginVm extends LoginViewModel {
  _FakeLoginVm() : super(loginWithKakao: throw UnimplementedError());

  @override
  Future<bool> login() async {
    return true;
  }
}

void main() {
  setUp(() {
    sl.reset();
  });

  testWidgets('SplashPage navigates to LoginPage when not logged in', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SplashPage(
          vm: _FakeSplashToLogin(),
          homeBuilder: (_) => const Placeholder(key: Key('home')),
          loginBuilder: (_) => LoginPage(
            vm: _FakeLoginVm(),
            homeBuilder: (_) => const Placeholder(key: Key('home')),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('SplashPage navigates to Home when logged in', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SplashPage(
          vm: _FakeSplashToHome(),
          homeBuilder: (_) => const Placeholder(key: Key('home')),
          loginBuilder: (_) => LoginPage(
            vm: _FakeLoginVm(),
            homeBuilder: (_) => const Placeholder(key: Key('home')),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('home')), findsOneWidget);
  });

  testWidgets('LoginPage button triggers navigation to Home on success', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          vm: _FakeLoginVm(),
          homeBuilder: (_) => const Placeholder(key: Key('home')),
        ),
      ),
    );
    expect(find.text('카카오로 로그인'), findsOneWidget);
    await tester.tap(find.text('카카오로 로그인'));
    await tester.pump();
    expect(find.byKey(const Key('home')), findsOneWidget);
  });

  testWidgets('MyApp builds and shows SplashPage then goes to Login via fake', (
    tester,
  ) async {
    sl.registerFactory<SplashViewModel>(() => _FakeSplashToLogin());
    sl.registerFactory<LoginViewModel>(() => _FakeLoginVm());
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
