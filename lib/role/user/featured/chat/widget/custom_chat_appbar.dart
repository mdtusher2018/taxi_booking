import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class CustomChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String userImage;
  final String userName;
  final String targetUserId;

  const CustomChatAppbar({
    super.key,
    required this.userImage,
    required this.userName,
    required this.targetUserId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(userImage), radius: 20),
            const SizedBox(width: 8),
          ],
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userName, style: CommonStyle.textStyleMedium()),
          Text(
            "Online",
            style: CommonStyle.textStyleSmall(color: Colors.green),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: () {},
        ),
        // IconButton(
        //   icon: const Icon(Icons.videocam, color: Colors.blue),
        //   onPressed: () => callController.startVideoCall(targetUserId, userName),
        // ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
