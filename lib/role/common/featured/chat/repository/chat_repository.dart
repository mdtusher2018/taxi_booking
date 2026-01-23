import 'dart:async';
import 'dart:io';

import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/repository.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/services/network/i_api_service.dart';
import 'package:taxi_booking/core/services/socket/socket_events.dart';
import 'package:taxi_booking/core/services/socket/socket_service.dart';
import 'package:taxi_booking/core/utilitis/common_api_endpoints.dart';
import 'package:taxi_booking/role/common/featured/chat/model/chat_list_item_model.dart';
import 'package:taxi_booking/role/common/featured/chat/model/message_response_model.dart';
import 'package:taxi_booking/role/common/featured/chat/model/upload_file_response.dart';

class ChatRepository extends Repository {
  final SocketService socketService;
  final IApiService apiService;
  ChatRepository({required this.socketService, required this.apiService});
  //Chat List
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

  //Message
  void sendMessage({
    required String reciverId,
    String? text,
    List<File>? files,
  }) async {
    List<String>? imageUrls;
    if (files != null) {
      final result = await uploadFile(files: files);
      if (result is Success) {
        imageUrls = (result as Success).data as List<String>;
      }
    }

    await socketService.emit(SocketEvents.sendMessage, {
      "receiver": reciverId,
      "text": text,
      if (imageUrls != null) 'imageUrl': imageUrls,
    });
  }

  Stream<ChatMessage> listenNewMessage() {
    final controller = StreamController<ChatMessage>();
    socketService.on(SocketEvents.newMessage, (data) {
      AppLogger.i(data.toString());
      if (data != null) {
        final chat = ChatMessage.fromJson(data);
        controller.add(chat);
      }
    });
    return controller.stream;
  }

  void closeListiningNewMessage() {
    socketService.off(SocketEvents.newMessage);
  }

  Future<Result<PreviousMessageResponse, Failure>> loadPriviousChat(
    String receiverId,
  ) async {
    return asyncGuard<PreviousMessageResponse>(() async {
      final res = await apiService.get(
        CommonApiEndPoints.previousMessage(receiverId),
      );
      return PreviousMessageResponse.fromJson(res);
    });
  }

  Future<Result<List<String>, Failure>> uploadFile({
    required List<File> files,
    String? text,
  }) async {
    return asyncGuard<List<String>>(() async {
      final res = await apiService.multipartMulti(
        CommonApiEndPoints.uploadFile,
        files: {'file': files},
      );
      final uploadResponse = UploadFileResponse.fromJson(res);
      final urls = uploadResponse.data.file.map((e) => e.url).toList();
      return urls;
    });
  }
}
