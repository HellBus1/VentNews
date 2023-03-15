import 'package:vent_news/commons/constans/nums.dart';
import 'package:vent_news/commons/constans/strings.dart';

class BreakingNews {
  final String apiKey;
  final String sources;
  final int page;
  final int pageSize;

  BreakingNews({
    this.apiKey = defaultApiKey,
    this.sources = 'bbc-news, abc-news',
    this.page = 1,
    this.pageSize = defaultPageSize,
  });
}
