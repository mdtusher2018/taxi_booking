// lib/app/modules/notification/widget/custom_notification_tile.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../resource/common_widget/custom_text.dart';
import '../../../../resource/utilitis/common_style.dart';

class CustomNotificationTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final DateTime dateTime;
  final VoidCallback? onTap;

  const CustomNotificationTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.dateTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 25,
      ),
      title: CustomText(
        title: title,
        style: CommonStyle.textStyleMedium(),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: subtitle,
            style: CommonStyle.textStyleSmall(size: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          CustomText(
            title: formattedTime,
            style: CommonStyle.textStyleSmall(size: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
