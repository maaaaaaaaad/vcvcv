import '../../core/usecase/page_params.dart';
import '../../domain/entities/history_record.dart';
import '../../domain/entities/shop.dart';
import '../../domain/entities/shop_detail.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/service_item.dart';

class MockBrowseDataSource {
  final int totalShops;
  final int totalHistory;
  final int totalFavorites;
  final Set<String> _favorites = <String>{};

  MockBrowseDataSource({
    this.totalShops = 50,
    this.totalHistory = 40,
    this.totalFavorites = 30,
  });

  Future<List<Shop>> fetchShops(PageParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final start = params.page * params.pageSize;
    final end = (start + params.pageSize).clamp(0, totalShops);
    if (start >= totalShops) return <Shop>[];
    return List.generate(end - start, (i) {
      final idx = start + i + 1;
      final isNail = idx % 2 == 0;
      final id = 'shop_$idx';
      return Shop(
        id: id,
        name: isNail ? '젤네일 전문샵 $idx' : '눈썹 시술 스튜디오 $idx',
        category: isNail ? '네일아트' : '눈썹 시술',
        rating: 4.0 + (idx % 10) / 10,
        distanceKm: (idx % 5) + 0.3,
        thumbnailUrl: 'https://picsum.photos/seed/$id/120/120',
      );
    });
  }

  Future<List<HistoryRecord>> fetchHistory(PageParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    final start = params.page * params.pageSize;
    final end = (start + params.pageSize).clamp(0, totalHistory);
    if (start >= totalHistory) return <HistoryRecord>[];
    return List.generate(end - start, (i) {
      final idx = start + i + 1;
      return HistoryRecord(
        title: idx % 2 == 0 ? '네일 케어' : '눈썹 라미네이션',
        shop: '제휴매장 $idx',
        date: DateTime.now().subtract(Duration(days: idx)),
        price: 30000 + (idx % 5) * 5000,
      );
    });
  }

  Future<List<Shop>> fetchFavorites(PageParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 70));
    final start = params.page * params.pageSize;
    final end = (start + params.pageSize).clamp(0, totalFavorites);
    if (start >= totalFavorites) return <Shop>[];
    return List.generate(end - start, (i) {
      final idx = start + i + 1;
      final isNail = idx % 3 != 0;
      final id = 'fav_$idx';
      return Shop(
        id: id,
        name: isNail ? '즐겨찾기 네일샵 $idx' : '즐겨찾기 눈썹샵 $idx',
        category: isNail ? '네일아트' : '눈썹 시술',
        rating: 4.2 + (idx % 7) / 10,
        distanceKm: (idx % 7) + 0.5,
        thumbnailUrl: 'https://picsum.photos/seed/$id/120/120',
      );
    });
  }

  Future<bool> toggleFavorite(String shopId) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (_favorites.contains(shopId)) {
      _favorites.remove(shopId);
      return false;
    } else {
      _favorites.add(shopId);
      return true;
    }
  }

  Future<ShopDetail> getShopDetail(String shopId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final idx = int.tryParse(shopId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    final isNail = idx % 2 == 0;
    final name = isNail ? '젤네일 전문샵 $idx' : '눈썹 시술 스튜디오 $idx';
    final imageUrls = List<String>.generate(
      3,
      (i) => 'https://picsum.photos/seed/${shopId}_$i/600/360',
    );
    final services = List<ServiceItem>.from([
      ServiceItem(
        name: isNail ? '젤네일 기본' : '눈썹 디자인',
        price: 55000,
        durationMinutes: 60,
      ),
      ServiceItem(
        name: isNail ? '젤네일 아트' : '눈썹 라미네이션',
        price: 80000,
        durationMinutes: 90,
      ),
      ServiceItem(name: '케어/클리닉', price: 30000, durationMinutes: 30),
    ]);
    final rating = 4.0 + (idx % 10) / 10;
    final reviewCount = 120;
    return ShopDetail(
      id: shopId,
      name: name,
      description: isNail ? '감각적인 젤네일 아트를 제공하는 매장' : '자연스러운 눈썹 시술을 제공하는 스튜디오',
      rating: rating,
      reviewCount: reviewCount,
      imageUrls: imageUrls,
      services: services,
      isFavorite: _favorites.contains(shopId),
    );
  }

  Future<List<Review>> fetchShopReviews(
    String shopId,
    PageParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 90));
    final start = params.page * params.pageSize;
    final total = 120;
    if (start >= total) return <Review>[];
    final end = (start + params.pageSize).clamp(0, total);
    return List<Review>.generate(end - start, (i) {
      final idx = start + i + 1;
      final imgCount = idx % 4;
      final imgs = List<String>.generate(
        imgCount,
        (j) => 'https://picsum.photos/seed/${shopId}_rev_${idx}_$j/240/240',
      );
      return Review(
        id: '${shopId}_rev_$idx',
        user: '사용자$idx',
        rating: 3.5 + (idx % 3) * 0.5,
        text: idx % 2 == 0 ? '만족스러운 서비스였습니다.' : '시설이 깔끔하고 응대가 친절했어요.',
        date: DateTime.now().subtract(Duration(days: idx)),
        imageUrls: imgs,
      );
    });
  }
}
