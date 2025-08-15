import '../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<bool, NoParams> {
  final AuthRepository repository;
  Logout(this.repository);

  @override
  Future<Result<bool>> call(NoParams params) {
    return repository.logout();
  }
}
