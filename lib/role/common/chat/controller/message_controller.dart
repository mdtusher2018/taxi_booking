import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/common/chat/model/message_response_model.dart';
import 'package:taxi_booking/role/common/chat/repository/chat_repository.dart';
import 'package:taxi_booking/role/common/di/repository.dart';

part 'message_controller.g.dart';

class MessageState {
  final List<ChatMessage> messages;
  final ReceiverUser? receiver;
  final bool loading;
  final String? errorMessage;

  const MessageState({
    this.messages = const [],
    this.receiver,
    this.loading = true,
    this.errorMessage,
  });

  MessageState copyWith({
    List<ChatMessage>? messages,
    ReceiverUser? receiver,
    bool? loading,
    String? errorMessage,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      receiver: receiver ?? this.receiver,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class MessageController extends _$MessageController {
  late ChatRepository repository;

  @override
  MessageState build() {
    repository = ref.read(chatRepositoryProvider);
    return const MessageState();
  }

  void loadPriviousChat(String receiverId) async {
    state = state.copyWith(loading: true);

    final result = await repository.loadPriviousChat(receiverId);

    if (result is Failure) {
      state = state.copyWith(
        loading: false,
        errorMessage: ((result as FailureResult).error as Failure).message,
      );
    } else if (result is Success) {
      state = state.copyWith(
        loading: false,
        messages: ((result as Success).data as PreviousMessageResponse).data,
        receiver:
            ((result as Success).data as PreviousMessageResponse).receiverUser,
      );
    }
  }

  void startListeningNewMessage() {
    repository.listenNewMessage().listen((charMessage) {
      state = state.copyWith(messages: [charMessage, ...state.messages]);
    });
  }

  void closeListiningNewMessage() {
    repository.closeListiningNewMessage();
  }

  void sendMessage({required String receiverId, required String text}) {
    repository.sendMessage(reciverId: receiverId, text: text);
  }
}
