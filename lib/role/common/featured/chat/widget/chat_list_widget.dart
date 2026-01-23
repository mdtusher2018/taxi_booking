// lib/app/modules/chat/widget/custom_chat_tile.dart
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class CustomChatTile extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String lastMessage;
  final double rating;
  final VoidCallback? onTap;

  const CustomChatTile({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.lastMessage,
    required this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person, size: 30);
            },
          ),
        ),
      ),

      title: Row(
        children: [
          Expanded(
            child: Text(
              userName,
              style: CommonStyle.textStyleMedium(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Container(
        width: MediaQuery.sizeOf(context).width / 7,
        child: Row(
          children: [
            Icon(Icons.star, color: Colors.yellow.shade800, size: 16),
            CustomText(
              title: '(${rating.toStringAsFixed(1)})',
              style: CommonStyle.textStyleMedium(size: 12, color: Colors.black),
            ),
          ],
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: onTap,
    );
  }
}
