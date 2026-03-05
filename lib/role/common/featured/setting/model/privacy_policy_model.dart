import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';

class StaticContentResponse {
  final bool success;
  final int statusCode;
  final String message;

  final String title;
  final String description;

  StaticContentResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.title,
    required this.description,
  });

  factory StaticContentResponse.fromJson(dynamic json) {
    return StaticContentResponse(
      success: JsonHelper.boolVal(json?['success']),
      statusCode: JsonHelper.intVal(json?['statusCode']),
      message: JsonHelper.stringVal(json?['message']),
      title: JsonHelper.stringVal(json?['data']?['title'] ?? "No Title"),
      description: JsonHelper.stringVal(
        json?['data']?['description'] ?? "No Content Found",
      ),
    );
  }
}
