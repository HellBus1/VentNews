import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/data/remote/NewsRemoteService.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  final dio = Dio();
  // dio.interceptors.add(AwesomeDioInterceptor());

  locator.registerSingleton<Dio>(dio);

  locator.registerSingleton<NewsRemoteService>(
    NewsRemoteService(locator<Dio>()),
  );

  locator.registerSingleton<NewsRepository>(
    NewsRepository(locator<NewsRemoteService>()),
  );
}
