import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';

class SupportInfoResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String adminId;

  SupportInfoResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.adminId,
  });

  factory SupportInfoResponse.fromJson(dynamic json) {
    return SupportInfoResponse(
      statusCode: JsonHelper.intVal(json['statusCode']),
      success: JsonHelper.boolVal(json['success']),
      message: JsonHelper.stringVal(json['message']),
      adminId: JsonHelper.stringVal(json['data']?['adminId']),
    );
  }
}
