import '../../core/usecase/page_params.dart';
import '../../core/usecase/usecase.dart';
import '../entities/shop.dart';
import '../repositories/browse_repository.dart';

class FetchFavoritesPage implements UseCase<List<Shop>, PageParams> {
  final BrowseRepository repository;

  FetchFavoritesPage(this.repository);

  @override
  Future<Result<List<Shop>>> call(PageParams params) {
    return repository.fetchFavorites(params);
  }
}
