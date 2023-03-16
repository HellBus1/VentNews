import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:vent_news/data/model/response/BreakingNewsResult.dart';
import 'package:vent_news/feature/home/cubits/ArticlesCubit.dart';
import 'package:vent_news/feature/home/cubits/ArticlesState.dart';
import 'package:vent_news/utils/resources/DataState.dart';

import 'ArticlesCubit_test.mocks.dart';

@GenerateMocks([NewsRepository])
void main() {
  late ArticlesCubit articlesCubit;
  late MockNewsRepository repository;
  late List<Article> articles;

  late DataSuccess<BreakingNewsResult> expected;

  setUp(() {
    repository = MockNewsRepository();
    articlesCubit = ArticlesCubit(repository);
    articles = List.generate(1, (index) => Article.fromJson({}));

    expected = DataSuccess(
        BreakingNewsResult(status: "", totalResults: 1, articles: articles));
  });

  tearDown(() {
    articlesCubit.close();
  });

  // Stub success case
  mockSuccessfulCase() async {
    when(repository.fetchPaginatedBreakingNews(request: anyNamed('request')))
        .thenAnswer((_) async => expected);
  }

  // Stub error case
  mockFailureCase() async {
    when(repository.fetchPaginatedBreakingNews(request: anyNamed('request')))
        .thenAnswer((_) async => DataFailed(Exception('Something went wrong')));
  }

  group('articleCubitShould', () {
    test('initial state is ArticlesLoading', () {
      expect(articlesCubit.state, const ArticlesLoading());
    });

    blocTest<ArticlesCubit, ArticlesState>(
      'emits ArticlesSuccess when successful',
      build: () {
        mockSuccessfulCase();
        return articlesCubit;
      },
      act: (cubit) => cubit.getBreakingNewsArticles(),
      expect: () => [
        ArticlesSuccess(articles: articles, noMoreData: true),
      ],
    );

    blocTest<ArticlesCubit, ArticlesState>(
      'emits ArticlesFailed when unsuccessful',
      build: () {
        mockFailureCase();
        return articlesCubit;
      },
      act: (cubit) => cubit.getBreakingNewsArticles(),
      expect: () => [
        isA<ArticlesFailed>().having(
          (s) => s.error.toString(),
          'error',
          'Exception: Something went wrong',
        ),
      ],
    );
  });
}
