import 'package:dio/dio.dart';

import '../../../logger/log_helper.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.i(
      '➡️ Request: [${options.method}] ${options.uri} \nHeaders: ${options.headers} \nData: ${options.data}',
      tag: 'DIO',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i(
      '✅ Response: [${response.statusCode}] ${response.requestOptions.uri} \nData: ${response.data}',
      tag: 'DIO',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '❌ Error: [${err.response?.statusCode}] ${err.requestOptions.uri} \nMessage: ${err.response}',
      tag: 'DIO',
    );
    handler.next(err);
  }
}
