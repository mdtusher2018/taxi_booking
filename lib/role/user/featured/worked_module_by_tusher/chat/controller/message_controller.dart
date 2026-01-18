import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/chat/model/user_message_response_model.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/chat/repository/chat_repository.dart';

part 'message_controller.g.dart';

class UserMessageState {
  final List<UserChatMessage> messages;
  final ReceiverUser? receiver;
  final bool loading;

  const UserMessageState({
    this.messages = const [],
    this.receiver,
    this.loading = true,
  });

  UserMessageState copyWith({
    List<UserChatMessage>? messages,
    ReceiverUser? receiver,
    bool? loading,
  }) {
    return UserMessageState(
      messages: messages ?? this.messages,
      receiver: receiver ?? this.receiver,
      loading: loading ?? this.loading,
    );
  }
}

@Riverpod(keepAlive: false)
class UserMessageController extends _$UserMessageController {
  late UserChatRepository repository;
  // ignore: unused_field
  StreamSubscription? _msgSub;
  // ignore: unused_field
  StreamSubscription? _receiverSub;

  @override
  UserMessageState build() {
    repository = ref.read(userChatRepositoryProvider);
    return const UserMessageState();
  }

  void openChat(String receiverId) {
    repository.getChatByReceiverId(receiverId);

    _msgSub = repository.messagesStream().listen((messages) {
      state = state.copyWith(messages: messages, loading: false);
    });

    _receiverSub = repository.receiverStream().listen((user) {
      state = state.copyWith(receiver: user);
    });
  }

  void sendMessage({required String receiverId, required String text}) {
    repository.sendMessage(reciverId: receiverId, text: text);
  }
}
