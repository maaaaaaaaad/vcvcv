import 'package:flutter/material.dart';
import '../../domain/entities/shop.dart';
import '../common/widgets/network_image_thumb.dart';
import '../common/widgets/section_header.dart';
import '../common/widgets/empty_view.dart';
import '../main/paging_view_models.dart';
import '../shop/shop_detail_page.dart';

class FavoritesTabScreen extends StatefulWidget {
  final FavoritesListViewModel vm;

  const FavoritesTabScreen({super.key, required this.vm});

  @override
  State<FavoritesTabScreen> createState() => _FavoritesTabScreenState();
}

class _FavoritesTabScreenState extends State<FavoritesTabScreen> {
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
                    child: const SectionHeader(
                      title: '즐겨찾기',
                      actionText: '편집',
                      onAction: _noop,
                    ),
                  ),
                ),
                if (items.isEmpty && !loading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: EmptyView(
                        title: '즐겨찾기가 비어 있어요',
                        description: '마음에 드는 샵을 추가해 보세요',
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
                            leading: NetworkImageThumb(
                              url: s.thumbnailUrl,
                              size: 56,
                              radius: 8,
                            ),
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

void _noop() {}
