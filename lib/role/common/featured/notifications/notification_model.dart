import 'package:taxi_booking/core/model/pagenation_meta_model.dart';
import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';

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

  factory NotificationsResponse.fromJson(dynamic json) {
    return NotificationsResponse(
      success: JsonHelper.boolVal(json?['success']),
      statusCode: JsonHelper.intVal(json?['statusCode']),
      message: JsonHelper.stringVal(json?['message']),
      meta: Meta.fromJson(json?['meta']),
      data:
          (json?['data'] as List<dynamic>?)
              ?.map((x) => NotificationItem.fromJson(x))
              .toList() ??
          [],
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
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

  factory NotificationItem.fromJson(dynamic json) {
    return NotificationItem(
      id: JsonHelper.stringVal(json?['_id']),
      receiver: JsonHelper.stringVal(json?['receiver']),
      message: JsonHelper.stringVal(json?['message']),
      description: JsonHelper.stringVal(json?['description']),
      reference: JsonHelper.stringVal(json?['reference']),
      read: JsonHelper.boolVal(json?['read']),
      isDeleted: JsonHelper.boolVal(json?['isDeleted']),
      type: JsonHelper.stringVal(json?['type']),
      fcmToken: JsonHelper.stringVal(json?['fcmToken']),
      forAdmin: JsonHelper.boolVal(json?['forAdmin']),
      date: JsonHelper.parseDate(json?['date']),
      createdAt: JsonHelper.parseDate(json?['createdAt']),
      updatedAt: JsonHelper.parseDate(json?['updatedAt']),
    );
  }
}
