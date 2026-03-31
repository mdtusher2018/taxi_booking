import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../logger/log_helper.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ─── Calculate Request Size ───────────────────────────────
    String sizeInfo = '';
    try {
      if (options.data is FormData) {
        final formData = options.data as FormData;

        // fields size
        int fieldsBytes = 0;
        for (final field in formData.fields) {
          fieldsBytes += utf8.encode(field.value).length;
        }

        // files size
        int filesBytes = 0;
        final fileLogs = <String>[];
        for (final file in formData.files) {
          final fileSize = file.value.length;
          filesBytes += fileSize;
          fileLogs.add('    📄 [${file.key}]: ${_formatSize(fileSize)}');
        }

        final total = fieldsBytes + filesBytes;
        sizeInfo =
            '\nRequest Size:'
            '\n    📝 Fields : ${_formatSize(fieldsBytes)}'
            '\n${fileLogs.join('\n')}'
            '\n    📦 Total  : ${_formatSize(total)}';
      } else if (options.data != null) {
        final bytes = utf8.encode(jsonEncode(options.data)).length;
        sizeInfo = '\nRequest Size: ${_formatSize(bytes)}';
      }
    } catch (_) {
      sizeInfo = '\nRequest Size: unable to calculate';
    }
    // ─────────────────────────────────────────────────────────

    AppLogger.i(
      '➡️ Request: [${options.method}] ${options.uri} '
      '\nHeaders: ${options.headers} '
      '\nData: ${options.data}'
      '$sizeInfo',
      tag: 'DIO',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ─── Calculate Response Size ──────────────────────────────
    String sizeInfo = '';
    try {
      final bytes = utf8.encode(jsonEncode(response.data)).length;
      sizeInfo = '\nResponse Size: ${_formatSize(bytes)}';
    } catch (_) {
      sizeInfo = '\nResponse Size: unable to calculate';
    }
    // ─────────────────────────────────────────────────────────

    AppLogger.i(
      '✅ Response: [${response.statusCode}] ${response.requestOptions.uri} '
      '\nData: ${response.data}'
      '$sizeInfo',
      tag: 'DIO',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '❌ Error: [${err.response?.statusCode}] ${err.requestOptions.uri} '
      '\nMessage: ${err.response}',
      tag: 'DIO',
    );
    handler.next(err);
  }

  // ─── Size Formatter ───────────────────────────────────────────
  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
