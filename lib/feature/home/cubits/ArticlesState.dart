import 'package:equatable/equatable.dart';
import 'package:vent_news/data/model/response/Article.dart';

abstract class ArticlesState extends Equatable {
  final List<Article> articles;
  final bool noMoreData;
  final Exception? error;

  const ArticlesState({
    this.articles = const [],
    this.noMoreData = true,
    this.error,
  });

  @override
  List<Object?> get props => [articles, noMoreData, error];
}

class ArticlesLoading extends ArticlesState {
  const ArticlesLoading();
}

class ArticlesSuccess extends ArticlesState {
  const ArticlesSuccess({super.articles, super.noMoreData});
}

class ArticlesFailed extends ArticlesState {
  const ArticlesFailed({super.error});
}
