import 'dart:async';
import 'package:dio/dio.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final int baseDelayMs;

  RetryOnConnectionChangeInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelayMs = 500,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final shouldRetry = _shouldRetry(err);

    if (!shouldRetry) {
      return handler.next(err);
    }

    int retryCount = req.extra['retry_count'] ?? 0;

    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    retryCount++;
    req.extra['retry_count'] = retryCount;

    final delay = baseDelayMs * (1 << (retryCount - 1)); // exponential
    await Future.delayed(Duration(milliseconds: delay));

    try {
      final response = await dio.fetch(req);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(e as DioException);
    }
  }

  bool _shouldRetry(DioException err) {
    final data = err.requestOptions.data;

    // 🚫 Do NOT retry multipart/form-data
    if (data is FormData) return false;
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.unknown;
  }
}
