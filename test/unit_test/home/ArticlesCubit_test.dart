import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/data/model/request/BreakingNews.dart';
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

  late List<Article> articleDummy1;
  late List<Article> articleDummy2;
  late List<Article> articleDummies;

  late DataSuccess<BreakingNewsResult> expectedDummy1;
  late DataSuccess<BreakingNewsResult> expectedDummy2;
  late DataSuccess<BreakingNewsResult> expected;

  setUp(() {
    repository = MockNewsRepository();
    articlesCubit = ArticlesCubit(repository);

    articleDummy1 = [Article.fromJson({})];
    articleDummy2 = [Article.fromJson({})];
    articleDummies = List.from(articleDummy1)..addAll(articleDummy2);

    expectedDummy1 = DataSuccess(
      BreakingNewsResult(status: "", totalResults: 1, articles: articleDummy1)
    );
    expectedDummy2 = DataSuccess(
      BreakingNewsResult(status: "", totalResults: 1, articles: articleDummy2)
    );
    expected = DataSuccess(
        BreakingNewsResult(status: "", totalResults: 2, articles: articleDummies)
    );
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

  // Stub success case for pagination
  mockSuccessfulPaginationCase() async {
    when(repository.fetchPaginatedBreakingNews(
      request: anyNamed('request'),
    )).thenAnswer((_) async => expectedDummy1);
    
    when(repository.fetchPaginatedBreakingNews(
      request: anyNamed('request'),
    )).thenAnswer((_) async => expectedDummy2);  
  }

  // Stub isBusy case
  mockIsBusyCase() async {
    verifyNever(repository.fetchPaginatedBreakingNews(
      request: anyNamed('request'),
    ));
  }

  // Mock has no more data case
  mockHasNoMoreDataCase() async {
    const defaultPageSize = 10;

    when(repository.fetchPaginatedBreakingNews(request: anyNamed('request'))).thenAnswer((_) async => DataSuccess(
      BreakingNewsResult(
        articles: articleDummies,
        status: 'ok',
        totalResults: defaultPageSize - 1,
      )
    )); 
  }

  group('articleCubitShould', () {
    test('emits ArticlesLoading in its initial state', () {
      expect(articlesCubit.state, const ArticlesLoading());
    });

    test('call repository fetchPaginatedBreakingNews', () async {
      mockSuccessfulCase();

      await articlesCubit.getBreakingNewsArticles();

      verify(repository.fetchPaginatedBreakingNews(request: anyNamed('request'))).called(1);
    });

    test('increment page state when fetch data', () async {
      mockSuccessfulCase();

      await articlesCubit.getBreakingNewsArticles();

      expect(articlesCubit.page, 2);
    });

    test('prevent fetch data when isBusy', () async {
        // Verify that the repository.fetchPaginatedBreakingNews method was not called
        mockIsBusyCase();

        articlesCubit.isBusy = true;

        // Call getBreakingNewsArticles and verify that it returns early
        await articlesCubit.getBreakingNewsArticles();

        // Verify that no state was emitted
        expectLater(articlesCubit.stream, emitsInOrder([]));
    });

    test('set noMoreData flag correctly when response contains fewer articles', () async {
        mockHasNoMoreDataCase();

        await articlesCubit.getBreakingNewsArticles();

        // Verify that noMoreData flag is set to true
        expect(articlesCubit.state, isA<ArticlesSuccess>());
        expect((articlesCubit.state as ArticlesSuccess).noMoreData, isTrue);
    });

    blocTest<ArticlesCubit, ArticlesState>(
      'emits ArticlesSuccess when successful',
      build: () {
        mockSuccessfulCase();
        return articlesCubit;
      },
      act: (cubit) => cubit.getBreakingNewsArticles(),
      expect: () => [
        ArticlesSuccess(articles: articleDummies, noMoreData: true),
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
          (state) => state.error.toString(),
          'error',
          'Exception: Something went wrong',
        ),
      ],
    );

    blocTest<ArticlesCubit, ArticlesState>(
      'emits ArticlesSuccess with articles that consist article1 & article2 when called two times',
      build: () {
        mockSuccessfulPaginationCase();
        
        return articlesCubit;
      },
      act: (cubit) async {
        await cubit.getBreakingNewsArticles();
        await cubit.getBreakingNewsArticles();
      },
      expect: () => [
        isA<ArticlesSuccess>()
          .having((state) => state.articles.length, 'articles list',
              equals(2))
          .having((state) => state.noMoreData, 'noMoreData', equals(true))
      ],
    );
  });
}
