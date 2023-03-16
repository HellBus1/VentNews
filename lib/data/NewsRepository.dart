import 'package:vent_news/commons/resources/DataState.dart';
import 'package:vent_news/data/base/BaseApiRepository.dart';
import 'package:vent_news/data/model/request/BreakingNews.dart';
import 'package:vent_news/data/model/response/BreakingNewsResult.dart';
import 'package:vent_news/data/remote/NewsRemoteService.dart';

class NewsRepository extends BaseApiRepository {
  NewsRemoteService service;

  NewsRepository(this.service);

  Future<DataState<BreakingNewsResult>> fetchPaginatedBreakingNews(
      {required BreakingNews request}) {
    return getStateOf<BreakingNewsResult>(
      request: () => service.getBreakingNewsArticles(
        apiKey: request.apiKey,
        sources: request.sources,
        page: request.page,
        pageSize: request.pageSize,
      ),
    );
  }
}
