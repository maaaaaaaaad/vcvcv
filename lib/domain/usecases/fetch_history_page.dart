import '../../core/usecase/page_params.dart';
import '../../core/usecase/usecase.dart';
import '../entities/history_record.dart';
import '../repositories/browse_repository.dart';

class FetchHistoryPage implements UseCase<List<HistoryRecord>, PageParams> {
  final BrowseRepository repository;

  FetchHistoryPage(this.repository);

  @override
  Future<Result<List<HistoryRecord>>> call(PageParams params) {
    return repository.fetchHistory(params);
  }
}
