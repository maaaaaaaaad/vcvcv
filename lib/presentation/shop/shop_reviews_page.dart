import 'package:flutter/material.dart';
import '../../core/design_system/app_colors.dart';
import '../../di/service_locator.dart';
import '../../domain/usecases/fetch_shop_reviews_page.dart';
import '../../domain/usecases/get_shop_detail.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../common/widgets/network_image_thumb.dart';
import '../common/widgets/image_viewer.dart';
import 'shop_detail_view_model.dart';

class ShopReviewsPage extends StatefulWidget {
  final String shopId;

  const ShopReviewsPage({super.key, required this.shopId});

  @override
  State<ShopReviewsPage> createState() => _ShopReviewsPageState();
}

class _ShopReviewsPageState extends State<ShopReviewsPage> {
  late final ShopDetailViewModel vm;
  final ScrollController _controller = ScrollController();

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
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    vm.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      vm.loadMoreReviews();
    }
  }

  void _openImageViewer(List<String> urls, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => ImageViewer(urls: urls, initialIndex: initialIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: const Text('리뷰'),
      ),
      body: ValueListenableBuilder(
        valueListenable: vm.loadingReviews,
        builder: (context, loading, _) => ValueListenableBuilder(
          valueListenable: vm.reviews,
          builder: (context, items, __) => ListView.builder(
            controller: _controller,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return loading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              }
              final r = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryBlue,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Row(
                        children: [
                          Text(r.user),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(r.rating.toStringAsFixed(1)),
                        ],
                      ),
                      subtitle: Text(r.text),
                    ),
                    if (r.imageUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 56, top: 4),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: r.imageUrls.asMap().entries.map((e) {
                            final i = e.key;
                            final u = e.value;
                            return GestureDetector(
                              onTap: () => _openImageViewer(r.imageUrls, i),
                              child: NetworkImageThumb(
                                url: u,
                                size: 72,
                                radius: 8,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
