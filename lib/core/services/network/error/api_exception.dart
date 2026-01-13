import 'package:flutter/foundation.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException(this.statusCode, this.message, {this.data});

  @override
  String toString() =>
      (kDebugMode) ? "Api Exception -$statusCode: $message" : message;
}
