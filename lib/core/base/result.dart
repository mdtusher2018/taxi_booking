abstract class Result<T, E> {
  const Result();
}

class Success<T, E> extends Result<T, E> {
  final T data;

  const Success(this.data);
}

class FailureResult<T, E> extends Result<T, E> {
  final E error;

  const FailureResult(this.error);
}
