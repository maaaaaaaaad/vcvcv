import 'package:flutter/material.dart';
import '../common/widgets/network_image_thumb.dart';
import '../common/widgets/section_header.dart';
import '../common/widgets/quick_actions.dart';
import '../common/widgets/shop_carousel.dart';
import '../../core/design_system/app_colors.dart';
import '../../domain/entities/history_record.dart';
import '../../domain/entities/shop.dart';
import 'paging_view_models.dart';
import '../shop/shop_detail_page.dart';
import '../history/history_detail_page.dart';
import '../home/home_page.dart';
import '../history/history_page.dart';
import '../favorites/favorites_page.dart';
import '../booking/booking_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  final HomeListViewModel homeVm;
  final HistoryListViewModel historyVm;
  final FavoritesListViewModel favoritesVm;

  const MainPage({
    super.key,
    required this.homeVm,
    required this.historyVm,
    required this.favoritesVm,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  late final List<Widget> _pages = [
    HomeTabScreen(vm: widget.homeVm),
    HistoryTabScreen(vm: widget.historyVm),
    const BookingTabScreen(),
    FavoritesTabScreen(vm: widget.favoritesVm),
    const ProfileTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _index == 0
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              elevation: 0,
              title: Text(_titleForIndex(_index)),
              centerTitle: true,
            ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: '이용/기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '예약',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '즐겨찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
        ],
      ),
    );
  }

  String _titleForIndex(int i) {
    switch (i) {
      case 0:
        return '홈';
      case 1:
        return '이용/기록';
      case 2:
        return '예약';
      case 3:
        return '즐겨찾기';
      default:
        return '내정보';
    }
  }
}

class HomeTabPage extends StatefulWidget {
  final HomeListViewModel vm;

  const HomeTabPage({super.key, required this.vm});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
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
      child: SafeArea(
        top: true,
        bottom: false,
        child: ValueListenableBuilder<bool>(
          valueListenable: widget.vm.loading,
          builder: (context, loading, _) => ValueListenableBuilder<List<Shop>>(
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
                          _HeaderGreeting(),
                          const SizedBox(height: 12),
                          _GradientPromoCard(),
                          const SizedBox(height: 12),
                          _QuickActionsRow(
                            onNailTap: () {},
                            onSemiPermanentTap: () {},
                            onWaxingTap: () {},
                            onAestheticTap: () {},
                            onEstimateTap: () {},
                          ),
                          if (items.isNotEmpty) const SizedBox(height: 8),
                          if (items.isNotEmpty)
                            _SectionHeader(
                              title: '이번 주 인기 샵',
                              actionText: '전체보기',
                              onAction: () {},
                            ),
                          if (items.isNotEmpty) const SizedBox(height: 8),
                          if (items.isNotEmpty)
                            ShopCarousel(
                              shops: items.take(8).toList(),
                              onTap: (s) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ShopDetailPage(shopId: s.id),
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 12),
                          _SectionHeader(
                            title: '근처 샵',
                            actionText: '더보기',
                            onAction: () {},
                          ),
                        ],
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
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ShopDetailPage(shopId: s.id),
                                  ),
                                );
                              },
                              leading: _ShopThumb(url: s.thumbnailUrl),
                              title: Text(
                                s.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.softPeach.withValues(
                                        alpha: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(s.category),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  Text(s.rating.toStringAsFixed(1)),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.place,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  Text('${s.distanceKm.toStringAsFixed(1)}km'),
                                ],
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: loading
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
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
    );
  }
}

class HistoryTabPage extends StatefulWidget {
  final HistoryListViewModel vm;

  const HistoryTabPage({super.key, required this.vm});

  @override
  State<HistoryTabPage> createState() => _HistoryTabPageState();
}

class _HistoryTabPageState extends State<HistoryTabPage> {
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
      color: Theme.of(context).colorScheme.surface,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.vm.loading,
        builder: (context, loading, _) =>
            ValueListenableBuilder<List<HistoryRecord>>(
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
                            _SectionHeader(
                              title: '이용 기록',
                              actionText: '전체보기',
                              onAction: () {},
                            ),
                            const SizedBox(height: 8),
                            _HistorySummaryCard(items: items),
                          ],
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final r = items[index];
                        return TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                          tween: Tween(begin: 0, end: 1),
                          builder: (context, t, child) => Opacity(
                            opacity: t,
                            child: Transform.translate(
                              offset: Offset(0, (1 - t) * 10),
                              child: child,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12),
                                  child: Icon(
                                    Icons.event_available,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                title: Text(
                                  r.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text('${r.shop} · ${_fmt(r.date)}'),
                                trailing: Text(
                                  '${r.price}원',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          HistoryDetailPage(record: r),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: loading
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              },
            ),
      ),
    );
  }

  String _fmt(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class BookingTabPage extends StatelessWidget {
  const BookingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      color: c.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GradientPromoCard(),
            const SizedBox(height: 12),
            _QuickActionsRow(
              onNailTap: () {},
              onSemiPermanentTap: () {},
              onWaxingTap: () {},
              onAestheticTap: () {},
              onEstimateTap: () {},
            ),
            const SizedBox(height: 12),
            _SectionHeader(
              title: '다가오는 예약',
              actionText: '전체보기',
              onAction: () {},
            ),
            const SizedBox(height: 8),
            _BookingEmptyCard(),
          ],
        ),
      ),
    );
  }
}

