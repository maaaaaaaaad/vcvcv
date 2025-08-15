import '../../core/usecase/page_params.dart';
import '../entities/shop.dart';
import '../entities/history_record.dart';
import '../../core/usecase/usecase.dart';

abstract class BrowseRepository {
  Future<Result<List<Shop>>> fetchShops(PageParams params);

  Future<Result<List<HistoryRecord>>> fetchHistory(PageParams params);

  Future<Result<List<Shop>>> fetchFavorites(PageParams params);
}
