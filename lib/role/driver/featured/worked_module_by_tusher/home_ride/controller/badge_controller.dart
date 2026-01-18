import 'package:flutter_riverpod/legacy.dart';

/// Provider
final chatBadgeControllerProvider =
    StateNotifierProvider<ChatBadgeController, bool>(
      (ref) => ChatBadgeController(),
    );

/// Controller
class ChatBadgeController extends StateNotifier<bool> {
  ChatBadgeController() : super(false); // false = no badge

  void showBadge() {
    state = true;
  }

  void clearBadge() {
    state = false;
  }
}
