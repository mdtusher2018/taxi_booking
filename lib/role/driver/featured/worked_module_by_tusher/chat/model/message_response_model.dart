class ChatMessage {
  final String id;
  final String text;
  final String sender;
  final String receiver;
  final DateTime createdAt;
  final bool seen;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.seen,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      sender: json['sender'] ?? '',
      receiver: json['receiver'] ?? '',
      seen: json['seen'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
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

  factory ReceiverUser.fromJson(Map<String, dynamic> json) {
    return ReceiverUser(
      id: json['_id'] ?? '',
      role: json['role'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      isOnline: json['isOnline'] ?? false,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? 'Unnamed User',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      identityUploads: json['identityUploads']?['selfie'] ?? '',
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

  factory PreviousMessageResponse.fromJson(Map<String, dynamic> json) {
    return PreviousMessageResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      receiverUser: ReceiverUser.fromJson(
        json['data']?['receiverDetails'] ?? {},
      ),
      data:
          (json['data']['result'] as List?)
              ?.map((item) => ChatMessage.fromJson(item))
              .toList() ??
          [],
    );
  }
}
