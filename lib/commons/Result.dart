class Result<T> {
  final T? data;
  final Exception? error;
  final ResultType type;

  Result.success(T this.data)
      : error = null,
        type = ResultType.success;

  Result.failure(this.error)
      : data = null,
        type = ResultType.failure;
}

enum ResultType { success, failure }
