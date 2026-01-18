import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/chat/model/user_chat_list_item_model.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/chat/model/user_message_response_model.dart';

final userChatRepositoryProvider = Provider<UserChatRepository>(
  (ref) => UserChatRepository(socketService: ref.read(socketServiceProvider)),
);

class UserChatRepository extends Repository {
  final SocketService socketService;
  UserChatRepository({required this.socketService});

  Stream<List<UserChatListItem>> getChatListStream(String userId) {
    final controller = StreamController<List<UserChatListItem>>();
    socketService.on(SocketEvents.myChatListListen(userId), (data) {
      if (data != null && data is List) {
        final chats = data.map((e) => UserChatListItem.fromJson(e)).toList();
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

  final _messagesController =
      StreamController<List<UserChatMessage>>.broadcast();

  final _receiverController = StreamController<ReceiverUser>.broadcast();

  void getChatByReceiverId(String receiverId) {
    socketService.on(SocketEvents.previousMessage, (data) {
      if (data != null) {
        final list = (data as List)
            .map((e) => UserChatMessage.fromJson(e))
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

    socketService.emit(SocketEvents.getChatByReciverId, {
      "receiverId": receiverId,
    });
  }

  Stream<List<UserChatMessage>> messagesStream() => _messagesController.stream;

  Stream<ReceiverUser> receiverStream() => _receiverController.stream;

  void sendTyping({required String chatId}) {}
  void markSeen({required String chatId}) {}
}
