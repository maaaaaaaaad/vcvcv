import '../../core/usecase/page_params.dart';
import '../entities/shop.dart';
import '../entities/history_record.dart';
import '../entities/shop_detail.dart';
import '../entities/review.dart';
import '../../core/usecase/usecase.dart';

abstract class BrowseRepository {
  Future<Result<List<Shop>>> fetchShops(PageParams params);

  Future<Result<List<HistoryRecord>>> fetchHistory(PageParams params);

  Future<Result<List<Shop>>> fetchFavorites(PageParams params);

  Future<Result<ShopDetail>> getShopDetail(String shopId);

  Future<Result<List<Review>>> fetchShopReviews(
    String shopId,
    PageParams params,
  );

  Future<Result<bool>> toggleFavorite(String shopId);
}
