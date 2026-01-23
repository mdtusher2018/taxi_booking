// lib/core/network/api_service.dart
import 'dart:io';
import 'package:taxi_booking/core/services/network/api_client.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';

final class ApiService implements IApiService {
  final ApiClient _client;
  final String _baseUrl;

  ApiService(this._client, {required String baseUrl}) : _baseUrl = baseUrl;

  String _buildUrl(String endpoint, bool fullUrl) {
    return fullUrl ? endpoint : '$_baseUrl$endpoint';
  }

  @override
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    bool fullUrl = false,
  }) async {
    final url = _buildUrl(endpoint, fullUrl);
    return _client.get(Uri.parse(url), headers: headers);
  }

  @override
  Future<dynamic> post(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    bool fullUrl = false,
  }) async {
    final url = _buildUrl(endpoint, fullUrl);
    return _client.post(Uri.parse(url), body: body, headers: headers);
  }

  @override
  Future<dynamic> put(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    bool fullUrl = false,
  }) async {
    final url = _buildUrl(endpoint, fullUrl);
    return _client.put(Uri.parse(url), body: body, headers: headers);
  }

  @override
  Future<dynamic> patch(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    bool fullUrl = false,
  }) async {
    final url = _buildUrl(endpoint, fullUrl);
    return _client.patch(Uri.parse(url), body: body, headers: headers);
  }

  @override
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    bool fullUrl = false,
  }) async {
    final url = _buildUrl(endpoint, fullUrl);
    return _client.delete(Uri.parse(url), body: body, headers: headers);
  }

  @override
  Future<dynamic> multipart(
    String endpoint, {
    String method = 'POST',
    Map<String, File>? files,
    dynamic body,
    String bodyFieldName = 'data',
    Map<String, String>? headers,
    bool fullUrl = false,
  }) async {
    final url = _buildUrl(endpoint, fullUrl);
    return _client.sendMultipart(
      Uri.parse(url),
      method: method,
      files: files,
      body: body,
      bodyFieldName: bodyFieldName,
      headers: headers,
    );
  }

  Future<dynamic> multipartMulti(
    String endpoint, {
    String method = 'POST',
    Map<String, List<File>>? files, // 👈 multiple files
    dynamic body,
    String bodyFieldName = 'data',
    Map<String, String>? headers,
    bool fullUrl = false,
  }) async {
    final url = _buildUrl(endpoint, fullUrl);

    return _client.sendMultipartMulti(
      Uri.parse(url),
      method: method,
      files: files,
      body: body,
      bodyFieldName: bodyFieldName,
      headers: headers,
    );
  }
}
