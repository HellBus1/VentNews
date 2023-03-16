import 'package:vent_news/commons/constans/nums.dart';
import 'package:vent_news/commons/resources/BaseCubits.dart';
import 'package:vent_news/commons/resources/DataState.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/data/model/request/BreakingNews.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:vent_news/feature/home/cubits/article/ArticlesState.dart';

class ArticlesCubit extends BaseCubit<ArticlesState, List<Article>> {
  final NewsRepository repository;

  ArticlesCubit(this.repository) : super(const ArticlesLoading(), []);

  int _page = 1;

  Future<void> getBreakingNewsArticles() async {
    if (isBusy) return;

    await run(() async {
      final response = await repository.fetchPaginatedBreakingNews(
        request: BreakingNews(page: _page),
      );

      if (response is DataSuccess) {
        final articles = response.data!.articles;
        final noMoreData = articles.length < defaultPageSize;

        data.addAll(articles);
        _page++;

        emit(ArticlesSuccess(articles: data, noMoreData: noMoreData));
      } else if (response is DataFailed) {
        emit(ArticlesFailed(error: response.error));
      }
    });
  }
}
