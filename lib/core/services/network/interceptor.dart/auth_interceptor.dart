// lib/core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';

import '../../../logger/log_helper.dart';

class AuthInterceptor extends Interceptor {
  final ILocalStorageService _localStorage;

  AuthInterceptor(this._localStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final accessToken =
          await _localStorage.readKey(StorageKey.accessToken) as String?;

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    } catch (e, st) {
      AppLogger.e("AuthInterceptor error: $e\n$st");
    }

    return handler.next(options);
  }
}
