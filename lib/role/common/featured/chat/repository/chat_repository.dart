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
        final chatJson = (data[0] as List)[0];
        AppLogger.w("=============>>>>>>>>>" + chatJson.toString());
        final chats = ChatListItem.fromJson(chatJson);
        controller.add([chats]);
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
    List<UploadedFile>? imageUrls;
    if (files != null && files.isNotEmpty) {
      final result = await uploadFile(files: files);
      if (result is Success) {
        imageUrls = (result as Success).data as List<UploadedFile>;
      }
    }

    await socketService.emit(SocketEvents.sendMessage, {
      "receiver": reciverId,
      "text": text,
      if (imageUrls != null)
        "imageUrl": imageUrls.map((e) => e.toJson()).toList(),
    });
  }

  Stream<ChatMessage> listenNewMessage() {
    final controller = StreamController<ChatMessage>();
    socketService.on(SocketEvents.newMessage, (data) {
      AppLogger.i(data.toString());
      if (data != null) {
        final chat = ChatMessage.fromJson(data[0]);
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

  Future<Result<List<UploadedFile>, Failure>> uploadFile({
    required List<File> files,
    String? text,
  }) async {
    return asyncGuard<List<UploadedFile>>(() async {
      final res = await apiService.multipartMulti(
        CommonApiEndPoints.uploadFile,
        files: {'file': files},
      );

      final uploadResponse = UploadFileResponse.fromJson(res);

      return uploadResponse.data.file;
    });
  }
}
