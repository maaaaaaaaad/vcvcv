import '../../core/usecase/usecase.dart';
import '../entities/token_pair.dart';

abstract class AuthRepository {
  Future<Result<TokenPair?>> getSession();
  Future<Result<TokenPair>> loginWithKakao();
  Future<Result<bool>> logout();
}
