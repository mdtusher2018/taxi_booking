import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';
import 'package:taxi_booking/role/common/featured/chat/model/upload_file_response.dart';

class ChatListItem {
  final Chat chat;
  final Message message;
  final int unreadMessageCount;

  ChatListItem({
    required this.chat,
    required this.message,
    required this.unreadMessageCount,
  });

  factory ChatListItem.fromJson(Map<String, dynamic>? json) {
    return ChatListItem(
      chat: Chat.fromJson(json?['chat']),
      message: Message.fromJson(json?['message']),
      unreadMessageCount: JsonHelper.intVal(json?['unreadMessageCount']),
    );
  }
}

class Chat {
  final String id;
  final List<Participant> participants;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    required this.id,
    required this.participants,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(dynamic json) {
    return Chat(
      id: JsonHelper.stringVal(json?['_id']),
      participants:
          (json?['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e))
              .toList() ??
          [],
      status: JsonHelper.stringVal(json?['status']),
      createdAt: JsonHelper.parseDate(json?['createdAt']),
      updatedAt: JsonHelper.parseDate(json?['updatedAt']),
    );
  }
}

class Participant {
  final String id;
  final String name;
  final String email;
  final String image;
  final String user;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.user,
  });

  factory Participant.fromJson(dynamic json) {
    return Participant(
      id: JsonHelper.stringVal(json?['_id']),
      name: JsonHelper.stringVal(json?['name'], fallback: 'Unnamed User'),
      email: JsonHelper.stringVal(json?['email']),
      image: JsonHelper.stringVal(json?['image']),
      user: JsonHelper.stringVal(json?['user']),
    );
  }
}

class Message {
  final String id;
  final String text;
  final bool seen;
  final String sender;
  final String receiver;
  final String chat;
  final List<UploadedFile> imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Message({
    required this.id,
    required this.text,
    required this.seen,
    required this.sender,
    required this.receiver,
    required this.chat,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(dynamic json) {
    return Message(
      id: JsonHelper.stringVal(json?['_id']),
      text: JsonHelper.stringVal(json?['text']),
      seen: JsonHelper.boolVal(json?['seen']),
      sender: JsonHelper.stringVal(json?['sender']),
      receiver: JsonHelper.stringVal(json?['receiver']),
      chat: JsonHelper.stringVal(json?['chat']),
      imageUrl:
          (json?['imageUrl'] as List<dynamic>?)
              ?.map((e) => UploadedFile.fromJson(e))
              .toList() ??
          [],
      createdAt: JsonHelper.parseDate(json?['createdAt']),
      updatedAt: JsonHelper.parseDate(json?['updatedAt']),
    );
  }
}
