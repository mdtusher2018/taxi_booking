import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/chat/model/user_chat_list_item_model.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/chat/repository/chat_repository.dart';

part 'chat_list_controller.g.dart';

class UserChatListState {
  final List<UserChatListItem> chats;
  final bool isLoading;
  final String? error;

  const UserChatListState({
    this.chats = const [],
    this.isLoading = false,
    this.error,
  });

  UserChatListState copyWith({
    List<UserChatListItem>? chats,
    bool? isLoading,
    String? error,
  }) {
    return UserChatListState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

@Riverpod(keepAlive: true)
class UserChatListController extends _$UserChatListController {
  late UserChatRepository repository;

  StreamSubscription? _chatListSub;

  @override
  UserChatListState build() {
    repository = ref.read(userChatRepositoryProvider);

    return const UserChatListState(isLoading: true);
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

  /// ✍ Typing indicator
  void sendTyping({required String chatId}) {
    repository.sendTyping(chatId: chatId);
  }

  /// 👀 Seen
  void markSeen(String chatId) {
    repository.markSeen(chatId: chatId);
  }
}
