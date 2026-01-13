// lib/core/services/snackbar/snackbar_service.dart
import 'package:flutter/material.dart';
import 'i_snackbar_service.dart';

final class SnackBarService implements ISnackBarService {
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get messengerKey => _messengerKey;

  @override
  void showError(String message, {required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );

    // _messengerKey.currentState?.showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     backgroundColor: Colors.red,
    //     duration: const Duration(seconds: 3),
    //   ),
    // );
  }

  @override
  void showSuccess(String message, {required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
