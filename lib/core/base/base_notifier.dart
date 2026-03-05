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
      errorMessage.value = e.toString();
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
}
