import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/model/chat_list_item_model.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/repository/chat_repository.dart';

part 'chat_list_controller.g.dart';

class ChatListState {
  final List<ChatListItem> chats;
  final bool isLoading;
  final String? error;

  const ChatListState({
    this.chats = const [],
    this.isLoading = false,
    this.error,
  });

  ChatListState copyWith({
    List<ChatListItem>? chats,
    bool? isLoading,
    String? error,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

@Riverpod(keepAlive: true)
class ChatListController extends _$ChatListController {
  late ChatRepository repository;

  StreamSubscription? _chatListSub;

  @override
  ChatListState build() {
    repository = ref.read(chatRepositoryProvider);

    return const ChatListState(isLoading: true);
  }

  void getAllChatList(String userId) {
    _chatListSub?.cancel();

    _chatListSub = repository
        .getChatListStream(userId)
        .listen(
          (incomingChats) {
            final map = {for (final c in state.chats) c.chat.id: c};
            for (final chat in incomingChats) {
              map[chat.chat.id] = chat;
            }
            final merged = map.values.toList()
              ..sort((a, b) => b.chat.id.compareTo(a.chat.id));

            state = state.copyWith(chats: merged);
          },
          onError: (e) {
            state = state.copyWith(error: e.toString());
          },
        );
    state = state.copyWith(isLoading: false);
  }

  /// 📤 Send message
  void sendMessage({required String reciverId, required String text}) {
    if (text.isEmpty) {
      CustomToast.showToast(message: "massage cannot be empty");
      return;
    }
    repository.sendMessage(reciverId: reciverId, text: text);
  }
}
