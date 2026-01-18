import 'dart:async';

import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/model/chat_list_item_model.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/model/message_response_model.dart';

class ChatRepository extends Repository {
  final SocketService socketService;
  ChatRepository({required this.socketService});

  Stream<List<ChatListItem>> getChatListStream(String userId) {
    final controller = StreamController<List<ChatListItem>>();
    socketService.on(SocketEvents.myChatListListen(userId), (data) {
      if (data != null && data is List) {
        final chats = data.map((e) => ChatListItem.fromJson(e)).toList();
        controller.add(chats);
      }
    });

    socketService.emit(SocketEvents.myChatListEmit, {});

    return controller.stream;
  }

  void sendMessage({required String reciverId, required String text}) {
    socketService.emit(SocketEvents.sendMessage, {
      "receiver": reciverId,
      "text": text,
    });
  }

  final _messagesController = StreamController<List<ChatMessage>>.broadcast();

  final _receiverController = StreamController<ReceiverUser>.broadcast();

  void getChatByReceiverId(String receiverId) {
    socketService.on(SocketEvents.previousMessage, (data) {
      if (data != null) {
        final list = (data as List)
            .map((e) => ChatMessage.fromJson(e))
            .toList();

        _messagesController.add(list);
      }
    });

    socketService.on(SocketEvents.receiverDetails, (data) {
      if (data != null) {
        final user = ReceiverUser.fromJson(data);
        _receiverController.add(user);
      }
    });

    //bad code
    socketService.on(SocketEvents.newMessage, (data) {
      if (data != null) {
        socketService.emit(SocketEvents.getChatByReciverId, {
          "receiverId": receiverId,
        });
      }
    });

    socketService.emit(SocketEvents.getChatByReciverId, {
      "receiverId": receiverId,
    });
  }

  Stream<List<ChatMessage>> messagesStream() => _messagesController.stream;

  Stream<ReceiverUser> receiverStream() => _receiverController.stream;

  void sendTyping({required String chatId}) {}
  void markSeen({required String chatId}) {}
}
