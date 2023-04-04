import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vent_news/data/model/response/Article.dart';
import 'package:vent_news/feature/home/cubits/ArticlesCubit.dart';
import 'package:vent_news/feature/home/cubits/ArticlesState.dart';
import 'package:vent_news/feature/home/widgets/tile/NewsTile.dart';
import 'package:vent_news/feature/widgets/CustomScaffold.dart';
import 'package:vent_news/utils/extensions/scroll_controller.dart';

class HomePage extends HookWidget {
  const HomePage({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articleCubit = BlocProvider.of<ArticlesCubit>(context);
    final scrollController = useScrollController();

    useEffect(() {
      scrollListener() {
        if (scrollController.offset >= scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          articleCubit.getBreakingNewsArticles();
        }
      }

      scrollController.addListener(scrollListener);

      return () {
        scrollController.removeListener(scrollListener);
      };
    }, const []);

    return BlocBuilder<ArticlesCubit, ArticlesState>(
      builder: (_, state) {
        switch (state.runtimeType) {
          case ArticlesLoading:
            return const Center(child: CupertinoActivityIndicator());
          case ArticlesFailed:
            return const Center(child: Icon(Icons.refresh));
          case ArticlesSuccess:
            return CustomScaffold(
              body: _buildArticles(
                  scrollController,
                  state.articles,
                  state.noMoreData,
                )
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
        SliverPadding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var data = articles[index];
                if (index.isEven) {
                  return NewsTile(article: data, onTap: () {});
                }

                if (index != articles.length - 1) {
                  return const Divider();
                }
              },
              childCount: articles.length,
            ),
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
