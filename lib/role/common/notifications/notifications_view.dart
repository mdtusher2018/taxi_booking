import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/role/common/notifications/notification_model.dart';
import 'package:taxi_booking/role/common/notifications/notifications_controller.dart';

class NotificationView extends ConsumerStatefulWidget {
  const NotificationView({super.key});

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myNotificationsControllerProvider.notifier).load();
    });

    final controller = ref.read(myNotificationsControllerProvider.notifier);
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myNotificationsControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Notification', leading: SizedBox()),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: CustomText(
            title: e.toString(),
            style: CommonStyle.textStyleMedium(color: Colors.white),
          ),
        ),
        data: (pagination) {
          final notifications = pagination.items;

          if (notifications.isEmpty) {
            return noNotification();
          }

          final grouped = _groupNotifications(notifications);

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(myNotificationsControllerProvider.notifier).refresh();
            },
            child: ListView(
              controller: scrollController,
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Section Header
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

                    /// Notifications
                    ...entry.value.map((item) {
                      return CustomNotificationTile(
                        imageUrl: _resolveIcon(item.type),
                        title: item.message,
                        subtitle: item.description,
                        dateTime: item.date,
                        onTap: () {
                          debugPrint("Tapped notification: ${item.id}");
                        },
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  String _resolveIcon(String type) {
    switch (type) {
      case 'booking':
        return "https://cdn-icons-png.flaticon.com/512/1827/1827392.png";
      case 'payment':
        return "https://cdn-icons-png.flaticon.com/512/3135/3135706.png";
      default:
        return "https://cdn-icons-png.flaticon.com/512/1827/1827392.png";
    }
  }

  Widget noNotification() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          // Wrapped icon inside a circular container with shadow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mainColor, // Light background color
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4), // Slight shadow under the icon
                ),
              ],
            ),
            padding: EdgeInsets.all(
              16,
            ), // Padding for the icon within the container
            child: Icon(
              Icons.notifications_off,
              size: 60,
              color: Colors.blueGrey[400], // Softer color for elegance
            ),
          ),
          SizedBox(height: 20),
          Text(
            "No Notifications Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800], // Darker color for the title
            ),
          ),
          SizedBox(height: 12),
          Text(
            "You will be notified when there are updates. Please check back later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey[600], // Lighter text color
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 24),
          CustomButton(
            title: "Refresh Notifications",
            onTap: () async {
              ref.read(myNotificationsControllerProvider.notifier).refresh();
            },
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Map<String, List<NotificationItem>> _groupNotifications(
    List<NotificationItem> notifications,
  ) {
    final Map<String, List<NotificationItem>> grouped = {};

    for (final notification in notifications) {
      final date = notification.date;
      String key;

      if (_isToday(date)) {
        key = 'Today';
      } else if (_isYesterday(date)) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMM dd, yyyy').format(date);
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(notification);
    }

    return grouped;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}

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
      title: CustomText(title: title, style: CommonStyle.textStyleMedium()),
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
            style: CommonStyle.textStyleSmall(
              size: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