class FavoritesTabPage extends StatefulWidget {
  final FavoritesListViewModel vm;

  const FavoritesTabPage({super.key, required this.vm});

  @override
  State<FavoritesTabPage> createState() => _FavoritesTabPageState();
}

class _FavoritesTabPageState extends State<FavoritesTabPage> {
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
      color: Theme.of(context).colorScheme.surface,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.vm.loading,
        builder: (context, loading, _) => ValueListenableBuilder<List<Shop>>(
          valueListenable: widget.vm.items,
          builder: (context, items, __) {
            return CustomScrollView(
              controller: _controller,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: _SectionHeader(
                      title: '즐겨찾기',
                      actionText: '편집',
                      onAction: () {},
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final s = items[index];
                    return TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, t, child) => Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, (1 - t) * 10),
                          child: child,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ShopDetailPage(shopId: s.id),
                                ),
                              );
                            },
                            leading: _ShopThumb(url: s.thumbnailUrl),
                            title: Text(
                              s.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(s.category),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                Text(s.rating.toStringAsFixed(1)),
                              ],
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: loading
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ShopThumb extends StatelessWidget {
  final String url;

  const _ShopThumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return NetworkImageThumb(
      url: url,
      size: 56,
      radius: 8,
      placeholderColor: AppColors.lavender,
    );
  }
}

class _HeaderGreeting extends StatelessWidget {
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

class _QuickActionsRow extends StatelessWidget {
  final VoidCallback onNailTap;
  final VoidCallback onSemiPermanentTap;
  final VoidCallback onWaxingTap;
  final VoidCallback onAestheticTap;
  final VoidCallback onEstimateTap;

  const _QuickActionsRow({
    required this.onNailTap,
    required this.onSemiPermanentTap,
    required this.onWaxingTap,
    required this.onAestheticTap,
    required this.onEstimateTap,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionsRow(
      onNailTap: onNailTap,
      onSemiPermanentTap: onSemiPermanentTap,
      onWaxingTap: onWaxingTap,
      onAestheticTap: onAestheticTap,
      onEstimateTap: onEstimateTap,
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.94 : 1,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: Container(
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(widget.icon, color: color.primary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: title,
      actionText: actionText,
      onAction: onAction,
    );
  }
}

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      color: c.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeaderCard(),
            const SizedBox(height: 12),
            _SectionHeader(title: '설정', actionText: '계정', onAction: () {}),
            const SizedBox(height: 8),
            _ProfileActionList(),
          ],
        ),
      ),
    );
  }
}

class _HistorySummaryCard extends StatelessWidget {
  final List<HistoryRecord> items;

  const _HistorySummaryCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final count = items.length;
    final total = items.fold<num>(0, (a, b) => a + b.price);
    return Container(
      decoration: BoxDecoration(
        color: c.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이용 횟수',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: c.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count회',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: c.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '총 결제 금액',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: c.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₩${total.toString()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: c.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingEmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: c.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: c.onSecondaryContainer.withValues(alpha: 0.12),
            child: Icon(Icons.calendar_today, color: c.onSecondaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '예약이 비어 있어요',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: c.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '지금 예약하고 아름다움을 준비해 보세요',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: c.onSecondaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(onPressed: () {}, child: const Text('예약하기')),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatefulWidget {
  @override
  State<_ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<_ProfileHeaderCard> {
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
    final c = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.primary, c.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '젤로 사용자',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: c.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '반가워요, 오늘도 아름다워져요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: c.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(onPressed: () {}, child: const Text('프로필')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileActionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Column(
      children: [
        _ProfileActionTile(
          icon: Icons.book_online,
          color: c.primary,
          title: '예약 내역',
          subtitle: '지난 예약을 확인해요',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _ProfileActionTile(
          icon: Icons.credit_card,
          color: c.tertiary,
          title: '결제 수단',
          subtitle: '카드를 관리해요',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _ProfileActionTile(
          icon: Icons.notifications_none,
          color: c.secondary,
          title: '알림 설정',
          subtitle: '푸시 알림을 관리해요',
          onTap: () {},
        ),
      ],
    );
  }
}

class _ProfileActionTile extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ProfileActionTile> createState() => _ProfileActionTileState();
}

class _ProfileActionTileState extends State<_ProfileActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.color.withValues(alpha: 0.12),
              child: Icon(widget.icon, color: widget.color),
            ),
            title: Text(
              widget.title,
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(widget.subtitle),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
