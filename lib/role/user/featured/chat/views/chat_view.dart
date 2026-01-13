import 'package:flutter/material.dart';
import 'package:taxi_booking/role/user/featured/chat/views/message_view.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import '../widget/chat_list_widget.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chatList = [
      {
        "image": "https://i.pravatar.cc/100?img=1",
        "name": "John Doe",
        "lastMessage": "Hey, your ride is ready!",
        "rating": 4.5,
      },
      {
        "image": "https://i.pravatar.cc/100?img=2",
        "name": "Emma Watson",
        "lastMessage": "I'll be there in 5 mins.",
        "rating": 4.8,
      },
      {
        "image": "https://i.pravatar.cc/100?img=3",
        "name": "Michael Smith",
        "lastMessage": "Thanks for the great service.",
        "rating": 4.2,
      },
      {
        "image": "https://i.pravatar.cc/100?img=4",
        "name": "Sophia Johnson",
        "lastMessage": "Great ride today!",
        "rating": 4.9,
      },
      {
        "image": "https://i.pravatar.cc/100?img=5",
        "name": "James Anderson",
        "lastMessage": "See you next time.",
        "rating": 4.4,
      },
      {
        "image": "https://i.pravatar.cc/100?img=6",
        "name": "Olivia Brown",
        "lastMessage": "Can you come earlier?",
        "rating": 4.7,
      },
      {
        "image": "https://i.pravatar.cc/100?img=7",
        "name": "William Jones",
        "lastMessage": "I'm on my way!",
        "rating": 4.6,
      },
      {
        "image": "https://i.pravatar.cc/100?img=8",
        "name": "Ava Garcia",
        "lastMessage": "Thank you for waiting.",
        "rating": 4.5,
      },
      {
        "image": "https://i.pravatar.cc/100?img=9",
        "name": "Liam Martinez",
        "lastMessage": "Great experience!",
        "rating": 4.8,
      },
      {
        "image": "https://i.pravatar.cc/100?img=10",
        "name": "Isabella Lee",
        "lastMessage": "You’re the best driver.",
        "rating": 5.0,
      },
      {
        "image": "https://i.pravatar.cc/100?img=11",
        "name": "Noah Wilson",
        "lastMessage": "Be there shortly.",
        "rating": 4.3,
      },
      {
        "image": "https://i.pravatar.cc/100?img=12",
        "name": "Mia Taylor",
        "lastMessage": "Let’s meet at the corner.",
        "rating": 4.6,
      },
      {
        "image": "https://i.pravatar.cc/100?img=13",
        "name": "Lucas Thomas",
        "lastMessage": "Smooth ride, thank you!",
        "rating": 4.7,
      },
      {
        "image": "https://i.pravatar.cc/100?img=14",
        "name": "Charlotte White",
        "lastMessage": "I’ll rate you 5 stars!",
        "rating": 4.9,
      },
      {
        "image": "https://i.pravatar.cc/100?img=15",
        "name": "Benjamin Harris",
        "lastMessage": "Ride was excellent.",
        "rating": 4.5,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Messages', leading: SizedBox()),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return CustomChatTile(
            imageUrl: chat["image"],
            userName: chat["name"],
            lastMessage: chat["lastMessage"],
            rating: chat["rating"],
            onTap: () {
              // Navigate to chat details
              print("Tapped on ${chat["name"]}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MessageView(
                      userImage: chat["image"],
                      userName: chat["name"],
                      targetUserId: '12345678',
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
