import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/feature/home/provider/HomePageProvider.dart';

import 'HomePageProviderShould.mocks.dart';

@GenerateMocks([NewsRepository])
void main() {
  late HomePageProvider provider;
  late MockNewsRepository repository;

  setUp(() {
    repository = MockNewsRepository();
    provider = HomePageProvider(repository);
  });

  // mockSuccessfulCase() async {
  //   when(repository.fetchPaginatedGameList())
  //       .thenAnswer((_) => Stream.value());
  // }

  group('homePageProviderShould', () {
    test('get paginated game list from repository', () async {
      // mockSuccessfulCase();

      final resultStream = provider.getNotePaginatedStream();
      // Listen to the result stream to trigger the repository call
      await resultStream.toList();

      // verify(repository.fetchPaginatedGameList()).called(1);
    });
  });
}
