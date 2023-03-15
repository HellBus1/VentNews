import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vent_news/commons/constans/strings.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:vent_news/data/model/response/BreakingNewsResult.dart';

part 'NewsRemoteService.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class NewsRemoteService {
  factory NewsRemoteService(Dio dio, {String baseUrl}) = _NewsRemoteService;

  @GET('/top-headlines')
  Future<HttpResponse<BreakingNewsResult>> getBreakingNewsArticles({
    @Query("apiKey") String? apiKey,
    @Query("sources") String? sources,
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  });
}
