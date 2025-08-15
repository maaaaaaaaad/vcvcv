import '../../domain/entities/token_pair.dart';

class MockKakaoAuthDataSource {
  Future<TokenPair> login() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return const TokenPair(accessToken: 'mock_access', refreshToken: 'mock_refresh');
  }
}
