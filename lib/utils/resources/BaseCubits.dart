import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<S, T> extends Cubit<S> {
  BaseCubit(S initialState, this._data) : super(initialState);

  T _data;

  @protected
  T get data => _data;

  bool isBusy = false;

  @protected
  Future<void> run(Future<void> Function() process) async {
    if (!isBusy) {
      isBusy = true;
      await process();
      isBusy = false;
    }
  }
}
