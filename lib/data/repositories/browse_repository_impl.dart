import '../../core/error/failure.dart';
import '../../core/usecase/page_params.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/history_record.dart';
import '../../domain/entities/shop.dart';
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
}
