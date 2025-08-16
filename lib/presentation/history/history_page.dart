import 'package:flutter/material.dart';
import '../../domain/entities/history_record.dart';
import '../common/widgets/section_header.dart';
import '../common/widgets/empty_view.dart';
import '../main/paging_view_models.dart';
import '../history/history_detail_page.dart';

class HistoryTabScreen extends StatefulWidget {
  final HistoryListViewModel vm;

  const HistoryTabScreen({super.key, required this.vm});

  @override
  State<HistoryTabScreen> createState() => _HistoryTabScreenState();
}

class _HistoryTabScreenState extends State<HistoryTabScreen> {
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
                            const SectionHeader(
                              title: '이용 기록',
                              actionText: '전체보기',
                              onAction: _noop,
                            ),
                            const SizedBox(height: 8),
                            _HistorySummaryCard(items: items),
                          ],
                        ),
                      ),
                    ),
                    if (items.isEmpty && !loading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: EmptyView(
                            title: '아직 이용 기록이 없어요',
                            description: '첫 뷰티를 예약해 보세요',
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

String _fmt(DateTime d) {
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

void _noop() {}
