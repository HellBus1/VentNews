import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:vent_news/feature/home/cubits/article/ArticlesCubit.dart';
import 'package:vent_news/feature/home/cubits/article/ArticlesState.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesCubit, ArticlesState>(
      builder: (_, state) {
        switch (state.runtimeType) {
          case ArticlesLoading:
            return const Center(child: CupertinoActivityIndicator());
          case ArticlesFailed:
            return const Center(child: Icon(Icons.refresh));
          case ArticlesSuccess:
            return Scaffold(
              body: _buildArticles(
                state.articles,
                state.noMoreData,
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  _buildArticles(
    List<Article> articles,
    bool noMoreData,
  ) {
    return CustomScrollView(
      // controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var data = articles[index];
              return Container(
                child: Column(
                  children: [
                    Text(data.title),
                    Text(data.description),
                  ],
                ),
              );
            },
            childCount: articles.length,
          ),
        ),
        if (!noMoreData)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 14, bottom: 32),
              child: CupertinoActivityIndicator(),
            ),
          )
      ],
    );
  }
}
