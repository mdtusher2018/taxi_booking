// notifications_response_model.dart

import 'package:taxi_booking/core/model/pagenation_meta_model.dart';

class NotificationsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Meta meta;
  final List<NotificationItem> data;

  NotificationsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.meta,
    required this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      meta: Meta.fromJson(json['meta']),
      data: List<NotificationItem>.from(
        json['data'].map((x) => NotificationItem.fromJson(x)),
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String receiver;
  final String message;
  final String description;
  final String reference;
  final bool read;
  final bool isDeleted;
  final String type;
  final String fcmToken;
  final bool forAdmin;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationItem({
    required this.id,
    required this.receiver,
    required this.message,
    required this.description,
    required this.reference,
    required this.read,
    required this.isDeleted,
    required this.type,
    required this.fcmToken,
    required this.forAdmin,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'],
      receiver: json['receiver'],
      message: json['message'],
      description: json['description'],
      reference: json['reference'],
      read: json['read'],
      isDeleted: json['isDeleted'],
      type: json['type'],
      fcmToken: json['fcmToken'],
      forAdmin: json['forAdmin'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
