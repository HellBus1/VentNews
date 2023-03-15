import 'package:dio/dio.dart';
import 'package:vent_news/commons/resources/DataState.dart';
import 'package:vent_news/data/base/BaseApiRepository.dart';
import 'package:vent_news/data/model/request/BreakingNews.dart';
import 'package:vent_news/data/model/response/BreakingNewsResult.dart';
import 'package:vent_news/data/remote/NewsRemoteService.dart';

class NewsRepository extends BaseApiRepository {
  NewsRemoteService service;

  NewsRepository(this.service);

  Stream<DataState<BreakingNewsResult>> fetchPaginatedGameList(
      {required BreakingNews request}) async* {
    try {
      final response = await service.getBreakingNewsArticles(
        apiKey: request.apiKey,
        sources: request.sources,
        page: request.page,
        pageSize: request.pageSize,
      );

      yield DataSuccess(response.data);
    } on DioError catch (e) {
      yield DataFailed(e);
    } on Exception catch (e) {
      yield DataFailed(e);
    }
  }
}
