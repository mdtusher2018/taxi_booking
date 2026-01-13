import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';

abstract class Repository<T> {
  // ignore: avoid_shadowing_type_parameters
  Future<Result<T, Failure>> asyncGuard<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Success(result);
    } on Exception catch (e, stackTrace) {
      AppLogger.e(e.toString());
      AppLogger.e(stackTrace.toString());

      return FailureResult(Failure.mapExceptionToFailure(e));
    }
  }

  Result<T, Failure> guard(T Function() operation) {
    try {
      final result = operation();
      return Success(result);
    } on Exception catch (e) {
      return FailureResult(Failure.mapExceptionToFailure(e));
    }
  }
}
