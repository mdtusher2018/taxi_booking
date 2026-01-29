import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';

class ChatMessage {
  final String id;
  final String text;
  final List<MessageImage> imageUrl;
  final String sender;
  final String receiver;
  final DateTime? createdAt;
  final bool seen;

  ChatMessage({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.seen,
  });

  factory ChatMessage.fromJson(dynamic json) {
    return ChatMessage(
      id: JsonHelper.stringVal(json?['_id']),
      text: JsonHelper.stringVal(json?['text']),
      sender: JsonHelper.stringVal(json?['sender']),
      receiver: JsonHelper.stringVal(json?['receiver']),
      seen: JsonHelper.boolVal(json?['seen']),
      imageUrl:
          (json?['imageUrl'] as List<dynamic>?)
              ?.map((e) => MessageImage.fromJson(e))
              .toList() ??
          [],
      createdAt: JsonHelper.parseDate(json?['createdAt']),
    );
  }
}

class ReceiverUser {
  final String id;
  final String role;
  final User user;
  final bool isOnline;

  ReceiverUser({
    required this.id,
    required this.role,
    required this.user,
    required this.isOnline,
  });

  factory ReceiverUser.fromJson(dynamic json) {
    return ReceiverUser(
      id: JsonHelper.stringVal(json?['_id']),
      role: JsonHelper.stringVal(json?['role']),
      user: User.fromJson(json?['user']),
      isOnline: JsonHelper.boolVal(json?['isOnline']),
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String identityUploads;

  User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.identityUploads,
  });

  factory User.fromJson(dynamic json) {
    return User(
      id: JsonHelper.stringVal(json?['_id']),
      fullName: JsonHelper.stringVal(
        json?['fullName'],
        fallback: 'Unnamed User',
      ),
      phone: JsonHelper.stringVal(json?['phone']),
      email: JsonHelper.stringVal(json?['email']),
      identityUploads: JsonHelper.stringVal(
        json?['identityUploads']?['selfie'],
      ),
    );
  }
}

class PreviousMessageResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<ChatMessage> data;
  final ReceiverUser receiverUser;

  PreviousMessageResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.receiverUser,
  });

  factory PreviousMessageResponse.fromJson(dynamic json) {
    return PreviousMessageResponse(
      success: JsonHelper.boolVal(json?['success']),
      statusCode: JsonHelper.intVal(json?['statusCode']),
      message: JsonHelper.stringVal(json?['message']),
      receiverUser: ReceiverUser.fromJson(json?['data']?['receiverDetails']),
      data:
          (json?['data']?['result'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MessageImage {
  final String key;
  final String url;

  MessageImage({required this.key, required this.url});

  factory MessageImage.fromJson(dynamic json) {
    return MessageImage(
      key: JsonHelper.stringVal(json?['key']),
      url: JsonHelper.stringVal(json?['url']),
    );
  }
}
