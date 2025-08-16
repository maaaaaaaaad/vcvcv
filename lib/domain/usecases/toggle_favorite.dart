import '../../core/usecase/usecase.dart';
import '../../domain/repositories/browse_repository.dart';

class ToggleFavorite implements UseCase<bool, String> {
  final BrowseRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Result<bool>> call(String shopId) {
    return repository.toggleFavorite(shopId);
  }
}
