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
      id: json['_id'],
      text: json['text'],
      sender: json['sender'],
      receiver: json['receiver'],
      seen: json['seen'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ReceiverUser {
  final String id;
  final String name;
  final String email;
  final String image;
  final bool isOnline;
  final String status;

  ReceiverUser({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.isOnline,
    required this.status,
  });

  factory ReceiverUser.fromJson(Map<String, dynamic> json) {
    return ReceiverUser(
      id: json['_id'],
      name: json['fullName'] ?? "Unnamed User",
      email: json['email'] ?? "",
      image: json['identityUploads']?['selfie'] ?? "",
      isOnline: json['isOnline'] ?? false,
      status: json['status'] ?? '',
    );
  }
}
