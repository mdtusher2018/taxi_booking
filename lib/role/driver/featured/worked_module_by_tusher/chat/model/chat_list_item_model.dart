class ChatListItem {
  final Chat chat;
  final Message message;
  final int unreadMessageCount;

  ChatListItem({
    required this.chat,
    required this.message,
    required this.unreadMessageCount,
  });

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      chat: Chat.fromJson(json['chat']),
      message: Message.fromJson(json['message']),
      unreadMessageCount: json['unreadMessageCount'] ?? 0,
    );
  }
}

class Chat {
  final String id;
  final List<Participant> participants;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.participants,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      participants: (json['participants'] as List<dynamic>? ?? [])
          .map((e) => Participant.fromJson(e))
          .toList(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      name: json['name'] ?? "Unnamed User",
      email: json['email'] ?? "",
      image: json['image'] ?? "",
      user: json['user'] ?? "",
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
  final List<String> imageUrl;
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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      text: json['text'] ?? "",
      seen: json['seen'] ?? false,
      sender: json['sender'] ?? "",
      receiver: json['receiver'] ?? "",
      chat: json['chat'] ?? "",
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt']),
      updatedAt: DateTime.tryParse(json['updatedAt']),
    );
  }
}
