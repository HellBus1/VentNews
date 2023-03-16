import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:vent_news/feature/home/cubits/ArticlesCubit.dart';
import 'package:vent_news/feature/home/cubits/ArticlesState.dart';
import 'package:vent_news/feature/home/widgets/tile/NewsTile.dart';
import 'package:vent_news/utils/extensions/scroll_controller.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final articleCubit = BlocProvider.of<ArticlesCubit>(context);
    final scrollController = useScrollController();

    useEffect(() {
      scrollController.onScrollEndsListener(() {
        articleCubit.getBreakingNewsArticles();
      });

      return scrollController.dispose;
    }, const []);

    return BlocBuilder<ArticlesCubit, ArticlesState>(
      builder: (_, state) {
        switch (state.runtimeType) {
          case ArticlesLoading:
            return const Center(child: CupertinoActivityIndicator());
          case ArticlesFailed:
            return const Center(child: Icon(Icons.refresh));
          case ArticlesSuccess:
            return Scaffold(
              appBar: AppBar(centerTitle: true, title: Text("Vent News")),
              body: SafeArea(
                child: _buildArticles(
                  scrollController,
                  state.articles,
                  state.noMoreData,
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  _buildArticles(
    ScrollController scrollController,
    List<Article> articles,
    bool noMoreData,
  ) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var data = articles[index];
              if (index.isEven) {
                return NewsTile(article: data, onTap: () {});
              }

              return Divider();
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
