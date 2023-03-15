import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vent_news/commons/resources/DataState.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/data/model/request/BreakingNews.dart';

import '../../../data/model/response/BreakingNewsResult.dart';

class HomePageProvider extends ChangeNotifier {
  final NewsRepository repository;

  HomePageProvider(this.repository);

  final StreamController<DataState<BreakingNewsResult>>
      _gameListStreamController =
      StreamController<DataState<BreakingNewsResult>>();

  Stream<DataState<BreakingNewsResult>> get gameListStream =>
      _gameListStreamController.stream;

  getNotePaginatedStream() async {
    try {
      final noteList =
          repository.fetchPaginatedGameList(request: BreakingNews());
      await for (final response in noteList) {
        _gameListStreamController.add(response);
      }
    } on Exception catch (e) {
      _gameListStreamController.add(DataFailed(e));
    }
  }

  sum(int a, int b) {
    return a + b;
  }

  @override
  void dispose() {
    _gameListStreamController.close();
    super.dispose();
  }
}
