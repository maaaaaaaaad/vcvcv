import 'package:flutter/material.dart';
import '../../core/design_system/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  late final List<Widget> _pages = [
    const HomeTabPage(),
    const HistoryTabPage(),
    const BookingTabPage(),
    const FavoritesTabPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: '이용/기록'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '예약'),
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
  const HomeTabPage({super.key});
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final ScrollController _controller = ScrollController();
  final List<_Shop> _items = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200 && !_loading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final start = _items.length;
    final more = List.generate(10, (i) {
      final idx = start + i + 1;
      final isNail = idx % 2 == 0;
      return _Shop(
        name: isNail ? '젤네일 전문샵 $idx' : '눈썹 시술 스튜디오 $idx',
        category: isNail ? '네일아트' : '눈썹 시술',
        rating: 4.0 + (idx % 10) / 10,
        distanceKm: (idx % 5) + 0.3,
      );
    });
    _items.addAll(more);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lavender.withOpacity(0.3),
      child: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.all(12),
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return _loading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          final s = _items[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.primaryBlue, child: const Icon(Icons.store, color: Colors.white)),
              title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.softPeach.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
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
              trailing: Icon(Icons.chevron_right, color: AppColors.primaryBlue),
            ),
          );
        },
      ),
    );
  }
}

class HistoryTabPage extends StatefulWidget {
  const HistoryTabPage({super.key});
  @override
  State<HistoryTabPage> createState() => _HistoryTabPageState();
}

class _HistoryTabPageState extends State<HistoryTabPage> {
  final ScrollController _controller = ScrollController();
  final List<_Record> _records = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200 && !_loading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final start = _records.length;
    final more = List.generate(10, (i) {
      final idx = start + i + 1;
      return _Record(
        title: idx % 2 == 0 ? '네일 케어' : '눈썹 라미네이션',
        shop: '제휴매장 ' + idx.toString(),
        date: DateTime.now().subtract(Duration(days: idx)),
        price: 30000 + (idx % 5) * 5000,
      );
    });
    _records.addAll(more);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mintGreen.withOpacity(0.2),
      child: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.all(12),
        itemCount: _records.length + 1,
        itemBuilder: (context, index) {
          if (index == _records.length) {
            return _loading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          final r = _records[index];
          return Card(
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.event_available, color: AppColors.primaryBlue),
              title: Text(r.title),
              subtitle: Text(r.shop + ' · ' + _fmt(r.date)),
              trailing: Text(r.price.toString() + '원', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }

  String _fmt(DateTime d) {
    return d.year.toString() + '-' + d.month.toString().padLeft(2, '0') + '-' + d.day.toString().padLeft(2, '0');
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
  const FavoritesTabPage({super.key});
  @override
  State<FavoritesTabPage> createState() => _FavoritesTabPageState();
}

class _FavoritesTabPageState extends State<FavoritesTabPage> {
  final ScrollController _controller = ScrollController();
  final List<_Shop> _favorites = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200 && !_loading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final start = _favorites.length;
    final more = List.generate(10, (i) {
      final idx = start + i + 1;
      final isNail = idx % 3 != 0;
      return _Shop(
        name: isNail ? '즐겨찾기 네일샵 ' + idx.toString() : '즐겨찾기 눈썹샵 ' + idx.toString(),
        category: isNail ? '네일아트' : '눈썹 시술',
        rating: 4.2 + (idx % 7) / 10,
        distanceKm: (idx % 7) + 0.5,
      );
    });
    _favorites.addAll(more);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lavender.withOpacity(0.2),
      child: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.all(12),
        itemCount: _favorites.length + 1,
        itemBuilder: (context, index) {
          if (index == _favorites.length) {
            return _loading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          final s = _favorites[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.primaryBlue, child: const Icon(Icons.favorite, color: Colors.white)),
              title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.softPeach.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                    child: Text(s.category),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(s.rating.toStringAsFixed(1)),
                ],
              ),
              trailing: Icon(Icons.chevron_right, color: AppColors.primaryBlue),
            ),
          );
        },
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
          CircleAvatar(radius: 36, backgroundColor: AppColors.primaryBlue, child: const Icon(Icons.person, color: Colors.white, size: 36)),
          const SizedBox(height: 12),
          const Text('내 정보'),
          const SizedBox(height: 6),
          const Text('닉네임: 젤로 사용자'),
        ],
      ),
    );
  }
}

class _Shop {
  final String name;
  final String category;
  final double rating;
  final double distanceKm;
  _Shop({required this.name, required this.category, required this.rating, required this.distanceKm});
}

class _Record {
  final String title;
  final String shop;
  final DateTime date;
  final int price;
  _Record({required this.title, required this.shop, required this.date, required this.price});
}
