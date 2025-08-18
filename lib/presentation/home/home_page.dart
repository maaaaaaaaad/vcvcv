import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/design_system/app_colors.dart';
import '../../domain/entities/shop.dart';
import '../common/widgets/skeleton.dart';
import '../common/widgets/quick_actions.dart';
import '../common/widgets/section_header.dart';
import '../common/widgets/shop_carousel.dart';
import '../common/widgets/empty_view.dart';
import '../main/paging_view_models.dart';

class HomeTabScreen extends StatefulWidget {
  final HomeListViewModel vm;

  const HomeTabScreen({super.key, required this.vm});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.vm.initIfNeeded();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      widget.vm.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lavender.withValues(alpha: 0.2),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          top: true,
          bottom: false,
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.vm.loading,
            builder: (context, loading, _) =>
                ValueListenableBuilder<List<Shop>>(
                  valueListenable: widget.vm.items,
                  builder: (context, items, __) {
                    return CustomScrollView(
                      controller: _controller,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _HeaderGreeting(),
                                const SizedBox(height: 12),
                                const _GradientPromoCard(),
                                const SizedBox(height: 12),
                                QuickActionsRow(
                                  onNailTap: () {},
                                  onLashTap: () {},
                                  onBrowTap: () {},
                                  onEstimateTap: () {},
                                ),
                                if (items.isNotEmpty) const SizedBox(height: 8),
                                if (items.isNotEmpty)
                                  SectionHeader(
                                    title: '이번 주 인기 샵',
                                    actionText: '전체보기',
                                    onAction: () {},
                                  ),
                                if (items.isNotEmpty) const SizedBox(height: 8),
                                if (items.isNotEmpty)
                                  ShopCarousel(
                                    shops: items.take(8).toList(),
                                    onTap: (s) {
                                      Navigator.of(context).pushNamed(
                                        '/shopDetail',
                                        arguments: s.id,
                                      );
                                    },
                                  ),
                                const SizedBox(height: 12),
                                SectionHeader(
                                  title: '근처 샵',
                                  actionText: '더보기',
                                  onAction: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (items.isEmpty && loading)
                          SliverList.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: _ShopBannerSkeleton(),
                            ),
                          ),
                        if (items.isEmpty && !loading)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: EmptyView(
                                title: '매장을 불러오지 않았어요',
                                description: '새로고침하거나 잠시 후 다시 시도해주세요',
                              ),
                            ),
                          ),
                        SliverList.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final s = items[index];
                            return TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              tween: Tween(begin: 0, end: 1),
                              builder: (context, t, child) => Opacity(
                                opacity: t,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - t) * 12),
                                  child: child,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: _ShopBannerCard(shop: s),
                              ),
                            );
                          },
                        ),
                        SliverToBoxAdapter(
                          child: loading
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}

class _HeaderGreeting extends StatelessWidget {
  const _HeaderGreeting();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '안녕하세요 ✨',
                style: t.labelLarge?.copyWith(color: color.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                '오늘도 반짝이는 뷰티를 만나보세요',
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: color.primary.withValues(alpha: 0.15),
          child: Icon(Icons.notifications_none, color: color.primary),
        ),
      ],
    );
  }
}

class _GradientPromoCard extends StatefulWidget {
  const _GradientPromoCard();

  @override
  State<_GradientPromoCard> createState() => _GradientPromoCardState();
}

class _GradientPromoCardState extends State<_GradientPromoCard>
    with SingleTickerProviderStateMixin {
  double _scale = 0.95;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 60),
      () => setState(() => _scale = 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.primary, color.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '여름 아트 픽',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: color.onPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '시원한 민트 라인아트',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.onPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '지금 예약하고 10% 할인',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: color.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.brush, color: Colors.white, size: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopBannerCard extends StatelessWidget {
  final Shop shop;

  const _ShopBannerCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 24;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cacheW = (width * dpr).round();
    final c = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed('/shopDetail', arguments: shop.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              shop.thumbnailUrl,
              width: width,
              height: 160,
              fit: BoxFit.cover,
              cacheWidth: cacheW,
              filterQuality: FilterQuality.medium,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: frame != null
                      ? child
                      : const SkeletonBox(
                          width: double.infinity,
                          height: 160,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                        ),
                );
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SkeletonBox(
                  width: double.infinity,
                  height: 160,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                );
              },
              errorBuilder: (context, error, stack) => const SkeletonBox(
                width: double.infinity,
                height: 160,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softPeach.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(shop.category),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(shop.rating.toStringAsFixed(1)),
                      const SizedBox(width: 8),
                      const Icon(Icons.place, size: 16, color: Colors.grey),
                      Text('${shop.distanceKm.toStringAsFixed(1)}km'),
                      const Spacer(),
                      Icon(Icons.chevron_right, color: c.primary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopBannerSkeleton extends StatelessWidget {
  const _ShopBannerSkeleton();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 24;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: width,
              height: 160,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(width: 140, height: 16),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SkeletonBox(width: 60, height: 18),
                      SizedBox(width: 8),
                      SkeletonBox(width: 40, height: 16),
                      SizedBox(width: 8),
                      SkeletonBox(width: 50, height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
