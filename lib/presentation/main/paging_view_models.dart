import 'package:flutter/foundation.dart';
import '../../core/usecase/page_params.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/shop.dart';
import '../../domain/entities/history_record.dart';
import '../../domain/usecases/fetch_shops_page.dart';
import '../../domain/usecases/fetch_history_page.dart';
import '../../domain/usecases/fetch_favorites_page.dart';

class PagingViewModel<T> {
  final UseCase<List<T>, PageParams> fetch;
  final int pageSize;

  PagingViewModel({required this.fetch, this.pageSize = 10});

  final ValueNotifier<List<T>> items = ValueNotifier<List<T>>(<T>[]);
  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  bool _hasMore = true;
  int _page = 0;

  Future<void> initIfNeeded() async {
    if (items.value.isEmpty) {
      await loadMore();
    }
  }

  Future<void> loadMore() async {
    if (loading.value || !_hasMore) return;
    loading.value = true;
    final res = await fetch(PageParams(page: _page, pageSize: pageSize));
    if (res.isSuccess) {
      final list = res.data!;
      if (list.isEmpty) {
        _hasMore = false;
      } else {
        final current = List<T>.from(items.value)..addAll(list);
        items.value = current;
        _page += 1;
      }
    }
    loading.value = false;
  }

  void dispose() {
    items.dispose();
    loading.dispose();
  }
}

class HomeListViewModel extends PagingViewModel<Shop> {
  HomeListViewModel({required FetchShopsPage useCase}) : super(fetch: useCase);
}

class HistoryListViewModel extends PagingViewModel<HistoryRecord> {
  HistoryListViewModel({required FetchHistoryPage useCase})
    : super(fetch: useCase);
}

class FavoritesListViewModel extends PagingViewModel<Shop> {
  FavoritesListViewModel({required FetchFavoritesPage useCase})
    : super(fetch: useCase);
}
