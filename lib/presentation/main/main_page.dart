import 'package:flutter/material.dart';
import '../../core/design_system/app_colors.dart';
import '../../domain/entities/history_record.dart';
import '../../domain/entities/shop.dart';
import 'paging_view_models.dart';

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
    HomeTabPage(vm: widget.homeVm),
    HistoryTabPage(vm: widget.historyVm),
    const BookingTabPage(),
    FavoritesTabPage(vm: widget.favoritesVm),
    const ProfileTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: Text(_titleForIndex(_index)),
        centerTitle: true,
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
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
      color: AppColors.lavender.withOpacity(0.3),
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.vm.loading,
        builder: (context, loading, _) => ValueListenableBuilder<List<Shop>>(
          valueListenable: widget.vm.items,
          builder: (context, items, __) => ListView.builder(
            controller: _controller,
            padding: const EdgeInsets.all(12),
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
              final s = items[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: const Icon(Icons.store, color: Colors.white),
                  ),
                  title: Text(
                    s.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softPeach.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(s.category),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(s.rating.toStringAsFixed(1)),
                      const SizedBox(width: 8),
                      const Icon(Icons.place, size: 16, color: Colors.grey),
                      Text(s.distanceKm.toStringAsFixed(1) + 'km'),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryBlue,
                  ),
                ),
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
      color: AppColors.mintGreen.withOpacity(0.2),
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.vm.loading,
        builder: (context, loading, _) =>
            ValueListenableBuilder<List<HistoryRecord>>(
              valueListenable: widget.vm.items,
              builder: (context, items, __) => ListView.builder(
                controller: _controller,
                padding: const EdgeInsets.all(12),
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
                  return Card(
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(
                        Icons.event_available,
                        color: AppColors.primaryBlue,
                      ),
                      title: Text(r.title),
                      subtitle: Text(r.shop + ' · ' + _fmt(r.date)),
                      trailing: Text(
                        r.price.toString() + '원',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }

  String _fmt(DateTime d) {
    return d.year.toString() +
        '-' +
        d.month.toString().padLeft(2, '0') +
        '-' +
        d.day.toString().padLeft(2, '0');
  }
}

class BookingTabPage extends StatelessWidget {
  const BookingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: AppColors.primaryBlue),
          const SizedBox(height: 12),
          const Text('예약 기능은 준비 중입니다.'),
        ],
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
      color: AppColors.lavender.withOpacity(0.2),
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.vm.loading,
        builder: (context, loading, _) => ValueListenableBuilder<List<Shop>>(
          valueListenable: widget.vm.items,
          builder: (context, items, __) => ListView.builder(
            controller: _controller,
            padding: const EdgeInsets.all(12),
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
              final s = items[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: const Icon(Icons.favorite, color: Colors.white),
                  ),
                  title: Text(
                    s.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softPeach.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(s.category),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(s.rating.toStringAsFixed(1)),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryBlue,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.person, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 12),
          const Text('내 정보'),
          const SizedBox(height: 6),
          const Text('닉네임: 젤로 사용자'),
        ],
      ),
    );
  }
}
