import '../../core/error/failure.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/token_pair.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/mock_kakao_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;
  final MockKakaoAuthDataSource kakao;

  AuthRepositoryImpl({required this.local, required this.kakao});

  @override
  Future<Result<TokenPair?>> getSession() async {
    try {
      return Result.success(local.getSession());
    } catch (e) {
      return Result.failure(Failure('Failed to get session', exception: e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<Result<TokenPair>> loginWithKakao() async {
    try {
      final tokens = await kakao.login();
      final saved = local.save(tokens);
      return Result.success(saved);
    } catch (e) {
      return Result.failure(Failure('Failed to login with Kakao', exception: e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<Result<bool>> logout() async {
    try {
      final ok = local.clear();
      return Result.success(ok);
    } catch (e) {
      return Result.failure(Failure('Failed to logout', exception: e is Exception ? e : Exception(e.toString())));
    }
  }
}
