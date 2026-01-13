import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import '../widget/custom_notifications_tile.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dummy notification data
    final List<Map<String, dynamic>> notifications = [
      {
        "image": "https://cdn-icons-png.flaticon.com/512/1827/1827392.png",
        "title": "Booking Confirmed",
        "subtitle": "Your taxi booking has been confirmed.",
        "date": DateTime.now(),
      },
      {
        "image": "https://cdn-icons-png.flaticon.com/512/1827/1827392.png",
        "title": "Driver Arrived",
        "subtitle": "Your driver is waiting.",
        "date": DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        "image": "https://cdn-icons-png.flaticon.com/512/1827/1827392.png",
        "title": "Payment Received",
        "subtitle": "You paid successfully.",
        "date": DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        "image": "https://cdn-icons-png.flaticon.com/512/1827/1827392.png",
        "title": "Promo Offer",
        "subtitle": "Get 20% off your next ride.",
        "date": DateTime.now().subtract(const Duration(days: 2)),
      },
    ];

    /// Grouping logic
    Map<String, List<Map<String, dynamic>>> groupedNotifications = {};

    for (var notification in notifications) {
      DateTime date = notification['date'];
      String key;

      if (isToday(date)) {
        key = 'Today';
      } else if (isYesterday(date)) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMM dd, yyyy').format(date);
      }

      groupedNotifications.putIfAbsent(key, () => []);
      groupedNotifications[key]!.add(notification);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Notification', leading: SizedBox()),
      body: ListView(
        children:
            groupedNotifications.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Section header (Today, Yesterday, etc.)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  /// Notifications under that group
                  ...entry.value.map((notification) {
                    return CustomNotificationTile(
                      imageUrl: notification["image"],
                      title: notification["title"],
                      subtitle: notification["subtitle"],
                      dateTime: notification["date"],
                      onTap: () {
                        print("Tapped on ${notification["title"]}");
                      },
                    );
                  }).toList(),
                ],
              );
            }).toList(),
      ),
    );
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isYesterday(DateTime date) {
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}
