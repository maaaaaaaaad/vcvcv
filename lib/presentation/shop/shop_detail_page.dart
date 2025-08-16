import 'package:flutter/material.dart';
import '../../core/design_system/app_colors.dart';
import '../../di/service_locator.dart';
import '../../domain/usecases/fetch_shop_reviews_page.dart';
import '../../domain/usecases/get_shop_detail.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'shop_detail_view_model.dart';
import 'shop_reviews_page.dart';

class ShopDetailPage extends StatefulWidget {
  final String shopId;

  const ShopDetailPage({super.key, required this.shopId});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _DetailImagePager extends StatelessWidget {
  final List<String> urls;

  const _DetailImagePager({required this.urls});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cacheW = (width * dpr).round();
    return PageView.builder(
      itemCount: urls.length,
      itemBuilder: (context, index) {
        final u = urls[index];
        return Image.network(
          u,
          fit: BoxFit.cover,
          cacheWidth: cacheW,
          filterQuality: FilterQuality.medium,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: AppColors.lavender.withValues(alpha: 0.4),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stack) =>
              Container(color: AppColors.lavender),
        );
      },
    );
  }
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  late final ShopDetailViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ShopDetailViewModel(
      shopId: widget.shopId,
      getShopDetail: sl.get<GetShopDetail>(),
      fetchReviews: sl.get<FetchShopReviewsPage>(),
      toggleFavoriteUseCase: sl.get<ToggleFavorite>(),
    );
    vm.load();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: const Text('매장 상세'),
        actions: [
          ValueListenableBuilder(
            valueListenable: vm.detail,
            builder: (context, detail, _) {
              final fav = detail?.isFavorite == true;
              return IconButton(
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                color: Colors.white,
                onPressed: detail == null ? null : vm.toggleFavorite,
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: vm.detail,
        builder: (context, detail, _) {
          if (detail == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              SizedBox(
                height: 220,
                child: _DetailImagePager(urls: detail.imageUrls),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            detail.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ShopReviewsPage(shopId: detail.id),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                detail.rating.toStringAsFixed(1) +
                                    '(' +
                                    detail.reviewCount.toString() +
                                    ')',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(detail.description),
                    const SizedBox(height: 12),
                    const Text(
                      '시술 정보',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: detail.services
                          .map(
                            (s) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(s.name),
                              subtitle: Text(
                                s.durationMinutes.toString() + '분',
                              ),
                              trailing: Text(
                                s.price.toString() + '원',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text('예약하기'),
            ),
          ),
        ),
      ),
    );
  }
}
