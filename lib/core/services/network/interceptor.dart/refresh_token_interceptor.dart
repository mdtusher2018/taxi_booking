// lib/core/network/interceptors/refresh_token_interceptor.dart

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:taxi_booking/core/services/network/interceptor.dart/logger_interceptor.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';
import 'package:taxi_booking/core/utilitis/driver_api_end_points.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  final ILocalStorageService storage;
  final GlobalKey<NavigatorState> navigatorKey;

  bool _isRefreshing = false;

  RefreshTokenInterceptor(this.dio, this.storage, this.navigatorKey);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;

    if (response?.statusCode != 401 || _isRefreshCall(err)) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;

    try {
      final refreshToken = await storage.readKey(StorageKey.refreshToken);

      if (refreshToken == null) {
        _logout();
        return handler.next(err);
      }

      final newAccessToken = await _refreshToken(refreshToken);

      if (newAccessToken == null) {
        _logout();
        return handler.next(err);
      }

      // retry original request ONCE
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await dio.fetch(err.requestOptions);
      handler.resolve(retryResponse);
    } catch (e) {
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  bool _isRefreshCall(DioException err) {
    return err.requestOptions.path.contains(DriverApiEndpoints.refreshToken);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final refreshDio = Dio(dio.options)
        ..interceptors.add(LoggingInterceptor());

      final res = await refreshDio.post(
        DriverApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final access = res.data['data']['accessToken'];

      if (access != null) {
        await storage.saveKey(StorageKey.accessToken, access);
      }

      return access;
    } catch (_) {
      return null;
    }
  }

  void _logout() {
    storage.clearAll();
    navigatorKey.currentContext?.go(
      DriverAppRoutes.authenticationView,
      extra: {"isLogin": true},
    );
  }
}
