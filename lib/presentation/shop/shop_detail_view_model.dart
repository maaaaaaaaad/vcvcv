import 'package:flutter/foundation.dart';
import '../../core/usecase/page_params.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/shop_detail.dart';
import '../../domain/usecases/fetch_shop_reviews_page.dart';
import '../../domain/usecases/get_shop_detail.dart';
import '../../domain/usecases/toggle_favorite.dart';

class ShopDetailViewModel {
  final String shopId;
  final GetShopDetail getShopDetail;
  final FetchShopReviewsPage fetchReviews;
  final ToggleFavorite toggleFavoriteUseCase;

  ShopDetailViewModel({
    required this.shopId,
    required this.getShopDetail,
    required this.fetchReviews,
    required this.toggleFavoriteUseCase,
  });

  final ValueNotifier<ShopDetail?> detail = ValueNotifier<ShopDetail?>(null);
  final ValueNotifier<bool> loadingDetail = ValueNotifier<bool>(false);
  final ValueNotifier<List<Review>> reviews = ValueNotifier<List<Review>>(
    <Review>[],
  );
  final ValueNotifier<bool> loadingReviews = ValueNotifier<bool>(false);
  bool _hasMore = true;
  int _page = 0;
  final int pageSize = 10;

  Future<void> load() async {
    if (detail.value != null) return;
    loadingDetail.value = true;
    final res = await getShopDetail(shopId);
    if (res.isSuccess) {
      detail.value = res.data!;
    }
    loadingDetail.value = false;
    await loadMoreReviews();
  }

  Future<void> loadMoreReviews() async {
    if (loadingReviews.value || !_hasMore) return;
    loadingReviews.value = true;
    final res = await fetchReviews((
      shopId: shopId,
      params: PageParams(page: _page, pageSize: pageSize),
    ));
    if (res.isSuccess) {
      final list = res.data!;
      if (list.isEmpty) {
        _hasMore = false;
      } else {
        final current = List<Review>.from(reviews.value)..addAll(list);
        reviews.value = current;
        _page += 1;
      }
    }
    loadingReviews.value = false;
  }

  Future<void> toggleFavorite() async {
    final res = await toggleFavoriteUseCase(shopId);
    if (res.isSuccess && detail.value != null) {
      final d = detail.value!;
      detail.value = ShopDetail(
        id: d.id,
        name: d.name,
        description: d.description,
        rating: d.rating,
        reviewCount: d.reviewCount,
        imageUrls: d.imageUrls,
        services: d.services,
        isFavorite: res.data!,
      );
    }
  }

  void dispose() {
    detail.dispose();
    loadingDetail.dispose();
    reviews.dispose();
    loadingReviews.dispose();
  }
}
