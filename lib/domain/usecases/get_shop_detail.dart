import '../../core/usecase/usecase.dart';
import '../../domain/entities/shop_detail.dart';
import '../../domain/repositories/browse_repository.dart';

class GetShopDetail implements UseCase<ShopDetail, String> {
  final BrowseRepository repository;

  GetShopDetail(this.repository);

  @override
  Future<Result<ShopDetail>> call(String shopId) {
    return repository.getShopDetail(shopId);
  }
}
