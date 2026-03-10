import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:taxi_booking/core/services/network/error/api_exception.dart';
import 'package:taxi_booking/core/services/snackbar/i_snackbar_service.dart';

abstract class BaseNotifier<T> extends StateNotifier<T> {
  BaseNotifier(super.state, {required this.snackBarService});

  final ISnackBarService snackBarService;
  // Reactive fields for UI listening
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<R?> safeCall<R>({
    required Future<R> Function() task,
    String? successMessage,
    bool showErrorSnack = true,
    bool showSuccessSnack = false,
    void Function()? onStart,
    void Function()? onComplete,
    Function(int, String)? handleErrorExplicitly,
    bool showLoading = true,
  }) async {
    try {
      onStart?.call();
      if (showLoading) isLoading.value = true;
      errorMessage.value = null;

      final result = await task();

      if (showSuccessSnack && successMessage != null) {
        snackBarService.showSuccess(successMessage);
      }

      return result;
    } catch (e, stack) {
      debugPrint("❌ Exception: $e\n$stack");
      // ✅ Convert to user-friendly message
      final friendlyMessage = _toFriendlyMessage(e);
      errorMessage.value = friendlyMessage;

      if (handleErrorExplicitly != null && e is ApiException) {
        handleErrorExplicitly(e.statusCode, e.message);
        return null;
      }
      if (showErrorSnack) {
        snackBarService.showError(errorMessage.value ?? "Something went wrong");
      }

      return null;
    } finally {
      isLoading.value = false;
      onComplete?.call();
    }
  }

  // ✅ Centralized friendly message mapper
  String _toFriendlyMessage(Object e) {
    if (e is ApiException) {
      return switch (e.statusCode) {
        400 => 'Invalid request. Please check your input.',
        401 => 'Session expired. Please log in again.',
        403 => 'You don\'t have permission to do this.',
        404 => 'Resource not found.',
        408 => 'Request timed out. Try again.',
        409 => 'Conflict. This action could not be completed.',
        422 => 'Invalid data submitted.',
        429 => 'Too many requests. Please slow down.',
        500 => 'Server error. Please try again later.',
        503 => 'Service unavailable. Try again later.',
        _ => e.message.isNotEmpty ? e.message : 'Something went wrong.',
      };
    }

    final message = e.toString().toLowerCase();

    if (message.contains('socketexception') || message.contains('network')) {
      return 'No internet connection.';
    }
    if (message.contains('timeout')) {
      return 'Connection timed out. Try again.';
    }
    if (message.contains('formatexception')) {
      return 'Unexpected response from server.';
    }

    return 'Something went wrong. Please try again.';
  }
}
