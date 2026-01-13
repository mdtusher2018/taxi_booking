import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/add_vehical_response.dart';

class EditVehicleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Vehicle data;

  EditVehicleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory EditVehicleResponse.fromJson(Map<String, dynamic> json) {
    return EditVehicleResponse(
      success: json['success'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: Vehicle.fromJson(json['data']),
    );
  }
}
