import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vent_news/commons/resources/DataState.dart';
import 'package:vent_news/feature/home/provider/HomePageProvider.dart';

import '../../data/model/response/BreakingNewsResult.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageProvider>(
      builder: (context, value, child) {
        value.getNotePaginatedStream();
        return StreamBuilder<DataState<BreakingNewsResult>>(
            stream: value.gameListStream,
            builder: (context, snapshot) {
              return Scaffold(
                body: renderBodyAfterSnapshot(snapshot),
              );
            });
      },
    );
  }

  renderBodyAfterSnapshot(snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data is DataFailed) {
        final error = (snapshot.data as DataFailed).error;
        return Text('Error: $error');
      } else if (snapshot.data is DataSuccess) {
        final result = snapshot.data?.data;
        final articles = result?.articles ?? [];
        // Render the game list using `gameList`.
        return ListView.builder(
          itemCount: result?.totalResults,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(articles[index].title),
              subtitle: Text(articles[index].description),
            );
          },
        );
      }
    }

    // By default, show a loading indicator.
    return CircularProgressIndicator();
  }
}
