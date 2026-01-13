import 'dart:developer';
import 'package:taxi_booking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔹 BACKGROUND HANDLER (TOP LEVEL REQUIRED)
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Background message: ${message.messageId}');
  }

  /// 🔹 INITIALIZE EVERYTHING
  static Future<void> init() async {
    // Permissions (iOS + Android 13)
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // FCM token
    String? token = await _messaging.getToken();
    log('FCM Token: $token');

    // Local notification setup
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings);

    // Foreground listener
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Background listener
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Notification tap (background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification clicked (background)');
      log(message.data.toString());
      // 👉 Navigate using GetX if needed
    });
  }

  /// 🔹 FOREGROUND MESSAGE HANDLER
  static void _onForegroundMessage(RemoteMessage message) {
    log('Foreground message received');
    _showLocalNotification(message);
  }

  /// 🔹 SHOW LOCAL NOTIFICATION
  static void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      details,
      payload: message.data.toString(),
    );
  }
}
