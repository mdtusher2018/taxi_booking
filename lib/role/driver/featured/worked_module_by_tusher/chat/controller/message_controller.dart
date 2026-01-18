import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/model/message_response_model.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/repository/chat_repository.dart';

part 'message_controller.g.dart';

class MessageState {
  final List<ChatMessage> messages;
  final ReceiverUser? receiver;
  final bool loading;

  const MessageState({
    this.messages = const [],
    this.receiver,
    this.loading = true,
  });

  MessageState copyWith({
    List<ChatMessage>? messages,
    ReceiverUser? receiver,
    bool? loading,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      receiver: receiver ?? this.receiver,
      loading: loading ?? this.loading,
    );
  }
}

@Riverpod(keepAlive: false)
class MessageController extends _$MessageController {
  late ChatRepository repository;
  // ignore: unused_field
  StreamSubscription? _msgSub;
  // ignore: unused_field
  StreamSubscription? _receiverSub;

  @override
  MessageState build() {
    repository = ref.read(chatRepositoryProvider);
    return const MessageState();
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
