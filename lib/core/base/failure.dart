import 'package:dio/dio.dart';

import '../logger/log_helper.dart';

enum FailureType { timeout, unauthorized, network, unknown }

class Failure {
  final FailureType type;
  final String message;
  String? code;
  StackTrace? stackTrace;
  Failure({
    required this.type,
    required this.message,
    String? code,
    StackTrace? stackTrace,
  });

  factory Failure.mapExceptionToFailure(Object e) {
    if (e is DioException) {
      final parsed = _parseError(e.response);
      final message = parsed?.message;
      final code = parsed?.code;

      // Timeout
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Failure(
          type: FailureType.timeout,
          message:
              message ??
              'The request timed out. Please try again or check your connection.',
        );
      }

      // Network error
      if (e.type == DioExceptionType.connectionError) {
        return Failure(
          type: FailureType.network,
          message:
              message ??
              'Unable to connect to the server. Please check your internet connection.',
          code: code,
        );
      }

      // Unauthorized (401)
      if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == 401) {
        return Failure(
          type: FailureType.unauthorized,
          message: 'Unauthorized request. Please login again.',
          code: code,
        );
      }

      // Unknown Dio error
      return Failure(
        type: FailureType.unknown,
        message: message ?? 'Something went wrong.',
        code: code,
      );
    } else if (e is CustomException) {
      if (e is UnauthorizedException) {
        return Failure(type: FailureType.unauthorized, message: e.message);
      }
      return Failure(type: FailureType.unknown, message: e.message);
    } else {
      return Failure(type: FailureType.unknown, message: e.toString());
    }
  }

  static ({String message, String? code})? _parseError(Response? response) {
    if (response == null) return null;

    try {
      if (response.data is Map<String, dynamic>) {
        String message;
        final errorMap = response.data;

        if (errorMap['message'] is Map<String, dynamic>) {
          final messageMap = errorMap['message'] as Map<String, dynamic>;
          message = messageMap.values.join(' ');
        } else {
          message = errorMap['message']?.toString() ?? 'Something went wrong';
        }

        return (message: message, code: errorMap['statusCode']?.toString());
      }
    } catch (e, stackTrace) {
      AppLogger.e(e.toString());
      AppLogger.e(stackTrace.toString());

      return null;
    }

    return null;
  }
}

abstract class CustomException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const CustomException(this.message, {this.stackTrace});
}

// Unauthorized
class UnauthorizedException extends CustomException {
  final String? requiredPermission;

  const UnauthorizedException(
    super.message, {
    this.requiredPermission,
    super.stackTrace,
  });
}

// Not Found
class NotFoundException extends CustomException {
  final Object? originalError;

  const NotFoundException(
    super.message, {
    this.originalError,
    super.stackTrace,
  });
}
