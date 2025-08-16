import '../../core/error/failure.dart';
import '../../core/usecase/page_params.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/history_record.dart';
import '../../domain/entities/shop.dart';
import '../../domain/entities/shop_detail.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/browse_repository.dart';
import '../datasources/mock_browse_data_source.dart';

class BrowseRepositoryImpl implements BrowseRepository {
  final MockBrowseDataSource dataSource;

  BrowseRepositoryImpl(this.dataSource);

  @override
  Future<Result<List<Shop>>> fetchShops(PageParams params) async {
    try {
      final list = await dataSource.fetchShops(params);
      return Result.success(list);
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to fetch shops',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  @override
  Future<Result<List<HistoryRecord>>> fetchHistory(PageParams params) async {
    try {
      final list = await dataSource.fetchHistory(params);
      return Result.success(list);
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to fetch history',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  @override
  Future<Result<List<Shop>>> fetchFavorites(PageParams params) async {
    try {
      final list = await dataSource.fetchFavorites(params);
      return Result.success(list);
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to fetch favorites',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  @override
  Future<Result<ShopDetail>> getShopDetail(String shopId) async {
    try {
      final detail = await dataSource.getShopDetail(shopId);
      return Result.success(detail);
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to get shop detail',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  @override
  Future<Result<List<Review>>> fetchShopReviews(
    String shopId,
    PageParams params,
  ) async {
    try {
      final list = await dataSource.fetchShopReviews(shopId, params);
      return Result.success(list);
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to fetch reviews',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(String shopId) async {
    try {
      final v = await dataSource.toggleFavorite(shopId);
      return Result.success(v);
    } catch (e) {
      return Result.failure(
        Failure(
          'Failed to toggle favorite',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
