import '../../core/usecase/page_params.dart';
import '../../domain/entities/history_record.dart';
import '../../domain/entities/shop.dart';

class MockBrowseDataSource {
  final int totalShops;
  final int totalHistory;
  final int totalFavorites;

  const MockBrowseDataSource({
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
      return Shop(
        name: isNail ? '젤네일 전문샵 $idx' : '눈썹 시술 스튜디오 $idx',
        category: isNail ? '네일아트' : '눈썹 시술',
        rating: 4.0 + (idx % 10) / 10,
        distanceKm: (idx % 5) + 0.3,
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
      return Shop(
        name: isNail ? '즐겨찾기 네일샵 $idx' : '즐겨찾기 눈썹샵 $idx',
        category: isNail ? '네일아트' : '눈썹 시술',
        rating: 4.2 + (idx % 7) / 10,
        distanceKm: (idx % 7) + 0.5,
      );
    });
  }
}
