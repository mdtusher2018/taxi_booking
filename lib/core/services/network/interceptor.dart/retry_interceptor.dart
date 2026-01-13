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
  void onError(DioError err, ErrorInterceptorHandler handler) async {
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
      return handler.next(e as DioError);
    }
  }

  bool _shouldRetry(DioError err) {
    // retry on timeouts and other network errors, not on 4xx server errors
    return err.type == DioErrorType.connectionTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.unknown; // unknown often means network
  }
}
