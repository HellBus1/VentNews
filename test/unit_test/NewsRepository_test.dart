import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/data/model/request/BreakingNews.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:vent_news/data/model/response/BreakingNewsResult.dart';
import 'package:vent_news/data/remote/NewsRemoteService.dart';

import 'NewsRepository_test.mocks.dart';

@GenerateMocks([NewsRemoteService])
void main() {
  late NewsRepository repository;
  late MockNewsRemoteService service;
  late List<Article> articles;

  final mockBreakingNewsResult = BreakingNewsResult(
    status: 'ok', 
    totalResults: 2, 
    articles: [Article.fromJson({}), Article.fromJson({})],
  );

  final request = BreakingNews(
    apiKey: 'testApiKey',
    sources: 'testSources',
    page: 1,
    pageSize: 20,
  );

  setUp(() {
    service = MockNewsRemoteService();
    repository = NewsRepository(service);
  });

  // Stub successful case
  mockSuccessfulCase() async {
    // Mocking successful http response
    final response = Response(
      statusCode: 200,
      statusMessage: 'OK',
      data: [
        {
            "source": {
                "id": null,
                "name": "MobileSyrup"
            },
            "author": "Ted Kritsonis",
            "title": "2023 Hyundai Ioniq 6 Hands-on: Taking on Tesla",
            "description": "Hyundai is putting a lot of stock on the Ioniq 6 as a banner electric vehicle for the company, suggesting it will be one of the industry’s best options.",
            "url": "https://mobilesyrup.com/2023/04/03/2023-hyundai-ioniq-6-hands-on-taking-on-tesla/",
            "urlToImage": "https://cdn.mobilesyrup.com/wp-content/uploads/2023/03/hyundai-ioniq-6-header-scaled.jpg",
            "publishedAt": "2023-04-03T04:01:31Z",
            "content": "Hyundai is putting a lot of stock on the Ioniq 6 as a banner electric vehicle for the company, suggesting it will roll off assembly lines as one of the industrys best options in 2023.\r\nThat could be … [+9886 chars]"
        }
      ],
      requestOptions: RequestOptions(),
    );

    when(service.getBreakingNewsArticles(
      apiKey: request.apiKey,
      sources: request.sources,
      page: request.page,
      pageSize: request.pageSize,
    )).thenAnswer((_) =>
        Future.value(HttpResponse(mockBreakingNewsResult, response)));
  }

  // Stub failure case
  mockFailureCase() async {
    // Mocking failure http response
    final response = Response(
      statusCode: 400,
      statusMessage: 'Bad Request',
      requestOptions: RequestOptions(),
    );

    when(service.getBreakingNewsArticles(
      apiKey: request.apiKey,
      sources: request.sources,
      page: request.page,
      pageSize: request.pageSize,
    )).thenAnswer((_) =>
        Future.value(HttpResponse(mockBreakingNewsResult, response)));;
  }

  group('newsRepositoryShould', () {
    test('call getBreakingNewsArticlesService', () async {
      mockSuccessfulCase();

      await repository.fetchPaginatedBreakingNews(request: request);

      verify(service.getBreakingNewsArticles(
        apiKey: request.apiKey,
        sources: request.sources,
        page: request.page,
        pageSize: request.pageSize,
      )).called(1);
    });

    test('should return expected data state', () async {
      // Arrange
      mockSuccessfulCase();

      // Act
      final result = await repository.fetchPaginatedBreakingNews(request: request);

      // Assert
      expect(result.data, mockBreakingNewsResult);
      expect(result.error, null);
    });

    test('should return error data state when service throws an exception', () async {
      // Arrange
      mockFailureCase();

      // Act
      final result = await repository.fetchPaginatedBreakingNews(request: request);

      // Assert
      expect(result.data, null);
      expect(result.error, isA<DioError>());
    });
  });
}