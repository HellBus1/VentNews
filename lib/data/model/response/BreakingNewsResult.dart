import 'Article.dart';

class BreakingNewsResult {
  final String status;
  final int totalResults;
  final List<Article> articles;

  BreakingNewsResult({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory BreakingNewsResult.fromJson(Map<String, dynamic> json) {
    return BreakingNewsResult(
      status: (json['status'] ?? '') as String,
      totalResults: (json['totalResults'] ?? 0) as int,
      articles: List<Article>.from(
        json['articles'].map<Article>(
          (x) => Article.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
