import '../../core/usecase/page_params.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/browse_repository.dart';

class FetchShopReviewsPage
    implements UseCase<List<Review>, ({String shopId, PageParams params})> {
  final BrowseRepository repository;

  FetchShopReviewsPage(this.repository);

  @override
  Future<Result<List<Review>>> call(
    ({String shopId, PageParams params}) input,
  ) {
    return repository.fetchShopReviews(input.shopId, input.params);
  }
}
