// lib/core/network/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:taxi_booking/core/services/network/error/api_exception.dart';
import 'package:taxi_booking/core/services/network/interceptor.dart/auth_interceptor.dart';
import 'package:taxi_booking/core/services/network/interceptor.dart/logger_interceptor.dart';
import 'package:taxi_booking/core/services/network/interceptor.dart/refresh_token_interceptor.dart';
import 'package:taxi_booking/core/services/network/interceptor.dart/retry_interceptor.dart';
import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:flutter/material.dart';

class ApiClient {
  final Dio dio;
  final ILocalStorageService localStorage;
  final GlobalKey<NavigatorState> navigatorKey;

  ApiClient({
    Dio? dio,
    required String baseUrl,
    required this.localStorage,
    required this.navigatorKey,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) : dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: connectTimeout,
               receiveTimeout: receiveTimeout,
               contentType: Headers.jsonContentType,
             ),
           ) {
    // add interceptors
    this.dio.interceptors.addAll([
      AuthInterceptor(localStorage),
      RefreshTokenInterceptor(this.dio, localStorage, navigatorKey),
      RetryOnConnectionChangeInterceptor(dio: this.dio),
      LoggingInterceptor(),
    ]);
  }

  Future<dynamic> get(Uri url, {Map<String, String>? headers}) async {
    final res = await dio.get(
      url.toString(),
      options: Options(headers: headers),
    );
    return _processResponse(res);
  }

  Future<dynamic> post(
    Uri url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final res = await dio.post(
      url.toString(),
      data: body,
      options: Options(headers: headers),
    );
    return _processResponse(res);
  }

  Future<dynamic> put(
    Uri url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final res = await dio.put(
      url.toString(),
      data: body,
      options: Options(headers: headers),
    );
    return _processResponse(res);
  }

  Future<dynamic> patch(
    Uri url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final res = await dio.patch(
      url.toString(),
      data: body,
      options: Options(headers: headers),
    );
    return _processResponse(res);
  }

  Future<dynamic> delete(
    Uri url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final res = await dio.delete(
      url.toString(),
      data: body,
      options: Options(headers: headers),
    );
    return _processResponse(res);
  }

  Future<FormData> getFromData({
    String bodyFieldName = 'data',
    Map<String, File>? files,
    dynamic body,
  }) async {
    FormData form = FormData.fromMap({bodyFieldName: jsonEncode(body)});

    if (files != null) {
      for (final e in files.entries) {
        form.files.add(
          MapEntry(
            e.key,
            await MultipartFile.fromFile(
              e.value.path,
              filename: e.value.path.split('/').last,
            ),
          ),
        );
      }
    }
    return form;
  }

  Future<dynamic> sendMultipart(
    Uri url, {
    String method = 'POST',
    Map<String, String>? headers,
    Map<String, File>? files,
    dynamic body,
    String bodyFieldName = 'data',
  }) async {
    FormData from = await getFromData(body: body, files: files);
    final res = await dio.request(
      url.toString(),
      data: from,
      options: Options(method: method, headers: headers),
    );
    return _processResponse(res);
  }

  Future<dynamic> sendMultipartMulti(
    Uri url, {
    String method = 'POST',
    Map<String, String>? headers,
    Map<String, List<File>>? files,
    dynamic body,
    String bodyFieldName = 'data',
  }) async {
    final formData = FormData.fromMap({});

    // body
    if (body != null) {
      formData.fields.add(MapEntry(bodyFieldName, jsonEncode(body)));
    }

    // multiple files under same field
    if (files != null) {
      // 🔐 Clone map entries safely
      final safeEntries = Map<String, List<File>>.fromEntries(
        files.entries.map((e) => MapEntry(e.key, List<File>.from(e.value))),
      );

      for (final entry in safeEntries.entries) {
        for (final file in entry.value) {
          formData.files.add(
            MapEntry(
              entry.key,
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }
    }

    final res = await dio.request(
      url.toString(),
      data: formData,
      options: Options(
        method: method,
        headers: {...?headers, 'Content-Type': 'multipart/form-data'},
      ),
    );

    return _processResponse(res);
  }

  dynamic _processResponse(Response r) {
    // global unauthorized handled in interceptors, but re-check
    if (r.statusCode == 401) {
      // optional fallback
    }

    final statusCode = r.statusCode ?? 0;
    final data = r.data;

    if (statusCode >= 200 && statusCode < 300) return data;

    final message = data is Map && data['message'] != null
        ? data['message'] as String
        : 'Unknown error';
    throw ApiException(statusCode, message, data: data);
  }
}
