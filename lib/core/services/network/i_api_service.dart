// lib/core/network/iapi_service.dart
import 'dart:io';

abstract class IApiService {
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    bool fullUrl = false,
  });

  Future<dynamic> post(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    bool fullUrl = false,
  });

  Future<dynamic> put(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    bool fullUrl = false,
  });

  Future<dynamic> patch(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    bool fullUrl = false,
  });

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    bool fullUrl = false,
  });

  Future<dynamic> multipart(
    String endpoint, {
    String method = 'POST',
    Map<String, File>? files,
    dynamic body,
    String bodyFieldName = 'data',
    Map<String, String>? headers,
    bool fullUrl = false,
  });
}
