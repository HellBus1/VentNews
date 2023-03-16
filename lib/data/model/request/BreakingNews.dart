import 'package:vent_news/utils/constans/nums.dart';

class BreakingNews {
  final String apiKey;
  final String sources;
  final int page;
  final int pageSize;

  BreakingNews({
    this.apiKey = "",
    this.sources = 'bbc-news, abc-news',
    this.page = 1,
    this.pageSize = defaultPageSize,
  });
}
