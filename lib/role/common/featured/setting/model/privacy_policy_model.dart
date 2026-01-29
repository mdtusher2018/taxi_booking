import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';

class PrivacyPolicyResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<PrivacyPolicy> data;

  PrivacyPolicyResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PrivacyPolicyResponse.fromJson(dynamic json) {
    return PrivacyPolicyResponse(
      success: JsonHelper.boolVal(json?['success']),
      statusCode: JsonHelper.intVal(json?['statusCode']),
      message: JsonHelper.stringVal(json?['message']),
      data:
          (json?['data'] as List<dynamic>?)
              ?.map((e) => PrivacyPolicy.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PrivacyPolicy {
  final String id;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PrivacyPolicy({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrivacyPolicy.fromJson(dynamic json) {
    return PrivacyPolicy(
      id: JsonHelper.stringVal(json?['_id']),
      title: JsonHelper.stringVal(json?['title']),
      description: JsonHelper.stringVal(json?['description']),
      createdAt: JsonHelper.parseDate(json?['createdAt']),
      updatedAt: JsonHelper.parseDate(json?['updatedAt']),
    );
  }
}
