import '../../core/usecase/usecase.dart';
import '../entities/token_pair.dart';
import '../repositories/auth_repository.dart';

class LoginWithKakao implements UseCase<TokenPair, NoParams> {
  final AuthRepository repository;
  LoginWithKakao(this.repository);

  @override
  Future<Result<TokenPair>> call(NoParams params) {
    return repository.loginWithKakao();
  }
}
